//
//  smToolHelper
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/20/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "smToolHelper.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>
#include <stdlib.h>
#import "AGProcess.h"
#import "../General/Extensions.h"

#define FRAP_PATH					@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/"
#define BAK_PATH					@"/Users/frontrow/Documents/Backups/"

@implementation smToolHelper
#pragma mark Misc Methods
- (int)switchService:(NSString *)service on:(BOOL)on
{
    NSString *launchCtl = [NSString stringWithFormat:@"/bin/launchctl %@ -w /System/Library/LaunchDaemons/%@.plist",
                           (on?@"load":@"unload"),
                           service];
    chdir( "/" );
    setuid( 0 );
    setgid( 0 );
    int result = system( [launchCtl UTF8String] );
    if(result)
        DLog(@"failed to switch service: %@, to state: %d, result: %d",service,on,result);
    if (ISString(service,@"com.atvMod.dropbear")) {
        AGProcess *dp = [AGProcess processForCommand:@"dropbear"];
		if (dp != nil)
			[dp terminate];
    }
    return result;
}

- (int)toggleSSH:(BOOL)on
{
	NSString *sshType = @"ssh";
	if ( [[NSFileManager defaultManager] fileExistsAtPath: @"/usr/bin/dropbear"] )
		sshType = @"com.atvMod.dropbear";
    return[self switchService:sshType on:on];
}

-(int) EnableAppleShareServer
{
    // change /etc/hostconfig
    NSMutableString * hostconfig = [NSMutableString stringWithContentsOfFile: @"/etc/hostconfig"];
    if ( hostconfig == nil )
    {
        /*ATVErrorLog( @"Failed to load hostconfig file" );
         PostNSError( EIO, NSPOSIXErrorDomain,
         LocalizedError(@"HostconfigOpenFailed", @"Unable to read /etc/hostconfig"),
         nil );*/
		DLog(@"Failed To Load hostconfig");
        return ( 1 );
    }
	
    if ( [hostconfig replaceOccurrencesOfString: @"AFPSERVER=-NO-"
                                     withString: @"AFPSERVER=-YES-"
                                        options: 0
                                          range: NSMakeRange(0, [hostconfig length])] == 0 )
    {
        // is it already set ?
        NSRange range = [hostconfig rangeOfString: @"AFPSERVER=-YES-"];
        if ( range.location == NSNotFound )
        {
            DLog( @"AFP Server hostconfig entry not found, adding..." );
            [hostconfig insertString: @"AFPSERVER=-YES-\n" atIndex: 0];
        }
        else
        {
            DLog( @"AFP Server already enabled" );
            return ( 1 );     // don't write file or start server
        }
    }
	
    if ( [hostconfig writeToFile: @"/etc/hostconfig" atomically: YES] == NO )
    {
        //ATVErrorLog( @"Failed to write hostconfig" );
        /* PostNSError( EIO, NSPOSIXErrorDomain,
         LocalizedError(@"HostconfigWriteFailed", @"Unable to write /etc/hostconfig"),
         nil );*/
		DLog(@"Cannot write Hostconfig");
    }
	
    system( "/usr/sbin/AppleFileServer" );  // this one daemonizes itself
	
    return ( 0 );
}
-( int) DisableAppleShareServer
{
    NSMutableString * hostconfig = [NSMutableString stringWithContentsOfFile: @"/etc/hostconfig"];
    if ( hostconfig == nil )
    {
        /*ATVErrorLog( @"Failed to load hostconfig file" );
         PostNSError( EIO, NSPOSIXErrorDomain,
         LocalizedError(@"HostconfigOpenFailed", @"Unable to read /etc/hostconfig"),
         nil );*/
		DLog(@"Cannot load hostconfig");
        return ( 1 );
    }
	
    if ( [hostconfig replaceOccurrencesOfString: @"AFPSERVER=-YES-"
                                     withString: @"AFPSERVER=-NO-"
                                        options: 0
                                          range: NSMakeRange(0, [hostconfig length])] == 0 )
    {
        DLog( @"AFP Server already stopped, or not configured" );
        return ( 1 );
    }
	
    if ( [hostconfig writeToFile: @"/etc/hostconfig" atomically: YES] == NO )
    {
        /*ATVErrorLog( @"Failed to write hostconfig" );
         PostNSError( EIO, NSPOSIXErrorDomain,
         LocalizedError(@"HostconfigWriteFailed", @"Unable to write /etc/hostconfig"),
         nil );*/
		DLog(@"cannot write hostconfig");
    }
	
    NSString * pidString = [NSString stringWithContentsOfFile: @"/var/run/AppleFileServer.pid"];
    pid_t procID = (pid_t) [pidString intValue];
    DLog( @"Killing AFP server, process ID '%d'", (int) procID );
	
    if ( procID > 0 )
        kill( procID, SIGTERM );
	
    return ( 0 );
}
-(int)toggleRowmote:(BOOL)on
{
	AGProcess *argAgent = [AGProcess processForCommand:@"RowmoteHelperATV"];
	if (argAgent != nil && !on)
		[argAgent terminate];
	if(argAgent ==nil && on)
		[NSTask launchedTaskWithLaunchPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/RowmoteHelperATV.frappliance/Contents/Resources/RowmoteHelperATV" arguments:[NSArray arrayWithObjects:nil]];
	return 0;
}
- (int)toggleVNC:(BOOL)on
{
    int result;
    NSArray *args;
    
    if(!on)
	{
		AGProcess *argAgent = [AGProcess processForCommand:@"AppleVNCServer"];
		if (argAgent != nil)
			[argAgent terminate];
        args=[NSArray arrayWithObject:@"-deactivate"];        
    }
    else
        args=[NSArray arrayWithObject:@"-activate"];
    NSTask *afp = [[NSTask alloc]init];
    [afp setArguments:args];
    [afp setLaunchPath:@"/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"];
    [afp launch];
    [afp waitUntilExit];
    result = [afp terminationStatus];
    if (on)
        [NSTask launchedTaskWithLaunchPath:@"/System/Library/CoreServices/RemoteManagement/AppleVNCServer.bundle/Contents/MacOS/AppleVNCServer" arguments:[NSArray arrayWithObjects:@"&",nil]];
    NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 1];
    [NSThread sleepUntilDate:future];
    return result;
	
}
- (int)toggleBlockUpdates:(BOOL)on
{
	NSMutableString *hosts = [[NSMutableString alloc] initWithContentsOfFile:@"/etc/hosts"];
	NSMutableArray *hostArray = [[NSMutableArray alloc] initWithArray:[hosts componentsSeparatedByString:@"\n"]];
	int i;
	for (i = 0; i < [hostArray count]; i++)
	{
		NSString *currentItem = [hostArray objectAtIndex:i];
		currentItem = [currentItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSArray *items = [currentItem componentsSeparatedByString:@" "];
		if ([items containsObject:@"mesu.apple.com"])
		{
			[hostArray removeObjectAtIndex:i];
		}
	}
	if (on == YES)
	{
		[hostArray addObject:@"127.0.0.1       mesu.apple.com"];
	}
	NSMutableString *thePl = [[NSMutableString alloc] initWithString:[hostArray componentsJoinedByString:@"\n"]];
	[thePl writeToFile:@"/etc/hosts" atomically:YES];
	[hostArray release];
	[hosts release];
	[thePl release];
	NSTask *task7 =[[NSTask alloc] init];
	[task7 setLaunchPath:@"/usr/sbin/lookupd"];
	[task7 setArguments:[NSArray arrayWithObjects:@"-flushcache",nil]];
	[task7 launch];
	[task7 waitUntilExit];
	return 0;
}
- (int)toggleTweak:(SMTweak)tw on:(BOOL)on
{
	int result = 0;

	
	
	if(tw==kSMTweakVNC)
		result=[self toggleVNC:on];
	else if(tw==kSMTweakFTP)
		result=[self switchService:@"ftp" on:on];
	else if(tw=kSMTweakSSH)
		result=[self toggleSSH:on];
	else if(tw==kSMTweakAFP)
		result=(on?[self EnableAppleShareServer]:[self DisableAppleShareServer]);
	else if(tw==kSMTweakRowmote)
		result=[self toggleRowmote:on];
    else if(tw==kSMTweakUpdates)
        result=[self toggleBlockUpdates:on];
	else if(tw==kSMTweakReadWrite)
    {
        DLog(@"Read Write Toggle is not here");
    }
	return result;
}

#pragma mark Class Management
- (NSString *)runPath {
    return [[runPath retain] autorelease];
}

- (void)setRunPath:(NSString *)value {
    if (runPath != value) {
        [runPath release];
        runPath = [value copy];
    }
}
#pragma mark Drives
- (int)isWritable
{
    BOOL wasWritable=NO;
	struct statfs statBuf; 
    
	if ( statfs("/", &statBuf) == -1 ) 
	{ 
        //SMHLogIt(@"/ is read-only");
		return ( 1 ); 
	} 
	
	// check mount flags -- do we even need to make a modification ? 
	if ( (statBuf.f_flags & MNT_RDONLY) == 0 ) 
	{ 
        //SMHLogIt(@"/ is writable");
		wasWritable = YES;
		return ( 0 ); 
	} 
	return (1);
}

- (BOOL)makeSystemWritable 
{ 
    SMHLogIt(@"Making / writable");
	//NSLog(@"%@ %s", self, _cmd);
	struct statfs statBuf; 
	
	//if ( pModified != NULL ) 
    //		*pModified = NO; 
	
	if ( statfs("/", &statBuf) == -1 ) 
	{ 
        SMHLogIt(@"statfs(\"/\"): %d", errno);
		return ( NO ); 
	} 
	
	// check mount flags -- do we even need to make a modification ? 
	if ( (statBuf.f_flags & MNT_RDONLY) == 0 ) 
	{ 
        SMHLogIt(@"/ was already writable");
		//wasWritable = YES;
		return ( YES ); 
	} 
	
	// once we get here, we'll need to change things... 
	// I'd love to use the mount syscall directly, but there doesn't 
	// seem to be any useful information on the HFS argument block that 
	// would require, grrr 
	NSArray * args = [NSArray arrayWithObjects: @"-o", @"rw,remount", 
                      [NSString stringWithUTF8String: statBuf.f_mntfromname], 
                      [NSString stringWithUTF8String: statBuf.f_mntonname], nil]; 
	NSTask * task = [NSTask launchedTaskWithLaunchPath: @"/sbin/mount" 
											 arguments: args]; 
	
	[task waitUntilExit]; 
	int status = [task terminationStatus]; 
	if ( status != 0 ) 
	{ 
		SMHLogIt(@"Remount as writable returned bad status %d (%#x)", status, status); 
		//PostNSError( status, NSPOSIXErrorDomain, 
        //					 LocalizedError(@"BootFSNotMadeWritable", @"Couldn't make the Boot FS writable"), 
        //					 [NSString stringWithFormat: @"Error = %ld", status] ); 
		return ( NO ); 
	} 
	
	//if ( pModified != NULL ) 
    //		*pModified = YES; 
	
	return ( YES ); 
} 

- (void) makeSystemReadOnly
{ 
    SMHLogIt(@"Making / Read Only");
	//NSLog(@"%@ %s", self, _cmd);
	struct statfs statBuf; 
	
	if ( statfs("/", &statBuf) == -1 ) 
	{ 
		SMHLogIt(@"s\ttatfs() on root failed, not reverting to read-only\n\n"); 
		return; 
	} 
	
	if ( (statBuf.f_flags & MNT_RDONLY) != 0 ) 
	{ 
		SMHLogIt(@"\tRoot filesystem already read-only\n\n"); 
		return; 
	} 
	
	// again, it'd be nice if we could do this through the mount() 
	// syscall... 
	NSArray * args = [NSArray arrayWithObjects: @"-o", @"ro,remount,force", 
                      [NSString stringWithUTF8String: statBuf.f_mntfromname], 
                      [NSString stringWithUTF8String: statBuf.f_mntonname], nil]; 
	NSTask * task = [NSTask launchedTaskWithLaunchPath: @"/sbin/mount" 
											 arguments: args]; 
	
	[task waitUntilExit]; 
	int status = [task terminationStatus]; 
	if ( status != 0 ) 
		SMHLogIt( @"\tRemount read-only returned bad status %d (%#x)\n\n", status, status ); 
} 

- (NSString *)mountImage:(NSString *)image
{
    SMHLogIt(@"Mounting Image: %@",image);
	NSTask *irTask = [[NSTask alloc] init];
	NSPipe *hdip = [[NSPipe alloc] init];
    NSFileHandle *hdih = [hdip fileHandleForReading];
	
	NSMutableArray *irArgs = [[NSMutableArray alloc] init];
	
	[irArgs addObject:@"attach"];
	[irArgs addObject:@"-plist"];
	
	[irArgs addObject:image];
	
	[irTask setLaunchPath:@"/usr/bin/hdiutil"];
	
	[irTask setArguments:irArgs];
	
	[irArgs release];
	
	[irTask setStandardError:hdip];
	[irTask setStandardOutput:hdip];
	//NSLog(@"hdiutil %@", [[irTask arguments] componentsJoinedByString:@" "]);
	[irTask launch];
    
	
	NSData *outData = [hdih readDataToEndOfFile];
	[irTask waitUntilExit];
	//CFDataRef outData = (CFDataRef)[hdih readDataToEndOfFile];
	while ([[hdih availableData] length] > 0)
	{
		NSLog(@"hdih length = %i", [[hdih availableData] length]);
	}
	NSString *error;
	NSPropertyListFormat format;
	//CFPropertyListRef plist = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, outData, kCFPropertyListImmutable, &error);
	id plist = [NSPropertyListSerialization propertyListFromData:outData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	if(!plist)
	{
		NSLog((NSString *)error);
	}
	
	NSArray *plistArray = [plist objectForKey:@"system-entities"];
	//int theItem = ([plistArray count] - 1);
	int i;
	NSString *mountPath = nil;
	for (i = 0; i < [plistArray count]; i++)
	{
		NSDictionary *mountDict = [plistArray objectAtIndex:i];
		mountPath = [mountDict objectForKey:@"mount-point"];
		if (mountPath != nil)
		{
			int rValue = [irTask terminationStatus];
			if (rValue == 0)
			{	[irTask release];
				irTask = nil;
                SMHLogIt(@"\timages was mounted at: %@",mountPath);
				return mountPath;
			}
		}
	}
	[irTask release];
	irTask = nil;
	SMHLogIt(@"\timage was not mounted");
	return nil;
}
- (void)unMountDrive:(NSString *)drive
{
    SMHLogIt(@"unmounting: %@",drive);
	NSTask *mdTask2 = [[NSTask alloc] init];
	NSPipe *mdip2 = [[NSPipe alloc] init];
	[mdTask2 setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask2 setArguments:[NSArray arrayWithObjects:@"unmount", drive, nil]];
	[mdTask2 setStandardOutput:mdip2];
	[mdTask2 setStandardError:mdip2];
	[mdTask2 launch];
	[mdTask2 waitUntilExit];
	//return TRUE;
}
- (void) makeDMGRW:(NSString *)drivepath newName:(NSString *)newName
{
	SMHLogIt(@"converting %@ to read-write",drivepath);
	NSTask *mdTask = [[NSTask alloc] init];
	NSPipe *mdip = [[NSPipe alloc] init];
	[mdTask setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask setArguments:[NSArray arrayWithObjects:@"convert", drivepath, @"-format", @"UDRW", @"-o",[[drivepath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName], nil]];
	[mdTask setStandardOutput:mdip];
	[mdTask setStandardError:mdip];
	[mdTask launch];
	[mdTask waitUntilExit];
	//return (TRUE);
	
}
- (void) makeDMGRO:(NSString *)drivepath newName:(NSString *)newName
{
	SMHLogIt(@"converting %@ to read only",drivepath);
	NSTask *mdTask = [[NSTask alloc] init];
	NSPipe *mdip = [[NSPipe alloc] init];
	[mdTask setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask setArguments:[NSArray arrayWithObjects:@"convert", drivepath, @"-format", @"UDZO", @"-o", [[drivepath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName], nil]];
	[mdTask setStandardOutput:mdip];
	[mdTask setStandardError:mdip];
	[mdTask launch];
	[mdTask waitUntilExit];
	//return (TRUE);
	
}

#pragma mark Restarting
-(void)restartFinder
{
    SMHLogIt(@"Restarting the Finder...");
    AGProcess *finder=[AGProcess processForCommand:@"Finder"];
    [finder terminate];
    [NSTask launchedTaskWithLaunchPath:@"/usr/bin/open" 
                             arguments:[NSArray arrayWithObject:@"/System/Library/CoreServices/Finder.app"]];
}
-(void)reboot
{
    SMHLogIt(@"Rebooting");
    [NSTask launchedTaskWithLaunchPath:@"/sbin/shutdown" 
                             arguments:[NSArray arrayWithObjects:@"-r",@"now",nil]];
}
#pragma mark extraction
- (int)extractArchive:(NSString *)archive toPath:(NSString *)path
{
    if (![archive hasPrefix:@"/"]) {
        archive=[[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:archive];
    }
    SMHLogIt(@"\tExtracting: %@",archive);
    NSString *ext = [archive pathExtension];
    if (ISString(ext,@"zip")) {
        SMHLogIt(@"\textracting zip archive");
        [self unZip:archive toLocation:path];
    }
    else if(ISString(ext,@"tgz")||ISString(ext,@"gz"))
    {
        SMHLogIt(@"\textracting gzip tar");
        [self extractGZip:archive toLocation:path];
    }
    else if(ISString(ext,@"tbz2")||ISString(ext,@"bz2"))
    {
        SMHLogIt(@"\textracting bzip2 tar");
        [self bunZip:archive toLocation:path];
    }
    else if(ISString(ext,@"tar")){
        SMHLogIt(@"\textracting tar archive");
        [self extractTar:archive toLocation:path];
    }
    else if(ISString(ext,@"rar"))
    {
        SMHLogIt(@"\trar files not supported yet");
    }
    else {
        SMHLogIt(@"\tArchive not supported");
    }
    return 0;
}
- (BOOL)gCheck
{
    return [self gCheckOnDisk:@"/"];
}
- (BOOL)gCheckOnDisk:(NSString *)disk
{
	
	BOOL copyG = FALSE;
	BOOL copyGu = FALSE;
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *gzipPath = [disk stringByAppendingPathComponent:@"usr/bin/gzip"];
	NSString *gunzipPath = [disk stringByAppendingPathComponent:@"usr/bin/gunzip"];
	NSString *filesRoot = [[self runPath] stringByDeletingLastPathComponent];
	
	if (![man fileExistsAtPath:gzipPath])
		copyG = [man copyPath:[filesRoot stringByAppendingPathComponent:@"gzip"] toPath:gzipPath handler:nil];
	else
		copyG = TRUE;
	
	
	if (![man fileExistsAtPath:gunzipPath])
		copyGu = [man copyPath:[filesRoot stringByAppendingPathComponent:@"gunzip"] toPath:gunzipPath handler:nil];
	else
		copyGu = TRUE;
	
	
	if ((copyG == TRUE) && (copyGu == TRUE))
	{
//        SMHLogIt(@"path1: %@",[filesRoot stringByAppendingPathComponent:@"gzip"]);
//		[self changePermissions:@"+x" onFile:[filesRoot stringByAppendingPathComponent:@"gzip"] isRecursive:NO];
//		[self changePermissions:@"+x" onFile:[filesRoot stringByAppendingPathComponent:@"gunzip"] isRecursive:NO];
        SMHLogIt(@"path2: %@",gzipPath);
        [self changePermissions:@"+x" onFile:gzipPath isRecursive:NO];
		[self changePermissions:@"+x" onFile:gunzipPath isRecursive:NO];
		//NSLog(@"gzip and gunzip installed or already installed\n\n");
		return ( TRUE );
	}
	
	return ( FALSE );
	
}
- (BOOL)bCheck
{
    return [self bCheckOnDisk:@"/"];
}
- (BOOL)bCheckOnDisk:(NSString *)disk
{
    BOOL copyG = FALSE;
	BOOL copyGu = FALSE;
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *bzipPath = [disk stringByAppendingPathComponent:@"usr/bin/bzip2"];
	NSString *bunzipPath = [disk stringByAppendingPathComponent:@"usr/bin/bunzip2"];
	NSString *filesRoot = [[self runPath] stringByDeletingLastPathComponent];
	
	if (![man fileExistsAtPath:bzipPath])
		copyG = [man copyPath:[filesRoot stringByAppendingPathComponent:@"bzip2"] toPath:bzipPath handler:nil];
	else
		copyG = TRUE;
	
	
	if (![man fileExistsAtPath:bunzipPath])
		copyGu = [man copyPath:[filesRoot stringByAppendingPathComponent:@"bunzip2"] toPath:bunzipPath handler:nil];
	else
		copyGu = TRUE;
	
	
	if ((copyG == TRUE) && (copyGu == TRUE))
	{
		[self changePermissions:@"+x" onFile:[filesRoot stringByAppendingPathComponent:@"bzip2"] isRecursive:NO];
		[self changePermissions:@"+x" onFile:[filesRoot stringByAppendingPathComponent:@"bunzip2"] isRecursive:NO];
        [self changePermissions:@"+x" onFile:bzipPath isRecursive:NO];
		[self changePermissions:@"+x" onFile:bunzipPath isRecursive:NO];
		//NSLog(@"gzip and gunzip installed or already installed\n\n");
		return ( TRUE );
	}
	
	return ( FALSE );
}
- (int)bunZip:(NSString *)inputTar toLocation:(NSString *)toLocation
{
    [self bCheck];
	NSTask *tarTask = [[NSTask alloc] init];
	NSFileHandle *nullOut = [NSFileHandle fileHandleWithNullDevice];
	
	[tarTask setLaunchPath:@"/usr/bin/tar"];
	[tarTask setArguments:[NSArray arrayWithObjects:@"fxpj", inputTar, nil]];
	[tarTask setCurrentDirectoryPath:toLocation];
	[tarTask setStandardError:nullOut];
	[tarTask setStandardOutput:nullOut];
	[tarTask launch];
	[tarTask waitUntilExit];
	
	int theTerm = [tarTask terminationStatus];
	
	[tarTask release];
	tarTask = nil;
	return theTerm;
	
}

- (int)extractGZip:(NSString *)inputTar toLocation:(NSString *)toLocation
{
	[self gCheck];
	NSTask *tarTask = [[NSTask alloc] init];
	NSFileHandle *nullOut = [NSFileHandle fileHandleWithNullDevice];
	
	[tarTask setLaunchPath:@"/usr/bin/tar"];
	[tarTask setArguments:[NSArray arrayWithObjects:@"xfpz", inputTar, nil]];
	[tarTask setCurrentDirectoryPath:toLocation];
	[tarTask setStandardError:nullOut];
	[tarTask setStandardOutput:nullOut];
	[tarTask launch];
	[tarTask waitUntilExit];
	
	int theTerm = [tarTask terminationStatus];
	
	[tarTask release];
	tarTask = nil;
	return theTerm;
	
}
- (int)extractGZip:(NSString *)file toLocation:(NSString *)path withPath:(BOOL)with
{
    if(!with)
        return [self extractGZip:file toLocation:path];
    
    [self gCheck];
	NSTask *tarTask = [[NSTask alloc] init];
	NSFileHandle *nullOut = [NSFileHandle fileHandleWithStandardOutput];
	
	[tarTask setLaunchPath:@"/usr/bin/tar"];
	[tarTask setArguments:[NSArray arrayWithObjects:@"fxpz", file,@"-C",path,nil]];
	[tarTask setCurrentDirectoryPath:path];
	[tarTask setStandardError:nullOut];
	[tarTask setStandardOutput:nullOut];
	[tarTask launch];
	[tarTask waitUntilExit];
	
	int theTerm = [tarTask terminationStatus];
	
	[tarTask release];
	tarTask = nil;
	return theTerm;
    
}
-(int)unZip:(NSString *)inputZip toLocation:(NSString *)toLocation
{
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; 
	NSTask *zipTask = [[NSTask alloc] init];
	NSFileHandle *nullOut = [NSFileHandle fileHandleWithNullDevice];
    //[self writeToLog:[ntvPath stringByAppendingPathComponent:@"unzip"]];
	[zipTask setLaunchPath:[ntvPath stringByAppendingPathComponent:@"unzip"]];
	[zipTask setArguments:[NSArray arrayWithObjects:inputZip,nil]];
	[zipTask setCurrentDirectoryPath:toLocation];
	[zipTask setStandardError:nullOut];
	[zipTask setStandardOutput:nullOut];
	[zipTask launch];
	[zipTask waitUntilExit];
	
	int theTerm = [zipTask terminationStatus];
	[zipTask release];
	zipTask=nil;
	return theTerm;
}


- (int)extractTar:(NSString *)inputTar toLocation:(NSString *)toLocation
{
	NSTask *tarTask = [[NSTask alloc] init];
	NSFileHandle *nullOut = [NSFileHandle fileHandleWithNullDevice];
	
	[tarTask setLaunchPath:@"/usr/bin/tar"];
	[tarTask setArguments:[NSArray arrayWithObjects:@"xfp", inputTar, nil]];
	[tarTask setCurrentDirectoryPath:toLocation];
	[tarTask setStandardError:nullOut];
	[tarTask setStandardOutput:nullOut];
	[tarTask launch];
	[tarTask waitUntilExit];
	
	int theTerm = [tarTask terminationStatus];
    
	[tarTask release];
	tarTask = nil;
	return theTerm;
	
}

#pragma mark Permissions
- (void)changeOwner:(NSString *)theOwner onFile:(NSString *)theFile isRecursive:(BOOL)isR
{
	NSTask *ownTask = [[NSTask alloc] init];
	NSMutableArray *ownArgs = [[NSMutableArray alloc] init];
	[ownTask setLaunchPath:@"/usr/sbin/chown"];
	if (isR)
		[ownArgs addObject:@"-R"];
	[ownArgs addObject:theOwner];
	[ownArgs addObject:theFile];
	
	[ownTask setArguments:ownArgs];
	
	//NSLog(@"chown %@", [ownArgs componentsJoinedByString:@" "]);
	[ownArgs release];
	[ownTask launch];
	[ownTask waitUntilExit];
	[ownTask release];
	ownTask = nil;
}

- (int)changePermissions:(NSString *)perms onFile:(NSString *)theFile isRecursive:(BOOL)isR
{
	NSTask *permTask = [[NSTask alloc] init];
	NSMutableArray *permArgs = [[NSMutableArray alloc] init];
	if (isR)
		[permArgs addObject:@"-R"];
	[permArgs addObject:perms];
	[permArgs addObject:theFile];
	
	[permTask setLaunchPath:@"/bin/chmod"];
	
	[permTask setArguments:permArgs];
	//NSLog(@"chmod %@", [[permTask arguments] componentsJoinedByString:@" "]);
	[permTask launch];
	[permTask waitUntilExit];
	[permTask release];
	permTask = nil;
    return 0;
}


#pragma mark Plugin Management
-(int)enableFrap:(NSString *)frap
{
    SMHLogIt(@"Enable Frap: %@",frap);
    NSString *frapname=[[[frap stringByDeletingPathExtension] lastPathComponent] stringByAppendingPathExtension:@"frappliance"];
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *frapPath =[pluginPath stringByAppendingPathComponent:frapname];
	//NSLog(@"frapPath: %@, pluginPath: %@",frapPath,pluginPath);
	NSString *disabledPath = [[pluginPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Plugins (Disabled)"];
	
	NSFileManager *man = [NSFileManager defaultManager];
	if([man fileExistsAtPath:frapPath])
	{
		//NSLog(@"frap exists");
		if(![man fileExistsAtPath:disabledPath])
			[man createDirectoryAtPath:disabledPath attributes:nil];
		
		disabledPath = [disabledPath stringByAppendingPathComponent:frapname];
		if ([man movePath:frapPath toPath:disabledPath handler:nil])
		{
            return 0;
			//NSLog(@"old path -1: %@",[oldPath stringByDeletingLastPathComponent]);
			//[man removeFileAtPath:[oldPath stringByDeletingLastPathComponent] handler:nil];
			//[man removeFileAtPath:frapPath handler:nil];
		}
		else
		{
            SMHLogIt(@"\tMove Failed");
		}
		
	}
    return 0;
}
-(int)disableFrap:(NSString *)frap
{
    SMHLogIt(@"Disable Frap: %@",frap);
    NSString *frapname=[[[frap stringByDeletingPathExtension] lastPathComponent] stringByAppendingPathExtension:@"frappliance"];
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *frapPath =[pluginPath stringByAppendingPathComponent:frapname];
	//NSLog(@"frapPath: %@, pluginPath: %@",frapPath,pluginPath);
	NSString *disabledPath = [[pluginPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Plugins (Disabled)"];
	disabledPath = [disabledPath stringByAppendingPathComponent:frapname];
	NSFileManager *man = [NSFileManager defaultManager];
	if([man fileExistsAtPath:disabledPath])
	{
		//NSLog(@"frap exists");
		
		if ([man movePath:disabledPath toPath:frapPath handler:nil])
		{
            return 0;
            //NSLog(@"old path -1: %@",[oldPath stringByDeletingLastPathComponent]);
			//[man removeFileAtPath:[oldPath stringByDeletingLastPathComponent] handler:nil];
			//[man removeFileAtPath:disabledPath handler:nil];
		}else
		{
            SMHLogIt(@"\tMove Failed");
            return 1;
		}
		
	}
    return 0;
}

- (int)plistHideFrap:(NSString *)plugin
{
    SMHLogIt(@"Hiding: %@",[plugin lastPathComponent]);
    NSString *path = [self getPluginPath:plugin];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SMHLogIt(@"\tPlugin does not exists at path: %@",path);
        return 1;
    }
	NSString *fullPath=[path stringByAppendingPathComponent:@"/Contents/Info.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        SMHLogIt(@"\tFile does not exists at path: %@",fullPath);
        return 1;
    }
	NSDictionary *infoplist=[[NSDictionary alloc] initWithContentsOfFile:fullPath];
    float final = [[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue];
    if (final>0)
        final=final*-1.;
    if (final==0)
        final=-0.0000000000002665f;
	[infoplist setValue:[NSNumber numberWithFloat:final] forKey:@"FRAppliancePreferedOrderValue"];
    [[NSFileManager defaultManager] removeFileAtPath:fullPath handler:nil];
	[infoplist writeToFile:fullPath atomically:YES];
    [infoplist release];
    infoplist=nil;
    infoplist=[[NSDictionary alloc] initWithContentsOfFile:fullPath];
    if ([[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue]>0) {
        return 1;
        SMHLogIt(@"\tNot Hidden");
    }
    return 0;
}
- (int)plistShowFrap:(NSString *)plugin
{
    
    SMHLogIt(@"Showing: %@",[plugin lastPathComponent]);
    NSString *path = [self getPluginPath:plugin];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SMHLogIt(@"\tPlugin does not exists at path: %@",path);
        return 1;
    }
	NSString *fullPath=[path stringByAppendingPathComponent:@"/Contents/Info.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        SMHLogIt(@"\tFile does not exists at path: %@",fullPath);
        return 1;
    }
	NSDictionary *infoplist=[[NSDictionary alloc] initWithContentsOfFile:fullPath];
    float final = [[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue];
    if (final==-0.0000000000002665f)
        final=0;
    else if (final<0)
        final=final*-1.;
	[infoplist setValue:[NSNumber numberWithFloat:final] forKey:@"FRAppliancePreferedOrderValue"];
    [[NSFileManager defaultManager] removeFileAtPath:fullPath handler:nil];
	[infoplist writeToFile:fullPath atomically:YES];
    [infoplist writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"temp.plist"] atomically:YES];
    [infoplist release];
    infoplist=nil;
    infoplist=[[NSDictionary alloc] initWithContentsOfFile:fullPath];
    if ([[infoplist objectForKey:@"FRAppliancePreferedOrderValue"] floatValue]<0) {
        //NSLog(@"bla not good: problem");
        SMHLogIt(@"\tNot Shown");
        return 1;
    }
    return 0;
}
- (int)changeOrder:(NSString *)plugin toOrder:(NSString *)value2
{
    SMHLogIt(@"Changin order of %@ to: %@",[plugin lastPathComponent],value2);
    NSString *path = [self getPluginPath:plugin];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SMHLogIt(@"\tPlugin does not exists at path: %@",path);
        return 1;
    }
	NSString *fullPath=[path stringByAppendingPathComponent:@"/Contents/Info.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        SMHLogIt(@"\tFile does not exists at path: %@",fullPath);
        return 1;
    }
	NSString *thevalue2 = value2;
	float value2_1= [thevalue2 floatValue];
	NSNumber *value22 = [[NSNumber alloc] initWithFloat:value2_1];
	NSDictionary *infoplist=[[NSDictionary alloc] initWithContentsOfFile:fullPath];
	[infoplist setValue:value22 forKey:@"FRAppliancePreferedOrderValue"];
    NSFileManager *man=[NSFileManager defaultManager];
    NSString *plistbakPath=[[fullPath stringByDeletingPathExtension]stringByAppendingPathExtension:@"plistbak"];
    if([man fileExistsAtPath:plistbakPath])
        [man removeFileAtPath:plistbakPath handler:nil];
    [man copyPath:fullPath toPath:plistbakPath handler:nil];
    [[NSFileManager defaultManager] removeFileAtPath:fullPath handler:nil];
	[infoplist writeToFile:fullPath atomically:YES];
    if([man fileExistsAtPath:fullPath])
    {
        [man copyPath:plistbakPath toPath:fullPath handler:nil];
        SMHLogIt(@"\tFailed to change order");
        return 1;
    }
    return 0;
    
	
}
-(int)backupFrap:(NSString *)frap
{
    SMHLogIt(@"Backup: %@",[frap lastPathComponent]);
    NSString *frapname=[[[frap lastPathComponent]stringByDeletingPathExtension]stringByAppendingPathExtension:@"frappliance"];
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *frapPath =[pluginPath stringByAppendingPathComponent:frapname];
	NSString *frapbase = [frapname stringByDeletingPathExtension];
	frapbase = [frapbase stringByAppendingPathExtension:@"bak"];
	NSFileManager *man = [NSFileManager defaultManager];
	if(![man fileExistsAtPath:@"/Users/frontrow/Documents/Backups/"])
		[man createDirectoryAtPath:@"/Users/frontrow/Documents/Backups/" attributes:nil];
    if ([man copyPath:frapPath toPath:[@"/Users/frontrow/Documents/Backups/" stringByAppendingPathComponent:frapbase] handler:nil])
    {
        return 0;
    }
    else {
        SMHLogIt(@"\tFailure");
        return 1;
    }
    return 0;
}
-(int)restoreFrap:(NSString *)frap
{
    SMHLogIt(@"Backup: %@",[frap lastPathComponent]);
    NSString *frapname=[[[frap lastPathComponent]stringByDeletingPathExtension]stringByAppendingPathExtension:@"frappliance"];
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *frapPath =[pluginPath stringByAppendingPathComponent:frapname];
	NSString *frapbase = [frapname stringByDeletingPathExtension];
	frapbase = [frapbase stringByAppendingPathExtension:@"bak"];
	NSFileManager *man = [NSFileManager defaultManager];
	if([man fileExistsAtPath:frapPath])
	{
		[man removeFileAtPath:frapPath handler:nil];
	}
	
	if ([man copyPath:[@"/Users/frontrow/Documents/Backups/" stringByAppendingPathComponent:frapbase] toPath:frapPath handler:nil])
	{
        return 0;
	}
    else {
        SMHLogIt(@"\tFailure");
        return 1;
    }
	
}
-(NSString *)getPluginPath:(NSString *)plugin
{
    NSString *pluginName=[[[plugin lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"frappliance"];
    return [FRAP_PATH stringByAppendingPathComponent:pluginName];
}
-(NSString *)getBackupPath:(NSString *)plugin
{
    NSString *pluginName=[[[plugin lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"bak"];
    return [BAK_PATH stringByAppendingPathComponent:pluginName];
}
#pragma mark File Management
-(int)installPluginWithArchive:(NSString *)archive
{
    NSFileManager *man = [NSFileManager defaultManager];

    if(![man fileExistsAtPath:archive])
    {
        SMHLogIt(@"file %@ was not found",archive);
        return 1;
    }
    NSString *tempPath=@"/tmp/smtmp/";
    if([man fileExistsAtPath:tempPath])
        [man removeFileAtPath:tempPath handler:nil];
    SMHLogIt(@"Installing From Archive");
    [man createDirectoryAtPath:tempPath attributes:nil];
    SMHLogIt(@"\tExtracting %@ to %@",[archive lastPathComponent],tempPath);
    [self extractArchive:archive toPath:tempPath];
    SMHLogIt(@"\tSearching For Frappliance");
    NSString *frappliancePath=[self ffindFrap:tempPath];
    if (frappliancePath==nil) {
        SMHLogIt(@"no frappliance found");
        return 2;
    }
    SMHLogIt(@"\tFound it at path: %@",frappliancePath);
    NSString *pluginName=[frappliancePath lastPathComponent];
    if ([man fileExistsAtPath:[FRAP_PATH stringByAppendingPathComponent:pluginName]]) {
        SMHLogIt(@"\tOld Plugin Found, temporarely moving it");
        [man copyPath:[FRAP_PATH stringByAppendingPathComponent:pluginName]
               toPath:[@"/Users/frontrow/old/" stringByAppendingPathComponent:pluginName]
              handler:nil];
        [man removeFileAtPath:[FRAP_PATH stringByAppendingPathComponent:pluginName] handler:nil];
        if ([man fileExistsAtPath:[FRAP_PATH stringByAppendingPathComponent:pluginName]])
        {
            SMHLogIt(@"\tNot Removed %@",[@"/Users/frontrow/old/" stringByAppendingPathComponent:pluginName]);
            return 3;
        }
            
    }
    SMHLogIt(@"\tInstalling %@\n\tto %@",frappliancePath,[FRAP_PATH stringByAppendingPathComponent:pluginName]);
    [man copyPath:frappliancePath 
           toPath:[FRAP_PATH stringByAppendingPathComponent:pluginName] 
          handler:nil];
    [man removeFileAtPath:tempPath handler:nil];
    if ([man fileExistsAtPath:[FRAP_PATH stringByAppendingPathComponent:pluginName]]) {
        [man removeFileAtPath:[@"/Users/frontrow/old/" stringByAppendingPathComponent:pluginName] handler:nil];
        [man removeFileAtPath:tempPath handler:nil];
        SMHLogIt(@"%@ was successfully installed",[pluginName stringByDeletingPathExtension]);
        return 0;
    }
    else
    {
        SMHLogIt(@"\tNOT INSTALLED");
        return 1;
    }
    return 1;
}
-(NSString *) findFrap:(NSString *)staging
{
    //BOOL isDir;
    //id importFile;
//    BOOL done=FALSE;
//    NSArray *array =[[NSFileManager defaultManager] directoryContentsAtPath:staging];
//    NSDirectoryEnumerator *dirEnum =[[NSFileManager defaultManager] enumeratorAtPath:staging];
//    NSFileManager *man=[NSFileManager defaultManager];
//    int i,count=[array count];
//    i=0;
//    while (done=FALSE)
//    {
//        
//            }
    return @"Empty";
}
-(NSString *) ffindFrap:(NSString *)importFolder
{
    //SMHLogIt(@"\tSearching: %@",importFolder);
    BOOL isDir;
    id importFile;
    NSDirectoryEnumerator *dirEnum =[[NSFileManager defaultManager] enumeratorAtPath:importFolder];
    while (importFile = [dirEnum nextObject])
    {
        isDir = NO;
        if (ISString([importFile pathExtension],@"frappliance")) {
            return [importFolder stringByAppendingPathComponent:importFile];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:importFile isDirectory:&isDir] && isDir)
        {
            // This is a nested folder: Recursive call
            NSString *string = [self ffindFrap:[importFolder stringByAppendingPathComponent:importFile]];         //[2.12]
            if (string !=nil) {
                //SMHLogIt(@"\treturning %@",string);
                return string;
            }
        }
    }
    return nil;
}
-(void)testFind
{
    NSString *path=@"/Users/frontrow/tmp";
    [self extractArchive:@"/Users/frontrow/nitoTV.tar" toPath:path];
    NSString *findFrap=[self ffindFrap:path];
    
    SMHLogIt(@"found at: %@",findFrap);
}
                        
-(int)removeFile:(NSString *)path
{
    SMHLogIt(@"Removing File at path: %@",path);
    NSFileManager *man = [NSFileManager defaultManager];
    
    if(![man fileExistsAtPath:path])
    {
        SMHLogIt(@"\tFile Not Found");
        return 1;
    }
    [man removeFileAtPath:path handler:nil];
    if ([man fileExistsAtPath:path]) {
        SMHLogIt(@"\tFile Not Deleted");
        return 2;
    }
    return 0;
}
#pragma mark Software Menu
-(int)installPython:(NSString *)file toVolume:(NSString *)targetVolume
{
    NSFileManager *man = [NSFileManager defaultManager];
    if ([man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Frameworks/Python.Framework"]]) {
        [man removeFileAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Frameworks/Python.Framework"] handler:nil];
    }
    if (![man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"mnt/Scratch/Library/Frameworks"]]) {
        [man constructPath:[targetVolume stringByAppendingPathComponent:@"mnt/Scratch/Library/Frameworks"]];
    }
    else if([man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"mnt/Scratch/Library/Frameworks/Python.Framework"]])
    {
        [man removeFileAtPath:[targetVolume stringByAppendingPathComponent:@"mnt/Scratch/Library/Frameworks/Python.Framework"] handler:nil];
    }
    if (ISString([file pathExtension],@"tgz")) {
        int i = [self extractGZip:file toLocation:[targetVolume stringByAppendingPathComponent:@"mnt/Scratch/Library/Frameworks/"]];
        
        if (i!=0) 
        {
            return i;
        }
    }
    else if (ISString([file pathExtension],@"dmg"))
    {
        [man createDirectoryAtPath:[targetVolume stringByAppendingPathComponent:@"mnt/Scratch/Library/Frameworks/Python.Framework"]
                        attributes:nil];
        SMHLogIt(@"Using dmg");
        NSString *volume=[self mountImage:file];
        NSString *archive= [volume stringByAppendingPathComponent:@"Python.mpkg/Contents/Packages/PythonFramework-2.6.pkg/Contents/Archive.pax.gz"];
        SMHLogIt(@"Launching Task");
        
        NSTask *tarTask = [[NSTask alloc] init];
        [tarTask setLaunchPath:@"/bin/pax"];
        [tarTask setArguments:[NSArray arrayWithObjects:@"-rzf", archive, @".", nil]];
        [tarTask setCurrentDirectoryPath:[targetVolume stringByAppendingPathComponent:@"mnt/Scratch/Library/Frameworks/Python.Framework"]];
        //        [tarTask setStandardError:nullOut];
        //        [tarTask setStandardOutput:nullOut];
        [tarTask launch];
        [tarTask waitUntilExit];
        int z=[tarTask terminationStatus];
        if (z!=0)
        {
            SMHLogIt(@"Error with Task");
            return 10;
        }
    }


    [man createSymbolicLinkAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Frameworks/Python.Framework"] 
                      pathContent:[targetVolume stringByAppendingPathComponent:@"mnt/Scratch/Library/Frameworks/Python.Framework"]];
    if([man fileExistsAtPath:@"/usr/bin/python"])
        [man removeFileAtPath:@"/usr/bin/python" handler:nil];
    if([man fileExistsAtPath:@"/usr/bin/python2.6"])
        [man removeFileAtPath:@"/usr/bin/python2.6" handler:nil];
    [man createSymbolicLinkAtPath:@"/usr/bin/python" pathContent:@"/Library/Frameworks/Python.Framework/Versions/2.6/bin/python"];
    [man createSymbolicLinkAtPath:@"/usr/bin/python2.6" pathContent:@"/Library/Frameworks/Python.Framework/Versions/2.6/bin/python2.6"];
    return 0;
}
-(int)installPerian:(NSString *)dmg toVolume:(NSString *)targetVolume
{
    NSFileManager *man = [NSFileManager defaultManager];
    if (![man fileExistsAtPath:dmg]||![[dmg pathExtension] isEqualToString:@"dmg"])
        return 20;
    NSString *volume=[self mountImage:dmg];
    
	if([man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Audio/Plug-Ins/Components/A52Codec.component"]])
		[man removeFileAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Audio/Plug-Ins/Components/A52Codec.component"] handler:nil];
	if([man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/Perian.component"]])
		[man removeFileAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/Perian.component"] handler:nil];
	if([man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/AC3MovieImport.component"]])
		[man removeFileAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/AC3MovieImport.component"] handler:nil];
	int i=[self unZip:[volume stringByAppendingPathComponent:@"Perian.prefPane/Contents/Resources/Components/Perian.zip"] toLocation:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/"]];
	int ii=[self unZip:[volume stringByAppendingPathComponent:@"Perian.prefPane/Contents/Resources/Components/QuickTime/AC3MovieImport.zip"] toLocation:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/"]];
	int iii=[self unZip:[volume stringByAppendingPathComponent:@"Perian.prefPane/Contents/Resources/Components/CoreAudio/A52Codec.zip"] toLocation:[targetVolume stringByAppendingPathComponent:@"Library/Audio/Plug-Ins/Components/"]];
	int iv=i+ii+iii;
	return iv;
    
    
}
-(int)installScreenSaver
{
    //BOOL read=YES;
    SMHLogIt(@"Installing Screensaver");
    NSFileManager *_man=[NSFileManager defaultManager];
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"])
        [self removeFile:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"];
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SMM.frss"])
        [self removeFile:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SMM.frss"];
    //DLog(@"path: %@",[[[self runPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMM.frss"],nil]];
	[_man copyPath:[[[self runPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMM.frss"] toPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SMM.frss" handler:nil];
	//[self unZip:[[[self runPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMM.frss.zip"] toLocation:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/"];
    return 0;
}
-(int)installDropbearToDrive:(NSString *)drive
{
    if (drive==nil) {
        drive==@"/";
    }
    SMHLogIt(@"Installing dropbear to : %@",drive);
    NSString *dropbearPath;
    NSFileManager *man=[NSFileManager defaultManager];
    if([man fileExistsAtPath:[[man currentDirectoryPath] stringByAppendingString:@"dropbear.tgz"]])
    {
        dropbearPath=[[man currentDirectoryPath] stringByAppendingString:@"dropbear.tgz"];
    }
    else if([man fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/dropbear.tgz"])
    {
        dropbearPath=@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/dropbear.tgz";
    }
    else {
        SMHLogIt(@"dropbear not found");
        return 1;
    }
    SMHLogIt(@"\tdropbear found!");
    
    NSString *tempPath=@"/tmp/smtmp/";
    SMHLogIt(@"\textracting to: %@",tempPath);
    if([man fileExistsAtPath:tempPath])
        [man removeFileAtPath:tempPath handler:nil];
    [man createDirectoryAtPath:tempPath attributes:nil];
    [self extractArchive:dropbearPath  toPath:tempPath];
    if (![man fileExistsAtPath:[tempPath stringByAppendingPathComponent:@"dropbear"]]) {
        SMHLogIt(@"Not Extracted Properly");
        return 2;
    }
    [man copyPath:[tempPath stringByAppendingPathComponent:@"dropbear/System/Library/LaunchDaemons/com.atvMod.dropbear.plist"]
           toPath:[drive stringByAppendingPathComponent:@"/System/Library/LaunchDaemons/com.atvMod.dropbear.plist"] 
          handler:nil];
    BOOL s = [man changeFileAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLong:0],NSFileGroupOwnerAccountID,
                               [NSNumber numberWithLong:0],NSFileOwnerAccountID,
                               [NSNumber numberWithLong:755],NSFilePosixPermissions,
                               nil]
                       atPath:[drive stringByAppendingPathComponent:@"/System/Library/LaunchDaemons/com.atvMod.dropbear.plist"]];
    if(!s)
    {
        SMHLogIt(@"failed permissions");
    }
    NSArray *files = [NSArray arrayWithObjects:@"dbclient",@"dropbear",@"dropbearconvert",@"dropbearkey",@"scp",nil];
    int i,count=[files count];
    for(i=0;i<count;i++)
    {
        NSString *origin = [[tempPath stringByAppendingPathComponent:@"dropbear/usr/bin"]
                  stringByAppendingPathComponent:[files objectAtIndex:i]];
        NSString *destination = [[drive stringByAppendingPathComponent:@"/usr/bin"]
                                 stringByAppendingPathComponent:[files objectAtIndex:i]];
        s=[man copyPath:origin toPath:destination handler:nil];
        if(!s)
            SMHLogIt(@"failed to copy: %@",[files objectAtIndex:i]);
        else {
            s=[man changeFileAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSNumber numberWithLong:0],NSFileGroupOwnerAccountID,
                                              [NSNumber numberWithLong:0],NSFileOwnerAccountID,
                                              [NSNumber numberWithLong:755],NSFilePosixPermissions,
                                              nil]
                                      atPath:destination];
            [self changePermissions:@"+x" onFile:destination isRecursive:NO];
            if (!s) {
                SMHLogIt(@"failed to change Permission on: %@",[files objectAtIndex:i]);
            }
        }

    }
    files = [NSArray arrayWithObjects:@"libarmfp.dylib",nil];
    count=[files count];
    for(i=0;i<count;i++)
    {
        NSString *origin = [[tempPath stringByAppendingPathComponent:@"dropbear/usr/lib"]
                            stringByAppendingPathComponent:[files objectAtIndex:i]];
        NSString *destination = [[drive stringByAppendingPathComponent:@"/usr/lib"]
                                 stringByAppendingPathComponent:[files objectAtIndex:i]];
        s=[man copyPath:origin toPath:destination handler:nil];
        if(!s)
            SMHLogIt(@"failed to copy: %@",[files objectAtIndex:i]);
        else {
            s=[man changeFileAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithLong:0],NSFileGroupOwnerAccountID,
                                         [NSNumber numberWithLong:0],NSFileOwnerAccountID,
                                         [NSNumber numberWithLong:755],NSFilePosixPermissions,
                                         nil]
                                 atPath:destination];
            if (!s) {
                SMHLogIt(@"failed to change Permission on: %@",[files objectAtIndex:i]);
            }
        }
        
    }
    files = [NSArray arrayWithObjects:@"dropbear-keygen-wrapper",@"sftp-server",nil];
    count=[files count];
    for(i=0;i<count;i++)
    {
        NSString *origin = [[tempPath stringByAppendingPathComponent:@"dropbear/usr/libexec"]
                            stringByAppendingPathComponent:[files objectAtIndex:i]];
        NSString *destination = [[drive stringByAppendingPathComponent:@"/usr/libexec"]
                                 stringByAppendingPathComponent:[files objectAtIndex:i]];
        s=[man copyPath:origin toPath:destination handler:nil];
        if(!s)
            SMHLogIt(@"failed to copy: %@",[files objectAtIndex:i]);
        else {
            s=[man changeFileAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithLong:0],NSFileGroupOwnerAccountID,
                                         [NSNumber numberWithLong:0],NSFileOwnerAccountID,
                                         [NSNumber numberWithLong:755],NSFilePosixPermissions,
                                         nil]
                                 atPath:destination];
            [self changePermissions:@"+x" onFile:destination isRecursive:NO];
            if (!s) {
                SMHLogIt(@"failed to change Permission on: %@",[files objectAtIndex:i]);
            }
        }
        
    }
    return 0;
}
#pragma mark Logging
-(void)logTaskWithPath:(NSString *)path withOptions:(NSArray *)options
{
    SMHLogIt(@"Running Task:\n\t %@ %@",path,[options componentsJoinedByString:@" "]);
}
@end
