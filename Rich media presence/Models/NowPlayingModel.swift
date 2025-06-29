//
//  NowPlayingModel.swift
//  Rich media presence
//
//  Created by rosenberg on 20.6.2025.
//

import Foundation
import AppKit

class NowPlayingModel: ObservableObject {
    @Published var title: String?
    @Published var artist: String?
    @Published var album: String?
    @Published var duration: TimeInterval?
    @Published var artwork: NSImage?
    
    private let nowPlayingController: NowPlayingController = NowPlayingController();
    private let discordController: DiscordController = DiscordController();
    
    init() {
        nowPlayingController.setupAndStart();
        nowPlayingController.mediaController.onTrackInfoReceived = {
             trackInfo in
            self.title = trackInfo.payload.title
            self.artist = trackInfo.payload.artist
            self.album = trackInfo.payload.album
            self.artwork = trackInfo.payload.artwork
            DispatchQueue.global(qos: .background).async {
                self.discordController.updateDiscordLoop(artist: self.artist ?? "Unknown Artist", title: self.title ?? "Unknown Title", album: self.album ?? "Unknown Album")
            }
        }
    }
}
