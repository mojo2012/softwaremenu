//
//  installHelperClass.h
//  example code
//
//  Created by nito on 8/30/07.
//  Copyright 2007 nito. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
//#import <BackRow/BackRow.h>

@interface installHelperClass : NSObject {

	BOOL wasWritable;
	NSString *runPath;
	
}

- (NSString *)runPath;
- (void)setRunPath:(NSString *)value;
- (void)installSelf:(NSString *)value;
- (void)removeFrap:(NSString *)value;
- (int)removeFile:(NSString *)filepath;
- (void)hideFrap:(NSString *)value;
- (void)showFrap:(NSString *)value;
- (void)restoreFrap:(NSString *)value;
- (void)backupFrap:(NSString *)value;
- (void)changeOrder:(NSString *)value toOrder:(NSString *)value2;
- (void)makeDMGRW:(NSString *)drivepath;
- (void)makeDMGRO:(NSString *)drivepath;
- (void)mountDrive:(NSString *)drivepath;
- (void)unMountDrive:(NSString *)drive;
- (void)makeASRscan:(NSString *)drivepath;
- (void)copySSHFiles;
- (void)OSUpdate;
-(int)toggleUpdate;

- (BOOL)wasWritable;


- (void)changePermissions:(NSString *)perms onFile:(NSString *)theFile isRecursive:(BOOL)isR;

@end
