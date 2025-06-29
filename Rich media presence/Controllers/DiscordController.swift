//
//  DiscordController.swift
//  Rich media presence
//
//  Created by rosenberg on 22.6.2025.
//
import Foundation

//TODO: see if OpaquePointer type makes sense to be used in place of other pointers.

//RichPresenceUpdateCallback
typealias RPCallback = @convention(c) (
    UnsafeMutablePointer<Discord_ClientResult>?, UnsafeMutableRawPointer?
) -> Void

typealias DCLoggingCallback = @convention(c) (
    Discord_String, Discord_LoggingSeverity, UnsafeMutableRawPointer?
) -> Void

func convertDStoString(_ dStr: Discord_String) -> String {
    // Converting the UInt8 pointer to a CChar buffer pointer
    let dsString = dStr.ptr.withMemoryRebound(
        to: CChar.self,
        capacity: Int(dStr.size)
    ) {
        UnsafeBufferPointer(start: $0, count: Int(dStr.size))
    }
    //converting to a CChar array
    var a = Array(dsString)
    //null terminating the string
    a.append(0)
    let convertedString = String(cString: a)
    //    print("converted string: \(convertedString)")
    return convertedString
}

// These are outside the class cause we need to use these in callback functions and callback functions to be used in C need to be outside of the class scope
var applicationId: UInt64 = 1_386_305_564_031_717_467
//var songInfo: SongInformation?
//var name = "Rich media presence".withCString { cString in
//    UnsafeMutablePointer<Discord_String>.allocate(capacity: 1)
//}

var verifier: Discord_AuthorizationCodeVerifier =
    Discord_AuthorizationCodeVerifier()
var discordClient: Discord_Client = Discord_Client()
var discordActivity: Discord_Activity = Discord_Activity()
var discordChallenge: Discord_AuthorizationCodeChallenge =
    Discord_AuthorizationCodeChallenge()
var authArgs: Discord_AuthorizationArgs = Discord_AuthorizationArgs()

var cientResult: Discord_ClientResult = Discord_ClientResult()

private func loggingCallback(
    someStr: Discord_String,
    severity: Discord_LoggingSeverity,
    userData: UnsafeMutableRawPointer?
) {
    print(convertDStoString(someStr))
}

private func updatePresenceCallback(
    result: UnsafeMutablePointer<Discord_ClientResult>!,
    userData: UnsafeMutableRawPointer?
) {
    print("running the sweep presence update callback")
    Discord_Activity_ApplicationId(
        &discordActivity,
        &applicationId
    )

    if Discord_ClientResult_Successful(result) {
        var stringResult: Discord_String = Discord_String()
        Discord_ClientResult_ToString(result, &stringResult)
        print("result success", convertDStoString(stringResult))
    } else {
        print("failed to update presence")
    }
}

public class DiscordController {
    var state: Discord_String = DiscordString(val: "Song name")
        .convertToDiscordString()
    var details: Discord_String = DiscordString(
        val: "Artist name and maybe album too"
    )
    .convertToDiscordString()
    var name: Discord_String = DiscordString(val: "Rich media presence")
        .convertToDiscordString()

    init() {
        Discord_Client_Init(&discordClient)
        Discord_Client_SetApplicationId(&discordClient, applicationId)
        verifyCode()
        Discord_AuthorizationArgs_Init(&authArgs)
        Discord_AuthorizationArgs_SetClientId(
            &authArgs,
            applicationId as __uint64_t
        )
        //FIXME: wtf dude really? maybe there's an init or smth
        var scopes: Discord_String = Discord_String()
        Discord_Client_GetDefaultPresenceScopes(&scopes)
        Discord_AuthorizationArgs_SetScopes(
            &authArgs,
            scopes
        )
        Discord_AuthorizationCodeChallenge_Init(&discordChallenge)
        Discord_AuthorizationCodeVerifier_SetChallenge(
            &verifier,
            &discordChallenge
        )
        let cb: DCLoggingCallback = loggingCallback
        Discord_Client_AddLogCallback(
            &discordClient,
            cb,
            nil,
            nil,
            Discord_LoggingSeverity_Verbose
        )
        //Don't need to do every time?
        //authorizeClient(&discordClient, &authArgs)

        Discord_Activity_Init(&discordActivity)
        Discord_Client_Connect(&discordClient)
    }

    func updateDiscordLoop(artist: String?, title: String?, album: String?) {
        print("running the update loop and callbacks")
        //FIXME: we really need to not do this class thing
        let songName: DiscordString = DiscordString(val: title!)
        let artistName: DiscordString = DiscordString(val: artist!)
        var _: DiscordString = DiscordString(val: album!)
        self.state = songName.convertToDiscordString()
        self.details = artistName.convertToDiscordString()
        Discord_Activity_SetState(&discordActivity, &state)
        Discord_Activity_SetDetails(&discordActivity, &details)
        Discord_Activity_SetName(&discordActivity, name)
        updateDiscordPresence()
        Discord_RunCallbacks()
    }

    func updateDiscordPresence() {
        let cb: RPCallback = updatePresenceCallback
        Discord_Client_UpdateRichPresence(
            &discordClient,
            &discordActivity,
            cb,
            nil,
            nil
        )
    }

    func verifyCode() {
        Discord_Client_CreateAuthorizationCodeVerifier(
            &discordClient,
            &verifier
        )
    }
}
