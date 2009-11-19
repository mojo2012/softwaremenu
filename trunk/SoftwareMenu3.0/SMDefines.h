/*
 *  SMDefines.h
 *  SoftwareMenu
 *
 *  Created by Thomas Cool on 11/11/09.
 *  Copyright 2009 Thomas Cool. All rights reserved.
 *
 */

#define BRLocalizedString(key, comment)								[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, tbl, comment)				[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(tbl)]
#define BRLocalizedStringFromTableInBundle(key, tbl, obj, comment)	[BRLocalizedStringManager appliance:(obj) localizedStringForKey:(key) inFile:(tbl)]
#define kSMDownloaderDone           @"kSMDownloaderDone"

#define DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"
#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"
#define PHOTO_FAVORITES         @"PhotoFavorites"

//#define SCREEN_SAVER_SLIDESHOW  @"Screensaver_Slideshow"
#define SCREEN_SAVER_SPIN_FREQ  @"Screensaver_Spin"
#define SCREEN_SAVER_TYPE       @"ScreensaverType"
#define SCREEN_SAVER_FLOATING   @"Floating"
#define SCREEN_SAVER_PARADE     @"Parade"
#define SCREEN_SAVER_SLIDESHOW  @"Slideshow"
#define SCREEN_SAVER_FOLDER     @"ScreensaverFolder"
#define SCREEN_SAVER_PLAYLIST          @"Screensaver_Playlist"
#define SCREEN_SAVER_TRANSITION        @"Screensaver_Transition"
#define SCREEN_SAVER_PAN_AND_ZOOM      @"Screensaver_Ken_Burns"
#define SCREEN_SAVER_TRANSITION_DIS    @"Screensaver_Trans_Dis"
#define SCREEN_SAVER_TRANSITION_RAND   @"Screensaver_Trans_Rand"
#define SCREEN_SAVER_REPEAT            @"Screensaver_Repeat"
#define SCREEN_SAVER_SECONDS_PER_S     @"Screensaver_Seconds"
#define SCREEN_SAVER_PHOTOS_SHUFFLE    @"Screensaver_Photos_Shuffle"
#define SCREEN_SAVER_USE_APPLE          @"Screensaver_Use_Apple"


#define BASE_URL					@"http://web.me.com/tomcool420/SoftwareMenu/"
#define FRAP_PATH					@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/"
#define BAK_PATH					@"/Users/frontrow/Documents/Backups/"
#define SCRIPTS_FOLDER				@"/Users/frontrow/Documents/scripts/"
 
#define IMAGES_FOLDER				@"~/Library/Application Support/SoftwareMenu/Images"
#define NAME_KEY					@"name_key_image"
#define TYPE_KEY					@"type_key_image"
#define SCRIPT_KEY					@"script_key_image"
#define MISC_KEY					@"misc_key_image"
#define FRAP_KEY					@"frap_key_image"
#define SM_KEY						@"software_menu_key_image"
#define LAYER_TYPE					@"layer_type"
#define LAYER_NAME					@"layer_name"
#define LAYER_DISPLAY				@"layer_display"
#define LAYER_INT					@"layer_integer"
#define UPDATE_URL					@"http://web.me.com/tomcool420/SoftwareMenu/updates.plist"
#define TRUSTED_URL					@"http://web.me.com/tomcool420/Trusted2.plist"
#define SCRIPTS_PLIST               @"com.apple.frontrow.SoftwareMenu.Scripts.plist"
#define TRUSTED_PLIST               @"com.apple.frontrow.SoftwareMenu.Trusted.plist"
#define PLUGINS						@"plugins"
#define SHOW_HIDDEN_KEY				@"ShowHidden"

#define SLIDESHOW_PLAYLIST          @"SlideShow_Playlist"
#define SLIDESHOW_TRANSITION        @"SlideShow_Transition"
#define SLIDESHOW_PAN_AND_ZOOM      @"SlideShow_Ken_Burns"
#define SLIDESHOW_TRANSITION_DIS    @"SlideShow_Trans_Dis"
#define SLIDESHOW_TRANSITION_RAND   @"SlideShow_Trans_Rand"
#define SLIDESHOW_MUSIC_PLAY        @"SlideShow_Music_Play"
#define SLIDESHOW_MUSIC_SHUFFLE     @"SlideShow_Music_Shuffle"
#define SLIDESHOW_REPEAT            @"SlideShow_Repeat"
#define SLIDESHOW_SECONDS_PER_S     @"SlideShow_Seconds"
#define SLIDESHOW_PHOTOS_SHUFFLE    @"SlideShow_Photos_Shuffle"


#define MAINMENU_PARADE_BOOL            @"ParadeOnMainMenu"
#define MAINMENU_SHOW_UPDATES_BOOL      @"ShowUpdatesOnMainMenu"
#define MAINMENU_SHOW_COLLECTIONS_BOOL  @"CollectionsOnMainMenu"
#define MAINMENU_SHOW_FAVORIES_BOOL     @"FavoritesOnMainMenu"

#define UPDATES_AVAILABLE           @"Updates_Availables"

typedef enum {
	// for originator kBREventOriginatorRemote
	kBREventRemoteActionMenu = 1,
	kBREventRemoteActionMenuHold,
	kBREventRemoteActionUp,
	kBREventRemoteActionDown,
	kBREventRemoteActionPlay,
	kBREventRemoteActionLeft,
	kBREventRemoteActionRight,
    
	kBREventRemoteActionPlayHold = 20,
    
	// Gestures, for originator kBREventOriginatorGesture
	kBREventRemoteActionTap = 30,
	kBREventRemoteActionSwipeLeft,
	kBREventRemoteActionSwipeRight,
	kBREventRemoteActionSwipeUp,
	kBREventRemoteActionSwipeDown,
} BREventRemoteAction;
typedef enum
{
    kSMRemoteMenu	= 1,
    kSMRemoteUp		= 3,
    kSMRemoteDown	= 4,
    kSMRemotePlay	= 5,
    kSMRemoteLeft	= 6,
    kSMRemoteRight	= 7,
}SMRemoteKeys;
