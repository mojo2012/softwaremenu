//
//  ThirdPartyPlugins.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/6/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMThirdPartyPlugins : NSObject {
    NSDictionary  * _updates;
    BOOL            _updateImages;
    BOOL            _checkImages;
}
+ (SMThirdPartyPlugins*)singleton;
-(NSDictionary *)plugins;
-(NSString *)loadPlugins;
-(void)setCheckImages:(BOOL)checkImages;
-(void)setUpdateImages:(BOOL)updateImages;
-(NSString *)logPath;
-(BOOL)updateImages;
-(BOOL)checkImages;
-(void)writeToLog:(NSString *)strLog;
-(void)getImages:(NSDictionary *)TrustedDict;
@end
