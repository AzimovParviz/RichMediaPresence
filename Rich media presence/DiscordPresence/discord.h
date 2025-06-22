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
//struct SongInformation songInformation;

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

// Function to initialize Discord
void discordInit(DiscordClientId clientId);

// Function to read song information from a file or AppleScript output
bool readFileOutputSongInfo(FILE *infoFile, struct SongInformation *songInformation);
void readSongInformation(struct SongInformation *songInformation);

// Function to update Discord presence with song information
static bool updateDiscordPresence(struct SongInformation *songInformation);

// Function to run the update loop in a separate thread
void *updateLoop(struct SongInformation songInformation);
