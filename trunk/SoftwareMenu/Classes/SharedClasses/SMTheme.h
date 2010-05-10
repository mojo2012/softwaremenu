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
@interface SMThemeInfo : NSObject{
	
}
+ (SMThemeInfo *)sharedInstance;
+(id)sharedTheme;
+(NSSet *)imageExtensions;
-(id)imageForString:(NSString *)imageName;
-(id)softwareMenuImageTiny;
-(id)softwareMenuImageShelf;
-(id)softwareMenuImage;
-(id)tinySMImage;
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
-(id)SSHImage;

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
-(NSString *)getImagePathForFrapName:(NSString *)Name;
-(id)imageForFrap:(NSString *)frapName;
-(id)leftJustifiedTitleTextAttributess;
-(id)centerJustifiedRedText;

//CGColor stuff
-(CGColorRef)colorFromNSColor:(NSColor *)color;
@end
