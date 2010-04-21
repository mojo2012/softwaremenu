#import <Foundation/Foundation.h>
typedef enum {
	
	kBREventActionTapMenu = 134,
	kBREventActionTapPlay = 137,
	kBREventActionTapRight = 138,
	kBREventActionTapLeft = 139,
	kBREventActionTapUp = 140,
	kBREventActionTapDown = 141,
	kBREventActionTapPlayNew = 205,
	
	kBREventActionHoldMenu = 64,
	kBREventActionHoldRight = 179,
	kBREventActionHoldLeft = 180,
	
} BREventRemoteActions;
typedef enum {
	ntvPlaylistType = 0,
	ntvFileType = 1,
	ntvDvdType = 2,
	ntvQTType = 3,
	ntvQTPLType = 4,
	ntvPhotosJPGType = 5,
	ntvPhotosPNGType = 6,
	ntvMusicType = 7,
	ntvMusicPlType = 8,
	ntvNESType = 9,
	ntvGenesisType = 10,
	ntvSNESType = 11,
	ntvGBAType = 12,
	ntvGGType = 13,
	ntvn64Type = 14,
	ntvVideoStreamType = 15,
	ntvAudioStreamType = 16,
	
} NTVPlaybackOptions;

// Messages the client will receive from the server
@protocol ChatterUsing
- (oneway void)displayAlert:(in bycopy NSString *)message;

- (oneway void)showMessage:(in bycopy NSString *)message 
    fromNickname:(in bycopy NSString *)nickname;

- (oneway void)sendPlist:(in bycopy NSDictionary *)plist;
- (oneway void)sendImage:(in bycopy NSData  *)data withInfo:(in bycopy NSDictionary *)plist;
- (BOOL)test;
- (bycopy NSString *)nickname;

@end

// Messages the server will receive from the client
@protocol ChatterServing

- (oneway void)sendMessage:(in bycopy NSString *)message 
                fromClient:(in byref id <ChatterUsing>)client;

// Returns NO if someone already has newClient's nickname
- (BOOL)subscribeClient:(in byref id <ChatterUsing>)newClient;

- (void)unsubscribeClient:(in byref id <ChatterUsing>)client;
- (oneway void)sendRequest:(in bycopy NSDictionary *)request fromClient:(in byref id<ChatterUsing>)client;
/*
 *  Returns an NSData object with the content of an image file if the path is found
 */
- (bycopy NSData *)imageDataForPath:(in bycopy NSString *)filepath;


-(BOOL)sapphireIsInstalled;
-(BOOL)nitoTVIsInstalled;

/*
 *  The Following Methods all require Sapphire to run. 
 *  It is recommended to check for the existance of sapphire first
 */

/*
 *  Same as imageDataForPath but the path of a movie file is returned and image is the sapphire
 *  Imported image
 */
- (bycopy NSData *)sapphireImageDataForFile:(in bycopy NSString *)filepath;
/*
 *  Loads all the Movies and their metaData into a dictionary
 */
- (bycopy NSDictionary *)sapphireMoviesDictionary;
/*
 *  Returns a dictionary containing just the movies and their paths
 */
- (bycopy NSDictionary *)sapphireMoviesList;
/*
 *  Returns a dictionary containing the metadata of a specific movie
 */
- (bycopy NSDictionary *)sapphireInfoForMovie:(in bycopy NSString *)movie;

/*
 *  Returns Complete Dictionary of TV shows;
 */
- (bycopy NSDictionary *)sapphireTVDictionary;

/*
 * Play Movie using Sapphire
 */
-(oneway void)sapphirePlayMovie:(in bycopy NSString *)path;

/*
 *  Return Array of TV Shows
 */
- (bycopy NSArray *)shows;

/*
 *  Return Array of Seasons for Show
 */
- (bycopy NSArray *)seasonsForShow:(in bycopy NSString *)show;

/*
 *  Return Dictionary of Episodes for a show and a season
 */
- (bycopy NSDictionary *)episodesForShow:(in bycopy NSString *)show forSeason:(in bycopy NSString *)season;


/*
 *  Performs a Remote action with for a dictionary
 */
- (oneway void)remoteAction:(in bycopy NSDictionary *)dict;
/*
 * Requires a BREventRemoteAction Code
 */
- (oneway void)remoteActionForEvent:(int)event;

/*
 *  Returns an array of scripts at ~/Documents/Scripts
 */ 
- (bycopy NSArray *)scripts;
/*
 *  Runs a scripts (disregard return)
 */
- (oneway void)runscript:(in bycopy NSString *)path asRoot:(BOOL)root displayOutput:(BOOL)output;

/*
 *  Slideshow for Path
 */
- (oneway void)slideshowForPath:(in bycopy NSString *)path;

/*
 *  Set Current Slideshow Path
 */
- (oneway void)setSlideshowPath:(in bycopy NSString *)path;

/*
 *  Returns favorite photo folders
 */
- (bycopy NSArray *)slideshowFavorites;

/*
 *  Start Screensaver
 */
- (void)startScreensaver;

/*
 * Testing
 */
-(bycopy NSDictionary *)testing;
/*
 *  NitoTV Methods
 *  Again, it is recommended to check for existence of nitoTV first
 */
- (oneway void)nitoTVPlayMovie:(in bycopy NSString *)path withMplayer:(BOOL)mplayer;

/*
 *  Files For Folder
 */
- (bycopy NSDictionary *)filesForFolder:(in bycopy NSString *)path;

/*
 * @brief  Use simple SoftwareMenu QuickTime Player to play a movie
 *  
 * @param  path to movie file
 */
- (oneway void)playQTMovie:(in bycopy NSString *)path;

#pragma mark CONNECTION
/*
 * @brief  Tester method used to see if the connection still exists;
 * @return Allways YES;
 */
- (BOOL)test;

#pragma mark NETWORK
/*
 * @brief  mount a network share
 *
 * @param  mount dictionary (nitoTV style)
 * @param  should the mount be linked into Movies
 *
 * @return mount status
 */
-(BOOL)mountNetworkDrive:(in bycopy NSDictionary *)information softLink:(in BOOL)link;

/*
 *@return Dictionary with all the mounts saved by nitoTV
 */
-(bycopy NSDictionary *)ntvMounts;

@end
@protocol ChatterDelegate
/*
 * @brief Recieve Information in an NSDictionary Format
 */
-(void)recieveDict:(NSDictionary *)dict;

/*
 * @brief Recieve Images from the server
 *
 * @param NSData containing image info
 * @param dictionary containing information about where the image needs to go
 */
-(void)recieveImage:(NSData *)data forInfo:(NSDictionary *)info;
@end
