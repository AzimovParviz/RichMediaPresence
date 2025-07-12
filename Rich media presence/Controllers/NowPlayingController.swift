//
//  NowPlaying.swift
//  Rich media presence
//
//  Created by rosenberg on 20.6.2025.
//
import MediaRemoteAdapter

import Foundation

class NowPlayingController {
    let mediaController = MediaController()
    var currentTrackDuration: TimeInterval = 0
    init() {
        // Handle incoming track data
        mediaController.onTrackInfoReceived = { trackInfo in
            print("Now Playing: \(trackInfo.payload.title ?? "N/A")")
            self.currentTrackDuration = (trackInfo.payload.durationMicros ?? 0) / 1_000_000
        }
        
        // Optionally handle cases where JSON decoding fails
        mediaController.onDecodingError = { error, data in
            print("Failed to decode JSON: \(error)")
            print("Raw JSON data: \(String(data: data, encoding: .utf8) ?? "(none)")")
        }

        // Handle listener termination
        mediaController.onListenerTerminated = {
            print("MediaRemoteAdapter listener process was terminated.")
        }
    }
    func setupAndStart() {
        mediaController.startListening()
    }
}
