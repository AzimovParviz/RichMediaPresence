//
//  discord.c
//  Rich media presence
//
//  Created by rosenberg on 20.6.2025.
//

#include "discord.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>

#include "cdiscord.h"
#define DISCORD_REQUIRE(x) assert(x == DiscordResult_Ok)
#ifndef OSX_VER
#define OSX_VER STR("15.5.0")
#endif

void onGetTokenCallback(Discord_ClientResult* result, Discord_String accessToken, Discord_String refreshToken,
                        Discord_AuthorizationTokenType tokenType, int32_t expiresIn, Discord_String scope, void* userData) {
    if (Discord_ClientResult_Successful(result)) {
        printf("🔓 Access token received: %s\n", accessToken.ptr);
        // Use the access token for further operations
    } else {
//        printf("❌ Failed to get access token: %s\n", Discord_ClientResult_Error(result).ptr);
    }
}

void onAuthorizeCallback(Discord_ClientResult* result, Discord_String code, Discord_String redirectUri, void* userData) {
    if (Discord_ClientResult_Successful(result)) {
        printf("✅ Authorization successful! Code: %s, Redirect URI: %s\n", code.ptr, redirectUri.ptr);

        // Exchange the authorization code for an access token
        Discord_Client* client = (Discord_Client*)userData;
        struct Discord_String codeVerifier;
        Discord_Client_GetToken(client, 1386305564031717467, code, codeVerifier, redirectUri, onGetTokenCallback, NULL, NULL);
    } else {
        printf("❌ Authorization failed");
    }
}

void onUpdateRPCallback(Discord_ClientResult* result, void* userData) {
    //    Discord_Activity* activity = (Discord_Activity*)userData;
    if (Discord_ClientResult_Successful(result)) {
        printf("Works?");
    }
    else {
        Discord_String errorStr;
//        printf("❌ Authorization failed: %s\n", Discord_ClientResult_ToString(result, &errorStr));
    }
}

void updateRP(struct SongInformation songInformation, Discord_Client* client, Discord_Activity* activity,void* userData) {
//    Discord_Client* client = (Discord_Client*)userData;
    Discord_Client_UpdateRichPresence(client, activity, onUpdateRPCallback, userData, NULL);
}

void authorizeClient(Discord_Client *client, Discord_AuthorizationArgs *authArgs) {
    Discord_Client_Authorize(client, authArgs, onAuthorizeCallback, NULL, client);
}
