//
//  NowPlayingModel.swift
//  Rich media presence
//
//  Created by rosenberg on 20.6.2025.
//

import AppKit
import Foundation

extension NSImage {
    var base64String: String? {
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
            ) else {
                print("Couldn't create bitmap representation")
                return nil
        }
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        draw(at: NSZeroPoint, from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()
        
        guard let data = rep.representation(using: NSBitmapImageRep.FileType.png, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]) else {
            print("Couldn't create PNG")
            return nil
        }
        
        // With prefix
        // return "data:image/png;base64,\(data.base64EncodedString(options: []))"
        // Without prefix
        return data.base64EncodedString(options: [])
    }
}

class NowPlayingModel: ObservableObject {
    private var shouldChange: Bool = true
    @Published var title: String?
    @Published var artist: String?
    @Published var album: String?
    @Published var duration: Double?
    @Published var elapsed: Double?
    @Published var artwork: NSImage?

    private let nowPlayingController: NowPlayingController =
        NowPlayingController()
    private let discordController: DiscordController = DiscordController()

    // TODO: is all of this logic supposed to be here in the init func
    init() {
        nowPlayingController.setupAndStart()
        // This triggers whenever you pause or unpause or whenever a video stream buffers
        nowPlayingController.mediaController.onTrackInfoReceived = {
            trackInfo in
            if trackInfo.payload.title != self.title
                || trackInfo.payload.artist != self.artist
                || trackInfo.payload.album != self.album
            {
                self.shouldChange = true
                print("Should change")
            } else {
                self.shouldChange = false
                print("Shoudln't change")
            }
            if self.shouldChange {
                self.title = trackInfo.payload.title
                self.artist = trackInfo.payload.artist
                self.album = trackInfo.payload.album
                self.artwork = trackInfo.payload.artwork
                self.duration = trackInfo.payload.durationMicros
                self.elapsed = trackInfo.payload.elapsedTimeMicros
//                if self.artwork != nil {
//                    uploadAsset(base64Image: self.artwork!.base64String!)
//                }
                DispatchQueue.global(qos: .background).async {
                    self.discordController.updateDiscordPresence(
                        artist: (self.artist != nil)
                            ? self.artist!.utf8.count > 128
                                ? String(self.artist!.utf8Prefix(124)) + "..."
                                : self.artist : nil,
                        title: (self.title != nil)
                            ? self.title!.utf8.count > 128
                                ? String(self.title!.utf8Prefix(124)) + "..."
                                : self.title : nil,
                        album: (self.album != nil)
                            ? self.album!.utf8.count > 128
                                ? String(self.album!.utf8Prefix(124)) + "..."
                                : self.album : nil,
                        duration: (self.duration != nil)
                        ? (self.duration!)
                        : nil,
                        elapsed: (self.elapsed != nil)
                        ? (self.elapsed!)
                        : nil
                    )
                }
            }
        }
    }
}
