//
//  SMPluginSingleton.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/26/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * kSMPluginFetchDoneNotification;

@interface SMPluginSingleton : NSObject {
    NSDictionary  * _updates;
    BOOL            _updateImages;
    BOOL            _checkImages;
    id              _delegate;
    BOOL            _locking;
    NSMutableString*_log;
}
+ (SMPluginSingleton*)singleton;
- (id)fetchURL:(NSString *)urlString;
- (void)writeToLog:(NSString *)message;
- (NSString *)saveLog;
- (NSDictionary *)loadPluginsWithLog:(NSString **)log;
- (NSString *)loadPlugins;
- (void)performThreadedPluginLoad;
- (void)getImages:(NSDictionary *)TrustedDict;
- (NSData *)fetchData:(NSString *)urlString;
@end
