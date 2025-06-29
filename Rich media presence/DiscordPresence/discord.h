//
//  discord.h
//  Rich media presence
//
//  Created by rosenberg on 20.6.2025.
//

#ifndef discord_h
#define discord_h

#include <stdio.h>
#include "discord-files/discord_game_sdk.h"
#include "cdiscord.h"

#endif /* discord_h */

// Define the SongInformation structure
struct SongInformation {
    char title[128];
    char artist[128];
    char duration[128];
};

struct Application
{
    struct IDiscordCore *core;
    struct IDiscordUserManager *users;
    struct IDiscordActivityManager *activities;
    struct IDiscordApplicationManager *application;
    bool DiscordOk;
    DiscordUserId user_id;
};

struct Application app;
struct SongInformation songInformation;

enum ApplicationName {
    unknown,
    Safari,
    Firefox,
    YouTube,
    Twitch,
    Spotify,
    f2k,
    AppleMusic,
    mpv
} mediaClientName;

const char *mediaClientIcons[] = {
    "unknown_icon",
    "safari_icon",
    "firefox_icon",
    "youtube_icon",
    "twitch_icon",
    "spotify_icon",
    "f2k_icon",
    "apple_music_icon",
    "mpv_icon"};

char appName[128];

void onGetTokenCallback(Discord_ClientResult* result, Discord_String accessToken, Discord_String refreshToken, Discord_AuthorizationTokenType tokenType, int32_t expiresIn, Discord_String scope, void* userData);

void onAuthorizeCallback(Discord_ClientResult* result, Discord_String code, Discord_String redirectUri, void* userData);

void authorizeClient(Discord_Client *client, Discord_AuthorizationArgs *authArgs);
void onUpdateRPCallback(Discord_ClientResult* result, void* userData);
void updateRP(struct SongInformation songInformation, Discord_Client* client, Discord_Activity* activity,void* userData);
