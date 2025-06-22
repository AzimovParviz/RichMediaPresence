//
//  Rich_media_presenceApp.swift
//  Rich media presence
//
//  Created by rosenberg on 13.6.2025.
//

import SwiftUI
import MediaRemoteAdapter

@main
struct Rich_media_presenceApp: App {
//    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var nowPlayingModel = NowPlayingModel()
    var body: some Scene {
        MenuBarExtra("Rich media presence", systemImage: "dot.radiowaves.left.and.right") {
            Menu(nowPlayingModel: nowPlayingModel)
//                .overlay(alignment: .topTrailing) {
//                    Button(
//                        "sync discord",
//                        systemImage: "xmark.circle.fill"
//                    ) {
//                        discordStuff()
//                        print("hehe")
//                    }
//                }
                .frame(width: 300, height: 300)
                Text("Support me on kofi xD")
        }
        .menuBarExtraStyle(.window)
    }
}
