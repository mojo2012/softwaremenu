//
//  loadUpdatesDownloadClass.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/7/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../General/Extensions.h"
#import "../SMPrefs.h"
#import "../SMDefines.h"
#import "../BackRowUtilstwo.h"
#define DEFAULT_TRUSTED_URL					@"http://web.me.com/tomcool420/Trusted2.plist"
//#define DEFAULT_TRUSTED_PATH                @"/Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist"

@interface loadUpdatesDownloadClass : NSObject {
    NSString        *_downloadPath;
    NSString        *_downloadURL;
    NSFileManager   *_man;
}
-(void)setPath:(NSString *)path;
-(void)setURL:(NSString *)url;
//-(int)checkPath;
-(int)downloadUpdates;
-(void)getImages:(NSDictionary *)TrustedDict;
-(int)checkPathForPath:(NSString *)pathFile;

@end
