//
//  updatePresence.swift
//  Rich media presence
//
//  Created by rosenberg on 15.6.2025.
//
import unistd

class updatePresence {
    
    var clientId: UInt64 = 1320005612678942781
    
    var running: Bool = true

    
    init () {
       
    }
    
    func discordInit(clientId: UInt64) {
        print("Initializing Discord")
    }
    
    func updateLoop() {
        while running {
            usleep(166667 * 2)
        }
    }
}
