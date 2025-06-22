//
//  Menu.swift
//  Rich media presence
//
//  Created by rosenberg on 20.6.2025.
//

import SwiftUI

struct Menu: View {
    @StateObject var nowPlayingModel: NowPlayingModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let artwork = nowPlayingModel.artwork{
                Image(nsImage: artwork)
            }
            if let title = nowPlayingModel.title{
                Text(title)
            }
            if let artist = nowPlayingModel.artist{
                Text(artist)
            }
            if let album = nowPlayingModel.album{
                Text(album)
            }
        }
    }
}

#Preview {
    Menu(nowPlayingModel: NowPlayingModel())
    
}
