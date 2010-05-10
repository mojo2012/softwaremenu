//
//  SMTheme.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>	



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
