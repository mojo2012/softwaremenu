//
//  SMHelper.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/19/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMHelper.h"
#define SMH_SCREENSAVER     @"--install-Screensaver"
#define SMH_REMOVE_PLUGIN   @"--remove-plugin"
#define SMH_REMOVE_PLUGIN_1 @"-rp"

#define SMH_REMOVE_BACKUP   @"--remove-backup"
#define SMH_REMOVE_BACKUP_1 @"-rb"

#define SMH_HIDE            @"--make-invisible" 
#define SMH_HIDE_1          @"-h"

#define SMH_SHOW            @"--make-visible"
#define SMH_SHOW_1          @"-s"

#define SMH_BACKUP          @"--backup"
#define SMH_BACKUP_1        @"-b"

#define SMH_RESTORE         @"--restore"
#define SMH_RESTORE_1       @"-re"

#define SMH_ORDER           @"--change-order"
#define SMH_ORDER_1         @"-co"



//--install || -i
#define SMH_INSTALL         @"--install"
#define SMH_INSTALL_1       @"-i"

#define SMH_UPDATE          @"--update"

//--make-invisible || -h

#define SMH_SCRIPT          @"--run-script"

#define SMH_RESTART         @"--restart-finder"
#define SMH_RESTART_1       @"-rf"
#define SMH_REBOOT          @"--reboot"

#define SMH_MOUNT           @"--mount"

#define SMH_UNMOUNT         @"--unmount"

#define SMH_MAKE_RO         @"--make-read-only"
#define SMH_MAKE_RO_1       @"-mro"

#define SMH_MAKE_RW         @"--make-read-write"
#define SMH_MAKE_RW_1       @"-mr"

#define SMH_DROPBEAR        @"--install-dropbear"

#define SMH_BINARIES        @"--install-binaries"

#define SMH_ASR             @"--asrscan"

#define SMH_PYTHON          @"--install-python"

#define SMH_EXTRACT         @"--extract"
#define SMH_EXTRACT_1       @"-x"

#define SMH_OSUPDATE        @"--launch-update"
#define SMH_TOGGLE_UPDATE   @"--toggle-update"


@implementation SMHelper
static SMHelper *singleton = nil;

+ (SMHelper*)helperManager;
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self helperManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (int)retainCount
{
    return 15000;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
-(void)toggleUpdate
{
    NSArray *options=[NSArray arrayWithObjects:SMH_TOGGLE_UPDATE,nil];
    [self runTaskWithOptions:options];

}
-(void)installScreensaver
{
    NSArray *options=[NSArray arrayWithObjects:SMH_SCREENSAVER,nil];
    [self runTaskWithOptions:options];
}
-(void)installWithFile:(NSString *)path
{
    NSArray *options=[NSArray arrayWithObjects:SMH_INSTALL,path,nil];
    [self runTaskWithOptions:options];
}
-(void)makeVisible:(NSString *)plugin
{
    NSArray *options=[NSArray arrayWithObjects:SMH_SHOW,plugin,nil];
    [self runTaskWithOptions:options];
}
-(void)makeInvisible:(NSString *)plugin
{
    NSArray *options=[NSArray arrayWithObjects:SMH_HIDE,plugin,nil];
    [self runTaskWithOptions:options];
}
-(void)removeBackup:(NSString *)plugin
{
    NSArray *options=[NSArray arrayWithObjects:SMH_REMOVE_BACKUP,plugin,nil];
    [self runTaskWithOptions:options];
}
-(void)backupPlugin:(NSString *)plugin
{
    NSArray *options=[NSArray arrayWithObjects:SMH_BACKUP,plugin,nil];
    [self runTaskWithOptions:options];
}
-(void)restorePlugin:(NSString *)plugin
{
    NSArray *options=[NSArray arrayWithObjects:SMH_RESTORE,plugin,nil];
    [self runTaskWithOptions:options];
}
-(void)removePlugin:(NSString *)plugin
{
    NSArray *options=[NSArray arrayWithObjects:SMH_REMOVE_PLUGIN,plugin,nil];
    [self runTaskWithOptions:options];
}
-(void)changeOrderForPlugin:(NSString *)plugin newOrder:(int)order
{
    NSArray *options=[NSArray arrayWithObjects:SMH_ORDER,plugin,[NSString stringWithFormat:@"%i",order,nil],nil];
    [self runTaskWithOptions:options];
}
-(void)runscript:(NSString *)script withOption1:(NSString *)option1 withOption2:(NSString *)option2
{
    NSMutableArray *options=[NSMutableArray arrayWithObjects:script,nil];
    if (option1!=nil) {
        [options addObject:option1];
    }
    if (option2!=nil) {
        [options addObject:option2];
    }
    [self runTaskWithOptions:options];
}
-(NSString *)runScriptWithReturn:(NSString *)script
{
    NSMutableArray *options=[NSMutableArray arrayWithObject:script];
    NSString *str;
    [self runTaskWithOptions:options withOutput:&str];
    return str;
}
-(void)restartFinder
{
    NSArray *options=[NSArray arrayWithObjects:SMH_RESTART,nil];
    [self runTaskWithOptions:options];
}
-(void)reboot
{
    NSArray *options=[NSArray arrayWithObjects:SMH_REBOOT,nil];
    [self runTaskWithOptions:options];
}
-(void)makeImageReadOnly:(NSString *)dmgPath withNewName:(NSString *)newName
{
    NSArray *options=[NSArray arrayWithObjects:SMH_MAKE_RO,dmgPath,newName,nil];
    [self runTaskWithOptions:options];
}
-(void)makeImageReadWrite:(NSString *)dmgPath withNewName:(NSString *)newName
{
    NSArray *options=[NSArray arrayWithObjects:SMH_MAKE_RW,dmgPath,newName,nil];
    [self runTaskWithOptions:options];
}
-(void)asrscanImage:(NSString *)dmgPath
{
    NSArray *options=[NSArray arrayWithObjects:SMH_ASR,dmgPath,nil];
    [self runTaskWithOptions:options];
}
-(void)mountImage:(NSString *)dmgPath
{
    NSArray *options=[NSArray arrayWithObjects:SMH_MOUNT,dmgPath,nil];
    [self runTaskWithOptions:options];
}
-(void)unmountPath:(NSString *)path
{
    NSArray *options=[NSArray arrayWithObjects:SMH_UNMOUNT,path,nil];
    [self runTaskWithOptions:options];
}
-(void)addDropbearToDrive:(NSString *)drive
{
    NSArray *options=[NSArray arrayWithObjects:SMH_DROPBEAR,drive,nil];
    [self runTaskWithOptions:options];
}
-(void)addBinariesToDrive:(NSString *)drive
{
    NSArray *options=[NSArray arrayWithObjects:SMH_BINARIES,drive,nil];
    [self runTaskWithOptions:options];
}
-(void)installPython:(NSString *)dmgPath
{
    NSArray *options=[NSArray arrayWithObjects:SMH_PYTHON,dmgPath,nil];
    [self runTaskWithOptions:options];
}
-(void)extractFile:(NSString *)file toPath:(NSString *)path
{
    NSArray *options=[NSArray arrayWithObjects:SMH_EXTRACT,file,path,nil];
    [self runTaskWithOptions:options];
}
-(void)launchUpdateWithFolder:(NSString *)folder
{
    NSArray *options=[NSArray arrayWithObjects:SMH_OSUPDATE,folder,nil];
    [self runTaskWithOptions:options];
}
-(int)runTaskWithOptions:(NSArray *)options
{
	NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	if(![[NSFileManager defaultManager] fileExistsAtPath:helperLaunchPath])
		NSLog(@"the helper does not exist..... what did you do?");
	NSTask *task8 = [[NSTask alloc] init];
	[task8 setArguments:options];
	[task8 setLaunchPath:helperLaunchPath];
    [task8 setStandardError:[self logHandle]];
    [task8 setStandardOutput:[self logHandle]];
	[task8 launch];
	[task8 waitUntilExit];
	int theTerm = [task8 terminationStatus];
    [task8 release];
	return theTerm;
    
}
-(int)runTaskWithOptions:(NSArray *)options withOutput:(NSString **)output
{
    NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	if(![[NSFileManager defaultManager] fileExistsAtPath:helperLaunchPath])
		NSLog(@"the helper does not exist..... what did you do?");
	NSTask *task8 = [[NSTask alloc] init];
	[task8 setArguments:options];
	[task8 setLaunchPath:helperLaunchPath];
    [task8 setStandardError:[self logHandle]];
    [task8 setStandardOutput:[self logHandle]];
	[task8 launch];
	[task8 waitUntilExit];
    NSData *outData;
	outData = [[self logHandle] readDataToEndOfFile];
    if (output!=nil && outData!=nil) {
        *output=[[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
    }
	int theTerm = [task8 terminationStatus];
    [task8 release];
	return theTerm;
}

- (NSFileHandle *)logHandle
{
	logHandle = [[NSFileHandle fileHandleForWritingAtPath:[self logPath]] retain];
	return logHandle;
}

- (NSString *)logPath
{
	NSString * logPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SMHelper.log"];
	[[NSFileManager defaultManager] createFileAtPath: logPath contents:nil attributes:nil];
	return logPath;
}
@end
