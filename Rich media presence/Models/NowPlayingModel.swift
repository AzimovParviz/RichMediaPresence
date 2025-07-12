//
//  NowPlayingModel.swift
//  Rich media presence
//
//  Created by rosenberg on 20.6.2025.
//

import AppKit
import Foundation

class NowPlayingModel: ObservableObject {
    private var shouldChange: Bool = true
    @Published var title: String?
    @Published var artist: String?
    @Published var album: String?
    @Published var duration: TimeInterval?
    @Published var artwork: NSImage?

    private let nowPlayingController: NowPlayingController =
        NowPlayingController()
    private let discordController: DiscordController = DiscordController()

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
                DispatchQueue.global(qos: .background).async {
                    self.discordController.updateDiscordPresence(
                        artist: (self.artist != nil)
                            ? self.artist!.utf8.count > 128
                                ? String(self.title!.utf8.prefix(124))! + "..."
                                : self.artist : nil,
                        title: (self.title != nil)
                            ? self.title!.utf8.count > 128
                                ? String(self.title!.utf8.prefix(124))! + "..."
                                : self.title : nil,
                        album: (self.album != nil)
                            ? self.album!.utf8.count > 128
                                ? String(self.title!.utf8.prefix(124))! + "..."
                                : self.album : nil
                    )
                }
            }
        }
    }
}
