//
//  DiscordController.swift
//  Rich media presence
//
//  Created by rosenberg on 22.6.2025.
//

public class DiscordController {
    //Even sweepier presence
    var clientId: Int64 = 1386305564031717467
   var songInformation: SongInformation?
    
    init(clientId: Int64 = 1386305564031717467) {
        discordInit(clientId)
    }
    
    func updateDiscordLoop(songInformation: SongInformation) {
        self.songInformation = songInformation
        updateLoop(self.songInformation!)
    }

}
