DISCORD_SDK_URL = https://storage.googleapis.com/discord-slayer-sdk-artifacts/discord_partner_sdk/763870b3777c80fd978f7ba35bb7bc0178c55098/release/DiscordSocialSdk-1.4.9649.zip?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=slayer-sdk-token-creator%40discord-production.iam.gserviceaccount.com%2F20250704%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20250704T181139Z&X-Goog-Expires=3600&X-Goog-SignedHeaders=host&X-Goog-Signature=4516d12acd48ef904093996d12174fd0aca8a368012c94ff6d7e19d01af9f827a9fcc84deefaded1139de29f23538a9eeaa08b59b46f301c4476e20b2eb6f6d444358eadc9ec0147203a1860b099fb9de97ae9fce718adf2122b3265b93287ae7c326df3d3052d4309605792f46f4231e98a2296e4dbbdf28e5780fd2e580ea71fbd21b51893639ae64d5297beed857442a59e99fb58be0ab53cde53401f604fb0c295cae08ef7cd2dd7b02a927ff8c018d8930ffb8114bca619ab0aef6d74426df4fe2c6cbcb00a962505928eea8e022fa2be40d30c7a913daec34d3fc12021d415e23ac875094b974f7df219161e8d5c8e7e67c29ccce40314cf3fa2e841b3
DISCORD_SDK_ZIP = discord_social_sdk.zip
DISCORD_SDK_DIR = DiscordPresence
LIB_DIR = lib
JOBS = $(shell sysctl -n hw.ncpu)

BINARY_NAME = mediapresence

.PHONY: all download clean unzip

all: clean download unzip build

unzip:
	@echo "Unzipping discord_social_sdk"
	unzip $(DISCORD_SDK_ZIP) "c/discord_game_sdk.h" -d $(DISCORD_SDK_DIR)
	mv $(DISCORD_SDK_DIR)/include/cdiscord.h $(DISCORD_SDK_DIR)/discord_game_sdk.h
	unzip $(DISCORD_SDK_ZIP) "lib/release/libdiscord_game_sdk.dylib" -d $(LIB_DIR)

download:
	@echo "Downloading $(DISCORD_SDK_ZIP).zip"
	curl -o $(DISCORD_SDK_ZIP) $(DISCORD_SDK_URL)

debug:
	xcodebuild -scheme Rich\ media\ presence -jobs $(JOBS) -configuration Debug -derivedDataPath build/Debug
	xattr -w com.apple.xcode.CreatedByBuildSystem true build/Debug/Rich\ Media\ Presence.app

build:
	xcodebuild -scheme Rich\ media\ presence -jobs $(JOBS) -configuration Release -derivedDataPath build/Release
	xattr -w com.apple.xcode.CreatedByBuildSystem true build/Debug/Rich\ Media\ Presence.app

archive:
	xcodebuild -scheme Rich\ media\ presence -jobs $(JOBS) -configuration Release -derivedDataPath build/Release archive
	xattr -w com.apple.xcode.CreatedByBuildSystem true build/Debug/Rich\ Media\ Presence.app

install:
	xcodebuild -scheme Rich\ media\ presence -jobs $(JOBS) -configuration Release install

clean:
	xcodebuild -alltargets clean
