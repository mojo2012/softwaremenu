//
//  SMTheme.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>	


#define IMAGE_INFO			@"info"

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
#define IMAGE_NOT_FOUND     @"notfound"

#define IMAGE_PACKAGE		@"package"
#define IMAGE_FOLDER		@"folderIcon"
#define IMAGE_GREEN_GEM		@"green"
#define	IMAGE_RED_GEM		@"red"
#define IMAGE_GREY_GEM		@"grey"
#define IMAGE_TRUSTED       @"trusted"
#define IMAGE_TESTED        @"tested"
@interface SMFThemeInfo : NSObject{
	
}
+(NSSet *)coverArtExtensions;
+ (SMFThemeInfo *)sharedInstance;
+(id)sharedTheme;
-(id)greenGem;
-(id)redGem;
-(id)greyGem;
//Round Grey Images
-(id)infoImage;

-(id)powerImage;
-(id)refreshImage;
-(id)standbyImage;
-(id)trashEmptyImage;
-(id)webImage;

//TweakImages
-(id)hardDiskImage;
-(id)AFPImage;
-(id)FTPImage;
-(id)VNCImage;

//GeneralImages
-(id)systemPrefsImage;
-(id)scriptImage;


-(id)packageImage;
-(id)folderIcon;
-(id)licenseImage;
-(id)notFoundImage;


//ApplianceControllerImage
-(id)trustedImage;
-(id)testedImage;
//-(id)imageForFrap:(NSString *)frapName;
-(id)leftJustifiedTitleTextAttributess;
-(id)centerJustifiedRedText;

//CGColor stuff
-(CGColorRef)colorFromNSColor:(NSColor *)color;
@end
