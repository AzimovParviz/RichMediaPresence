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
//        discordInit(1320005612678942781)
        nowPlayingController.mediaController.onTrackInfoReceived = {
             trackInfo in
            self.title = trackInfo.payload.title
            self.artist = trackInfo.payload.artist
            self.album = trackInfo.payload.album
            self.artwork = trackInfo.payload.artwork
            var songInfo = SongInformation()
            self.title?.withCString { strncpy(&songInfo.title, $0, MemoryLayout.size(ofValue: songInfo.title)) }
            self.artist?.withCString { strncpy(&songInfo.artist, $0, MemoryLayout.size(ofValue: songInfo.artist)) }
            self.album?.withCString { strncpy(&songInfo.duration, $0, MemoryLayout.size(ofValue: songInfo.duration)) }
            DispatchQueue.global(qos: .background).async {
                self.discordController.updateDiscordLoop(songInformation: songInfo)
            }
//            print("trackInfo: \(trackInfo)")
        
        }
    }
    
//    func updateNowPlaying() {
//        
//    }
}
