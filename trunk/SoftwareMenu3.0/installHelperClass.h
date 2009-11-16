//
//  installHelperClass.h
//  example code
//
//  Created by nito on 8/30/07.
//  Copyright 2007 nito. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "AGProcess.h"
#import "General/Extensions.h"
#define FRAP_PATH					@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/"
#define BAK_PATH					@"/Users/frontrow/Documents/Backups/"
#define RESOURCES_PATH				@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/"

//////#import <BackRow/BackRow.h>

@interface installHelperClass : NSObject {

	BOOL wasWritable;
	NSString *runPath;
	NSFileManager *		_man;
	
}

- (NSString *)runPath;
- (int)updateSelf:(NSString *)value;
- (void)setRunPath:(NSString *)value;
- (void)installSelf:(NSString *)value;
- (void)removeFrap:(NSString *)value;
- (int)removeFile:(NSString *)filepath;
- (void)hideFrap:(NSString *)value;
- (void)showFrap:(NSString *)value;
- (void)restoreFrap:(NSString *)value;
- (void)backupFrap:(NSString *)value;
- (void)changeOrder:(NSString *)value toOrder:(NSString *)value2;
- (void)makeDMGRW:(NSString *)dmgPath;
- (void)makeDMGRO:(NSString *)dmgPath;
- (void)mountDrive:(NSString *)dmgPath;
- (void)unMountDrive:(NSString *)drive;
- (void)makeASRscan:(NSString *)dmgPath;
- (void)copySSHFiles;
- (void)OSUpdate;
- (int)toggleUpdate;
- (int)blockUpdate;
- (int)runscript;
- (int)isWritable;

- (int)unZip:(NSString *)zipPath toLocation:(NSString *)location;
- (int)install_perian:(NSString *)perian_path toVolume:(NSString*)targetVolume;
- (int)toggleTweak:(NSString *)setting toValue:(NSString *)fp8;
- (int)toggleVNC:(BOOL)tosetting;
- (int)toggleSSH:(BOOL)tosetting;
- (int)toggleRowmote:(BOOL)tosetting;
- (int)toggleAFP:(BOOL)tosetting;
- (int)enableService:(NSString *)theService;
- (int)disableService:(NSString *)theService;
- (int)EnableAppleShareServer;
- (int)DisableAppleShareServer;
- (int)installScreenSaver;
- (int)extractGZip:(NSString *)file toLocation:(NSString *)path;
- (int)extractTar:(NSString *)file toLocation:(NSString *)path;
- (int)restart:(NSString *)value;
- (int)runscript:(NSString *)scriptPath;
- (void)changeOwner:(NSString *)owner onFile:(NSString *)file isRecursive:(BOOL)recursive;
- (NSString *)mountImage:(NSString *)image;

- (BOOL)wasWritable;
- (BOOL)makeSystemWritable;


- (void)changePermissions:(NSString *)perms onFile:(NSString *)theFile isRecursive:(BOOL)isR;

@end
