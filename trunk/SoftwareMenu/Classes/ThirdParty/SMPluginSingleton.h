//
//  SMPluginSingleton.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/26/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
extern NSString * kSMPluginOverwrites;
extern NSString * kSMPluginFetchDoneNotification;
extern NSString * kSMMinOverWrite;
extern NSString * kSMMaxOverWrite;
extern NSString * kSMURLOverWrite;

@interface SMPluginSingleton : NSObject {
    NSDictionary  * _updates;
    BOOL            _updateImages;
    BOOL            _checkImages;
    id              _delegate;
    BOOL            _locking;
    NSMutableString*_log;
    NSDictionary *  _overwrites;
    NSTimer *       _checkTimer;
}
+ (SMPluginSingleton*)singleton;
- (void)postDelegateMessage:(NSString *)message end:(BOOL)end;
- (void)setDelegate:(id)delegate;
- (id)delegate;
- (id)fetchURL:(NSString *)urlString;
- (void)writeToLog:(NSString *)message;
- (NSString *)saveLog;
- (NSDictionary *)loadPluginsWithLog:(NSString **)log;
- (NSString *)loadPlugins;
- (void)performThreadedPluginLoad;
- (void)getImages:(NSDictionary *)TrustedDict;
- (NSData *)fetchData:(NSString *)urlString;
- (void)timerRun;
- (void)loadOverwrites;
@end
