//
//  loadUpdatesDownloadClass.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/7/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "../General/Extensions.h"
//#import "../Classes/SharedClasses/SMPrefs.h"
#import "../SMDefines.h"
//#import "../BackRowUtilstwo.h"
#define DEFAULT_TRUSTED_URL					@"http://web.me.com/tomcool420/Trusted2.plist"

@interface SMThirdPartyPlugins : NSObject {
    NSDictionary  * _updates;
    BOOL            _updateImages;
    BOOL            _checkImages;
}
+ (SMThirdPartyPlugins*)singleton;
-(NSDictionary *)plugins;
-(int)loadPlugins;
-(void)setCheckImages:(BOOL)checkImages;
-(void)setUpdateImages:(BOOL)updateImages;
-(NSString *)logPath;
-(BOOL)updateImages;
-(BOOL)checkImages;
-(void)writeToLog:(NSString *)strLog;
-(void)getImages:(NSDictionary *)TrustedDict;
@end
