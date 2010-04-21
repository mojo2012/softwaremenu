//
//  SMTheme.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#define BRImageD(key)        [BRImage imageWithPath:(key)]
#import <Foundation/Foundation.h>	
#define IMAGE_SM_SHELF      @"shelff"
#define IMAGE_SM			@"softwaremenu"
#define IMAGE_INFO			@"info"
#define IMAGE_INTERNET		@"internet"
#define IMAGE_POWER			@"power"
#define IMAGE_REFRESH		@"refresh"
#define IMAGE_STANDBY		@"standby"
#define IMAGE_TRASH_EMPTY	@"trashempty"
#define IMAGE_WEB			@"web"
#define	IMAGE_HARDDISK		@"RW"
#define IMAGE_AFP			@"AFP"
#define	IMAGE_FTP			@"FTP"
#define IMAGE_VNC			@"VNC"
#define IMAGE_SYS_PREFS		@"sysprefs"
#define IMAGE_SCRIPT		@"script"
#define IMAGE_TIME_MACHINE	@"timemachine"
#define	IMAGE_PERIAN		@"Perian"
#define IMAGE_PACKAGE		@"package"
#define IMAGE_FOLDER		@"folderIcon"
#define IMAGE_PHOTO_HELP	@"RemotePhotos"
#define IMAGE_GREEN_GEM		@"green"
#define	IMAGE_RED_GEM		@"red"
#define IMAGE_GREY_GEM		@"grey"
#define IMAGE_TRUSTED       @"trusted"
#define IMAGE_TESTED        @"tested"
#define IMAGE_BUNDLE        @"bundle"
#define IMAGE_SM_TINY       @"sm_tiny"
@interface SMThemeInfo : NSObject{
	
}
+ (SMThemeInfo *)sharedInstance;
+(id)sharedTheme;
+(NSSet *)imageExtensions;
-(id)imageForString:(NSString *)imageName;
-(id)softwareMenuImageTiny;
-(id)softwareMenuImageShelf;
-(id)softwareMenuImage;
-(id)greenGem;
-(id)redGem;
-(id)greyGem;
//Round Grey Images
-(id)infoImage;
-(id)internetImage;
-(id)powerImage;
-(id)refreshImage;
-(id)standbyImage;
-(id)trashEmptyImage;
-(id)webImage;
-(id)bundleImage;
//TweakImages
-(id)hardDiskImage;
-(id)AFPImage;
-(id)FTPImage;
-(id)VNCImage;

//GeneralImages
-(id)systemPrefsImage;
-(id)scriptImage;
-(id)timeMachineImage;
-(id)perianImage;
-(id)packageImage;
-(id)folderIcon;
-(id)licenseImage;
-(id)photosImage;


//ApplianceControllerImage
-(id)trustedImage;
-(id)testedImage;
-(id)imageForFrap:(NSString *)frapName;
-(id)leftJustifiedTitleTextAttributess;
-(id)centerJustifiedRedText;

//CGColor stuff
-(CGColorRef)colorFromNSColor:(NSColor *)color;
@end
