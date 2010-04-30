//
//  smToolHelper.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/20/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "../../Shared/SMCommonHeader.h"

@interface smToolHelper : NSObject {
    NSString *runPath;
}
#pragma mark Misc Methods
- (int)switchService:(NSString *)services on:(BOOL)on;
- (int)toggleVNC:(BOOL)on;
- (int)toggleSSH:(BOOL)on;
- (int)toggleRowmote:(BOOL)on;
- (int)EnableAppleShareServer;
- (int)DisableAppleShareServer;
- (int)toggleBlockUpdates:(BOOL)on;
- (int)toggleTweak:(SMTweak)tw on:(BOOL)on;

#pragma mark Class Management
- (NSString *)runPath;
- (void)setRunPath:(NSString *)value;

#pragma mark Drives
- (int)isWritable;
- (BOOL)makeSystemWritable ;
- (void) makeSystemReadOnly;
- (NSString *)mountImage:(NSString *)image;
- (void)unMountDrive:(NSString *)drive;
- (void) makeDMGRW:(NSString *)drivepath newName:(NSString *)newName;
- (void) makeDMGRO:(NSString *)drivepath newName:(NSString *)newName;
#pragma mark Restarting
- (void)restartFinder;
- (void)reboot;

#pragma mark extraction
- (int)extractArchive:(NSString *)archive toPath:(NSString *)path;
- (BOOL)gCheck;
- (BOOL)gCheckOnDisk:(NSString *)disk;
- (BOOL)bCheck;
- (BOOL)bCheckOnDisk:(NSString *)disk;
- (int)bunZip:(NSString *)inputTar toLocation:(NSString *)toLocation;
- (int)extractGZip:(NSString *)inputTar toLocation:(NSString *)toLocation;
- (int)extractGZip:(NSString *)file toLocation:(NSString *)path withPath:(BOOL)with;
-(int)unZip:(NSString *)inputZip toLocation:(NSString *)toLocation;
- (int)extractTar:(NSString *)inputTar toLocation:(NSString *)toLocation;

#pragma mark Permissions
- (void)changeOwner:(NSString *)theOwner onFile:(NSString *)theFile isRecursive:(BOOL)isR;
- (int)changePermissions:(NSString *)perms onFile:(NSString *)theFile isRecursive:(BOOL)isR;

#pragma mark Plugin Management
-(int)installPluginWithArchive:(NSString *)archive;
- (int)enableFrap:(NSString *)frap;
- (int)disableFrap:(NSString *)frap;
- (int)plistHideFrap:(NSString *)plugin;
- (int)plistShowFrap:(NSString *)plugin;
- (int)changeOrder:(NSString *)plugin toOrder:(NSString *)value2;
-(int)backupFrap:(NSString *)frap;
-(int)restoreFrap:(NSString *)frap;
-(NSString *)getPluginPath:(NSString *)plugin;
-(NSString *)getBackupPath:(NSString *)plugin;
-(int)removeFile:(NSString *)path;
-(void)logTaskWithPath:(NSString *)path withOptions:(NSArray *)options;
-(NSString *) ffindFrap:(NSString *)importFolder;

#pragma mark SoftwareMenuBase
-(int)installPython:(NSString *)file toVolume:(NSString *)targetVolume;
-(int)installPerian:(NSString *)dmg toVolume:(NSString *)targetVolume;
-(int)installScreenSaver;
-(int)installDropbearToDrive:(NSString *)drive;
@end
