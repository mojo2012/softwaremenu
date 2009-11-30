//
//  installHelperClass.m
//  example code
//
//  Created by nito on 8/30/07.
//  Copyright 2007 nito llc. All rights reserved.
//



#import "installHelperClass.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>
#import "AGProcess.h"

@interface ATVSettingsHelper
+(id)sharedInstance;
-(BOOL)performOSUpdate:(BOOL)fp8 EFIUpdate:(BOOL)fp12 IRUpdate:(BOOL)fp16 SIUpdate:(BOOL)fp20;
@end

@interface BRSettingsHelper
+(id)sharedInstance;
-(BOOL)performOSUpdate:(BOOL)fp8 EFIUpdate:(BOOL)fp12 IRUpdate:(BOOL)fp16 SIUpdate:(BOOL)fp20;
@end

@implementation installHelperClass

- (void)dealloc
{
	[_man release];
	[super dealloc];
}
-(void)OSUpdate
{
	NSString *hello =[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://softwaremenu.googlecode.com/files/counter.txt"]encoding:NSUTF8StringEncoding error:nil];
	
	NSLog(@"updating: %@",hello);
	NSBundle *appleTVFramework = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/AppleTV.framework"];
	[appleTVFramework load];
	id settingsHelper = nil;
	Class cls = nil;
	if(cls = NSClassFromString(@"ATVSettingsHelper")) {
		settingsHelper = [cls sharedInstance];
	} else if(cls = NSClassFromString(@"BRSettingsHelper")) {
		settingsHelper = [cls sharedInstance];
	} else {
		fprintf(stderr, "Can't find ATVSettingsHelper or BRSettingsHelper class, aborting.\n");
		exit(2);
	}
	
	if(!settingsHelper) {
		fprintf(stderr, "Instance of settings helper class not found?!\n");
		exit(3);
	}
	[settingsHelper performOSUpdate:YES EFIUpdate:YES IRUpdate:YES SIUpdate:YES];
	
}
-(void)removeFrap:(NSString *)frapname
{
	NSLog(@"frapName: %@",frapname);
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *frapPath =[pluginPath stringByAppendingPathComponent:frapname];
	NSLog(@"frapPath: %@, pluginPath: %@",frapPath,pluginPath);
	NSString *oldPath = [pluginPath stringByAppendingPathComponent:@"old"];
	
	NSFileManager *man = [NSFileManager defaultManager];
	if([man fileExistsAtPath:frapPath])
	{
		NSLog(@"frap exists");
		if(![man fileExistsAtPath:oldPath])
			[man createDirectoryAtPath:oldPath attributes:nil];
		
		oldPath = [oldPath stringByAppendingPathComponent:frapname];
		if ([man movePath:frapPath toPath:oldPath handler:nil])
		{
			NSLog(@"%@ moved successfully\n\n",frapname);
			NSLog(@"old path -1: %@",[oldPath stringByDeletingLastPathComponent]);
			[man removeFileAtPath:[oldPath stringByDeletingLastPathComponent] handler:nil];
			[man removeFileAtPath:frapPath handler:nil];
			
		}
		
	}
}
-(int)removeFile:(NSString *)filepath
{
	NSFileManager *man = [NSFileManager defaultManager];
	if([man fileExistsAtPath:filepath])
	{
		[man removeFileAtPath:filepath handler:nil];
	}
	else
	{
		NSLog(@"There was no File at path %@ anyway", filepath);
		return 0;
	}
	if([man fileExistsAtPath:filepath])
	{
		NSLog(@"File was not deleted");
		return 1;
	}
	else
	{
		NSLog(@"Files was deleted properly");
		return 0;
	}
	
}

-(void)hideFrap:(NSString *)frapname
{
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
			NSLog(@"%@ moved successfully\n\n",frapname);
			//NSLog(@"old path -1: %@",[oldPath stringByDeletingLastPathComponent]);
			//[man removeFileAtPath:[oldPath stringByDeletingLastPathComponent] handler:nil];
			//[man removeFileAtPath:frapPath handler:nil];
		}
		else
		{
			NSLog(@"move failed");
		}
		
	}
}
-(void)showFrap:(NSString *)frapname
{
	NSLog(@"===showFrap===");
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *frapPath =[pluginPath stringByAppendingPathComponent:frapname];
	//NSLog(@"frapPath: %@, pluginPath: %@",frapPath,pluginPath);
	NSString *disabledPath = [[pluginPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Plugins (Disabled)"];
	disabledPath = [disabledPath stringByAppendingPathComponent:frapname];
	NSLog(@"disabledPath: %@ ; frapPath: %@ ",disabledPath,frapPath);
	NSFileManager *man = [NSFileManager defaultManager];
	if([man fileExistsAtPath:disabledPath])
	{
		//NSLog(@"frap exists");
		
		if ([man movePath:disabledPath toPath:frapPath handler:nil])
		{
			NSLog(@"%@ moved successfully\n\n",frapname);
			//NSLog(@"old path -1: %@",[oldPath stringByDeletingLastPathComponent]);
			//[man removeFileAtPath:[oldPath stringByDeletingLastPathComponent] handler:nil];
			//[man removeFileAtPath:disabledPath handler:nil];
		}
		
	}
}
-(void)backupFrap:(NSString *)frapname
{
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *frapPath =[pluginPath stringByAppendingPathComponent:frapname];
	NSString *frapbase = [frapname stringByDeletingPathExtension];
	frapbase = [frapbase stringByAppendingPathExtension:@"bak"];
	
	//NSLog(@"frapPath: %@, pluginPath: %@",frapPath,pluginPath);
	//disabledPath = [disabledPath stringByAppendingPathComponent:frapname];
	NSFileManager *man = [NSFileManager defaultManager];
	if(![man fileExistsAtPath:@"/Users/frontrow/Documents/Backups/"])
		[man createDirectoryAtPath:@"/Users/frontrow/Documents/Backups/" attributes:nil];
		
		
		if ([man copyPath:frapPath toPath:[@"/Users/frontrow/Documents/Backups/" stringByAppendingPathComponent:frapbase] handler:nil])
		{
			NSLog(@"%@ moved successfully\n\n",frapname);
			//NSLog(@"old path -1: %@",[oldPath stringByDeletingLastPathComponent]);
			//[man removeFileAtPath:[oldPath stringByDeletingLastPathComponent] handler:nil];
			//[man removeFileAtPath:disabledPath handler:nil];
		}
		
}

-(void)restoreFrap:(NSString *)frapname
{
	NSLog(@"===restore===");
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *frapPath =[pluginPath stringByAppendingPathComponent:frapname];
	NSString *frapbase = [frapname stringByDeletingPathExtension];
	frapbase = [frapbase stringByAppendingPathExtension:@"bak"];
	
	//NSLog(@"frapPath: %@, pluginPath: %@",frapPath,pluginPath);
	//disabledPath = [disabledPath stringByAppendingPathComponent:frapname];
	NSFileManager *man = [NSFileManager defaultManager];
	NSLog(@"bakPath: %@, frapPath: %@",[@"/Users/frontrow/Documents/Backups/" stringByAppendingPathComponent:frapbase],frapPath);
	if([man fileExistsAtPath:frapPath])
	{
		[man removeFileAtPath:frapPath handler:nil];
	}
	
	if ([man copyPath:[@"/Users/frontrow/Documents/Backups/" stringByAppendingPathComponent:frapbase] toPath:frapPath handler:nil])
	{
		NSLog(@"%@ moved successfully\n\n",frapname);
		//NSLog(@"old path -1: %@",[oldPath stringByDeletingLastPathComponent]);
		//[man removeFileAtPath:[oldPath stringByDeletingLastPathComponent] handler:nil];
		//[man removeFileAtPath:disabledPath handler:nil];
	}
	
}



-(void)installPKG:(NSString *)thepath withName:(NSString *)thename
{
	NSString *thenameis =thename;
	NSString *thepathis =thepath;
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"/Library/Receipts/" stringByAppendingPathComponent:thenameis]])
	{
		NSLog(@"removing receipts at path : %@",[@"/Library/Receipts/" stringByAppendingPathComponent:thenameis]);
		NSTask * removeReceipt =[NSTask alloc];
		NSArray *remargs = [NSArray arrayWithObjects:@"-rf",[@"/Library/Receipts/" stringByAppendingPathComponent:thenameis],nil];
		[removeReceipt setArguments:remargs];
		[removeReceipt setLaunchPath:@"/bin/rm/"];
		[removeReceipt launch];
		[removeReceipt waitUntilExit];
		
		}
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"/Library/Receipts/" stringByAppendingPathComponent:thenameis]])
	{
		NSLog(@"Receipt is still here");
	}
	
	NSTask * install = [NSTask alloc];
	NSArray *args =[NSArray arrayWithObjects:@"-pkg",thenameis,@"-target", @"/",nil];
	[install setArguments:args];
	[install setLaunchPath:@"/usr/sbin/installer"];
	[install setCurrentDirectoryPath:thepathis];
	[install launch];
	[install waitUntilExit];
	NSLog(@"should be installed");
}
		

-(void)installSelf:(NSString *)location

{
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Frap Path
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	
	NSString *thename =[location lastPathComponent]; //Gets us the name of the file
	NSString *thenameextension = [thename pathExtension];
	NSLog(@"thenameext: %@",thenameextension);
	if([thenameextension isEqualToString:@"gz"] || [thenameextension isEqualToString:@"tgz"])
	{
		NSLog(@"extracting: gz");
		[self extractGZip:location toLocation:[location stringByDeletingLastPathComponent]];
	}
	else if([thenameextension isEqualToString:@"zip"])
	{
		NSTask *task = [[NSTask alloc] init];
		NSArray *args = [NSArray arrayWithObjects:location,nil];
		[task setArguments:args];
		[task setLaunchPath:[[[self runPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"unzip"]];
		[task setCurrentDirectoryPath:[location stringByDeletingLastPathComponent]];
		[task launch];
		[task waitUntilExit];
	}
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *thepath = [location stringByDeletingLastPathComponent];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];
	BOOL isDir;
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		
		//Moving frappliance
		NSLog(@"path extension: %@",[idStr pathExtension]);
		if([[idStr pathExtension] isEqualToString:@"frappliance"])
		{
			if([[NSFileManager defaultManager] fileExistsAtPath:[pluginPath stringByAppendingPathComponent:[idStr lastPathComponent]]])
			{
				NSLog(@"removing : %@", [idStr lastPathComponent]);
				[self removeFrap:[idStr lastPathComponent]];
			}
		NSLog(@"1:%@, 2:%@", [thepath stringByAppendingPathComponent:idStr],pluginPath);
			[NSTask launchedTaskWithLaunchPath:@"/bin/mv/" arguments:[NSArray arrayWithObjects:[thepath stringByAppendingPathComponent:idStr],pluginPath,nil]];
			NSLog(@"hello");
		}
		
		
		//if installer file .. nitoTV
		else if([[idStr pathExtension] isEqualToString:@"pkg"])
		{
			[self installPKG:thepath withName:idStr];
		}
		
		
		//Basically if it's a folder that's not a frappliance, let's look in it
		else if ([[NSFileManager defaultManager] fileExistsAtPath:[thepath stringByAppendingPathComponent:idStr] isDirectory:&isDir] && isDir)
		{
			NSFileManager *fileManager2 = [NSFileManager defaultManager];
			NSString *thepath2 = [thepath stringByAppendingPathComponent:idStr];
			long i2, count2 = [[fileManager directoryContentsAtPath:thepath2] count];
			for ( i2 = 0; i2 < count2; i2++ )
			{
				NSString *idStr2 = [[fileManager2 directoryContentsAtPath:thepath2] objectAtIndex:i2];
				NSLog(@"idStr2: %@",idStr2);
				if([[idStr2 pathExtension] isEqualToString:@"frappliance"])
				{
					if([[NSFileManager defaultManager] fileExistsAtPath:[pluginPath stringByAppendingPathComponent:[idStr2 lastPathComponent]]])
					{
						NSLog(@"removing : %@", [idStr lastPathComponent]);
						[self removeFrap:[idStr2 lastPathComponent]];
					}
					NSLog(@"trying to move - deeper");
					[NSTask launchedTaskWithLaunchPath:@"/bin/mv/" arguments:[NSArray arrayWithObjects:[thepath2 stringByAppendingPathComponent:idStr2],pluginPath,nil]];
				}
				
				//nitoTV again
				else if([[idStr2 pathExtension] isEqualToString:@"pkg"])
				{
					[self installPKG:thepath2 withName:idStr2];					
				}
				else
				{
					NSLog(@"Nothing to install");
				}
				
			}
		}
	}
	return;
	
		
	
	
}

- (int)updateSelf:(NSString *)location
{
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *ntvPath = [[self runPath] stringByDeletingLastPathComponent]; //Resources
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //Contents
	ntvPath = [ntvPath stringByDeletingLastPathComponent]; //should be absolute path.
	NSString *pluginPath = [ntvPath stringByDeletingLastPathComponent];
	NSString *oldPath = [pluginPath stringByAppendingPathComponent:@"old"];
	
	if(![man fileExistsAtPath:oldPath])
		[man createDirectoryAtPath:oldPath attributes:nil];
	
	oldPath = [oldPath stringByAppendingPathComponent:@"SoftwareMenu.frappliance"];
	
	// move self to pluginPath which is PlugIns/old/nitoTV.frappliance
	
	if ([man movePath:ntvPath toPath:oldPath handler:nil])
		NSLog(@"SoftwareMenu moved successfully\n\n");
	
	int untar = [self extractTar:location toLocation:pluginPath];
	
	if (untar == 0)
	{
		NSLog(@"untarred successfully!\n\n");
		[man removeFileAtPath:[oldPath stringByDeletingLastPathComponent] handler:nil];
		return 0;
	} else {
		NSLog(@"untar failed!\n\n");
		[man movePath:oldPath toPath:ntvPath handler:nil];
		return -1;
	}
	
	return -1;
}

- (void) makeDMGRW:(NSString *)drivepath
{
	NSLog(@"converting");
	NSTask *mdTask = [[NSTask alloc] init];
	NSPipe *mdip = [[NSPipe alloc] init];
	[mdTask setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask setArguments:[NSArray arrayWithObjects:@"convert", drivepath, @"-format", @"UDRW", @"-o",[[drivepath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"converted.dmg"], nil]];
	[mdTask setStandardOutput:mdip];
	[mdTask setStandardError:mdip];
	[mdTask launch];
	[mdTask waitUntilExit];
	//return (TRUE);
	
}
- (void) makeDMGRO:(NSString *)drivepath
{
	
	NSTask *mdTask = [[NSTask alloc] init];
	NSPipe *mdip = [[NSPipe alloc] init];
	[mdTask setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask setArguments:[NSArray arrayWithObjects:@"convert", drivepath, @"-format", @"UDZO", @"-o", [[drivepath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"final.dmg"], nil]];
	[mdTask setStandardOutput:mdip];
	[mdTask setStandardError:mdip];
	[mdTask launch];
	[mdTask waitUntilExit];
	//return (TRUE);
	
}

- (void)mountDrive:(NSString *)drivepath
{
	NSTask *mdTask2 = [[NSTask alloc] init];
	NSPipe *mdip2 = [[NSPipe alloc] init];
	[mdTask2 setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask2 setArguments:[NSArray arrayWithObjects:@"attach", drivepath, nil]];
	[mdTask2 setStandardOutput:mdip2];
	[mdTask2 setStandardError:mdip2];
	[mdTask2 launch];
	[mdTask2 waitUntilExit];
	//return TRUE;
}
- (void)unMountDrive:(NSString *)drive
{
	NSTask *mdTask2 = [[NSTask alloc] init];
	NSPipe *mdip2 = [[NSPipe alloc] init];
	[mdTask2 setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask2 setArguments:[NSArray arrayWithObjects:@"unmount", @"/Volumes/OSBoot 1/", nil]];
	[mdTask2 setStandardOutput:mdip2];
	[mdTask2 setStandardError:mdip2];
	[mdTask2 launch];
	[mdTask2 waitUntilExit];
	//return TRUE;
}

- (void)makeASRscan:(NSString *)drivepath
{
	NSLog(@"starting ASR");
	NSTask *mdTask2 = [[NSTask alloc] init];
	NSPipe *mdip2 = [[NSPipe alloc] init];
	NSFileHandle *hdih = [mdip2 fileHandleForReading];
	[mdTask2 setLaunchPath:@"/usr/bin/sudo"];
	[mdTask2 setArguments:[NSArray arrayWithObjects:@"/usr/sbin/asr",@"-imagescan", drivepath, nil]];
	[mdTask2 setStandardOutput:mdip2];
	[mdTask2 setStandardError:mdip2];
	[mdTask2 launch];
	[mdTask2 waitUntilExit];
	NSData *outData;
	outData = [hdih readDataToEndOfFile];
	NSString *string = [[NSString alloc] initWithData: outData encoding: NSUTF8StringEncoding];
	NSLog(@"%@",string);
	//return TRUE;
}
-(int)setNetworkName:(NSString *)newName
{
	NSTask *changeName = [[NSTask alloc] init];
	[changeName setLaunchPath:@"/usr/sbin/scutil"];
	[changeName setArguments:[NSArray arrayWithObjects:@"–set",@"LocalHostName", newName, nil]];
	[changeName launch];
	[changeName waitUntilExit];
	int i = [changeName terminationStatus];
	NSTask *changeHost = [[NSTask alloc] init];
	[changeHost setLaunchPath:@"/usr/sbin/scutil"];
	[changeHost setArguments:[NSArray arrayWithObjects:@"–set",@"ComputerName", newName, nil]];
	[changeHost launch];
	[changeHost waitUntilExit];
	int ii = [changeName terminationStatus];
	int returnValue = i+ii;
	return returnValue;

}

- (int)installBinutilsToVolume:(NSString *)path
{
    //NSString *basePath=@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/binutils.zip";
    NSFileManager *man = [NSFileManager defaultManager];
    NSString *staging = @"/Users/frontrow/SM_Staging_folder";
    if(![man fileExistsAtPath:staging])
    {
        [man constructPath:staging];
    }
    [self unZip:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/binutils.zip" toLocation:@"/Users/frontrow/SM_Staging_folder"];
    NSArray *files = [_man directoryContentsAtPath:@"/Users/frontrow/SM_Staging_folder/binutils/"];
    int il;
    for (il=0;il<[files count];il++)
    {
        NSLog(@"file: %@",[files objectAtIndex:il]);
        [_man copyPath:[@"/Users/frontrow/SM_Staging_folder/binutils/" stringByAppendingPathComponent:[files objectAtIndex:il]] toPath:[@"/Volumes/OSBoot 1/usr/bin/" stringByAppendingPathComponent:[[files objectAtIndex:il] lastPathComponent]] handler:nil];
    }
    int b = [self extractGZip:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/binutils.tgz" toLocation:@"/Volumes/OSBoot 1/" withPath:YES];
    if(b!=0)
    {
        NSLog(@"incorrect extraction: %i",b);
    }
    return 0;
}
- (void)copySSHFiles
{
	//[self extractTar:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/dropbear.tar.gz"  toLocation:@"/Users/frontrow/"];
	[self extractGZip:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/dropbear.tgz" toLocation:@"/Users/frontrow/"];
	NSLog(@"copy SSHFiles");
	NSString *origBase=@"/Users/frontrow/dropbear";
	NSString *newBase=@"/Volumes/OSBoot 1";
	//[self extractGZip:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/dropbear.tgz" toLocation:@"/Volumes/OSBoot 1/"];
	NSFileManager *man = [NSFileManager defaultManager];
	NSArray *fromlocations =[[NSArray alloc] initWithObjects:@"System/Library/LaunchDaemons/com.atvMod.dropbear.plist",@"usr/bin/sshh",@"usr/bin/dbclient",@"usr/bin/dropbear",@"usr/bin/dropbearconvert",@"usr/bin/dropbearkey",@"usr/bin/scp",@"usr/lib/libarmfp.dylib",@"Users/frontrow/.bash_login",@"usr/libexec/dropbear-keygen-wrapper",@"usr/libexec/sftp-server",nil];
	NSEnumerator *enumerator =[fromlocations objectEnumerator];
	id obje;
	while((obje = [enumerator nextObject]) != nil) 
	{
		//NSLog(@"%@\n%@",[origBase stringByAppendingPathComponent:obje],[newBase stringByAppendingPathComponent:obje]);
		if([man fileExistsAtPath:[origBase stringByAppendingPathComponent:obje]])
		{
			if([obje hasPrefix:@"/Users/"])
			{
				newBase=@"/";
			}
			else
			{
				newBase=@"/Volumes/OSBoot 1";
			}
			if([man fileExistsAtPath:[newBase stringByAppendingPathComponent:obje]])
			{
				[man removeFileAtPath:[newBase stringByAppendingPathComponent:obje] handler:nil];
			}
			NSLog(@"trying to move");
			//[man copyPath:@"/Users/frontrow/dropbear" toPath:@"/Users/frontrow/dropbear2" handler:nil];
			NSTask *mdTask3 = [[NSTask alloc] init];
			NSPipe *mdip3 = [[NSPipe alloc] init];
			[mdTask3 setLaunchPath:@"/bin/cp"];
			
				[mdTask3 setArguments:[NSArray arrayWithObjects:[origBase stringByAppendingPathComponent:obje], [newBase stringByAppendingPathComponent:obje], nil]];
			
			
			[mdTask3 setStandardOutput:mdip3];
			[mdTask3 setStandardError:mdip3];
			[mdTask3 launch];
			[mdTask3 waitUntilExit];
			if([man fileExistsAtPath:[newBase stringByAppendingPathComponent:obje]])
			{
				NSLog(@"file %@ created",[newBase stringByAppendingPathComponent:obje]);
			}

		}
		NSTask *mdTask2 = [[NSTask alloc] init];
		NSPipe *mdip2 = [[NSPipe alloc] init];
		[mdTask2 setLaunchPath:@"/bin/chmod"];
		if([obje isEqualToString:@"usr/libexec/ssh-keysign"])
		{
			[mdTask2 setArguments:[NSArray arrayWithObjects:@"4755", [newBase stringByAppendingPathComponent:obje], nil]];
		}
		else
		{
			[mdTask2 setArguments:[NSArray arrayWithObjects:@"755", [newBase stringByAppendingPathComponent:obje], nil]];
			[self changeOwner:@"root:wheel" onFile:[newBase stringByAppendingPathComponent:obje] isRecursive:NO];
		}
		
		[mdTask2 setStandardOutput:mdip2];
		[mdTask2 setStandardError:mdip2];
		
		[mdTask2 launch];
		[mdTask2 waitUntilExit];
	}
	NSTask *mdTask4 = [[NSTask alloc] init];
	NSPipe *mdip4 = [[NSPipe alloc] init];
	
	[mdTask4 setLaunchPath:@"/bin/cp"];
	
	[mdTask4 setArguments:[NSArray arrayWithObjects:@"-rf",@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance", @"/Volumes/OSBoot 1/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance", nil]];
	
	
	[mdTask4 setStandardOutput:mdip4];
	[mdTask4 setStandardError:mdip4];
	[mdTask4 launch];
	[mdTask4 waitUntilExit];
	
	NSTask *mdTask13 = [[NSTask alloc] init];
	NSPipe *mdip13 = [[NSPipe alloc] init];
	[mdTask13 setLaunchPath:@"/bin/cp"];
	
	[mdTask13 setArguments:[NSArray arrayWithObjects:[origBase stringByAppendingPathComponent:@"/Users/frontrow/.dropbear_banner"], @"/Users/frontrow/", nil]];
	[mdTask13 setStandardOutput:mdip13];
	[mdTask13 setStandardError:mdip13];
	[mdTask13 launch];
	[mdTask13 waitUntilExit];
	[self changeOwner:@"frontrow:frontrow" onFile:@"/Users/frontrow/.dropbear_banner" isRecursive:NO];
	[self changePermissions:@"755" onFile:@"/Users/frontrow/.dropbear_banner" isRecursive:NO];
	NSTask *mdTask14 = [[NSTask alloc] init];
	NSPipe *mdip14 = [[NSPipe alloc] init];
	[mdTask14 setLaunchPath:@"/bin/cp"];
	
	[mdTask14 setArguments:[NSArray arrayWithObjects:[origBase stringByAppendingPathComponent:@"/Users/frontrow/.bash_login"], @"/Users/frontrow/", nil]];
	[mdTask14 setStandardOutput:mdip14];
	[mdTask14 setStandardError:mdip14];
	[mdTask14 launch];
	[mdTask14 waitUntilExit];
	[self changeOwner:@"frontrow:frontrow" onFile:@"/Users/frontrow/.bash_login" isRecursive:NO];
	[self changePermissions:@"755" onFile:@"/Users/frontrow/.bash_login" isRecursive:NO];
    [self installBinutilsToVolume:nil];
    //copying gzip files (for 3.0.1)
//    if(![man fileExistsAtPath:@"/Volumes/OSBoot 1/usr/bin/gzip"])
//    {
//        [man copyPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/gzip" toPath:@"/Volumes/OSBoot 1/usr/bin/gzip" handler:nil];
//    }
//    if(![man fileExistsAtPath:@"/Volumes/OSBoot 1/usr/bin/gunzip"])
//    {
//        [man copyPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/gunzip" toPath:@"/Volumes/OSBoot 1/usr/bin/gunzip" handler:nil];
//    }
    
	/*[mdTask5 setLaunchPath:@"/usr/bin/sudo"];
	
	[mdTask5 setArguments:[NSArray arrayWithObjects:@"touch",@"/Volumes/OSBoot 1/.readwrite", nil]];
	
	
	[mdTask5 setStandardOutput:mdip5];
	[mdTask5 setStandardError:mdip5];
	[mdTask5 launch];
	[mdTask5 waitUntilExit];*/
	
	
	//[man copyPath:@"/System/Library/CoreServices/Finder.app/Conents/PlugIns/SoftwareMenu.frappliance" toPath:@"/System/Library/CoreServices/Finder.app/Conents/PlugIns/SoftwareMenu.frappliance" handler:NULL];
	//return TRUE;
}
- (int)install_perian:(NSString *)perian_path toVolume:(NSString *)targetVolume
{
	NSString *volume=[self mountImage:perian_path];
	if([_man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Audio/Plug-Ins/Components/A52Codec.component"]])
		[_man removeFileAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Audio/Plug-Ins/Components/A52Codec.component"] handler:nil];
	if([_man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/Perian.component"]])
		[_man removeFileAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/Perian.component"] handler:nil];
	if([_man fileExistsAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/AC3MovieImport.component"]])
		[_man removeFileAtPath:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/AC3MovieImport.component"] handler:nil];
	int i=[self unZip:[volume stringByAppendingPathComponent:@"Perian.prefPane/Contents/Resources/Components/Perian.zip"] toLocation:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/"]];
	int ii=[self unZip:[volume stringByAppendingPathComponent:@"Perian.prefPane/Contents/Resources/Components/QuickTime/AC3MovieImport.zip"] toLocation:[targetVolume stringByAppendingPathComponent:@"Library/Quicktime/"]];
	int iii=[self unZip:[volume stringByAppendingPathComponent:@"Perian.prefPane/Contents/Resources/Components/CoreAudio/A52Codec.zip"] toLocation:[targetVolume stringByAppendingPathComponent:@"Library/Audio/Plug-Ins/Components/"]];
	int iv=i+ii+iii;
	return iv;
}
- (int)toggleUpdate
{
	BOOL addHost = YES;
	int returnValue = 0;
	NSMutableString *hosts = [[NSMutableString alloc] initWithContentsOfFile:@"/etc/hosts"];
	NSMutableArray *hostArray = [[NSMutableArray alloc] initWithArray:[hosts componentsSeparatedByString:@"\n"]];
	int i;
	for (i = 0; i < [hostArray count]; i++)
	{
		NSString *currentItem = [hostArray objectAtIndex:i];
		currentItem = [currentItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		//NSLog(@"currentItem: %@", currentItem);
		NSArray *items = [currentItem componentsSeparatedByString:@" "];
		if ([items containsObject:@"mesu.apple.com"])
		{
			addHost = NO;
			returnValue = 1;
			//NSLog(@"item %i: %@ item to remove", i, currentItem);
			[hostArray removeObjectAtIndex:i];
		}
	}
	if (addHost == YES)
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
	return returnValue;
}
- (int)blockUpdate
{
	BOOL addHost = YES;
	int returnValue = 0;
	NSMutableString *hosts = [[NSMutableString alloc] initWithContentsOfFile:@"/etc/hosts"];
	NSMutableArray *hostArray = [[NSMutableArray alloc] initWithArray:[hosts componentsSeparatedByString:@"\n"]];
	int i;
	for (i = 0; i < [hostArray count]; i++)
	{
		NSString *currentItem = [hostArray objectAtIndex:i];
		currentItem = [currentItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		//NSLog(@"currentItem: %@", currentItem);
		NSArray *items = [currentItem componentsSeparatedByString:@" "];
		if ([items containsObject:@"mesu.apple.com"])
		{
			addHost = NO;
			returnValue = 1;
			//NSLog(@"item %i: %@ item to remove", i, currentItem);
			//[hostArray removeObjectAtIndex:i];
		}
	}
	if (addHost == YES)
	{
		[hostArray addObject:@"127.0.0.1       mesu.apple.com"];
	}
	NSMutableString *thePl = [[NSMutableString alloc] initWithString:[hostArray componentsJoinedByString:@"\n"]];
	[thePl writeToFile:@"/etc/hosts" atomically:YES];
	[hostArray release];
	[hosts release];
	[thePl release];
	
	return returnValue;
}

- (BOOL)gCheck 
{
	
	BOOL copyG = FALSE;
	BOOL copyGu = FALSE;
	NSFileManager *man = [NSFileManager defaultManager];
	NSString *gzipPath = @"/usr/bin/gzip";
	NSString *gunzipPath = @"/usr/bin/gunzip";
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
		[self changePermissions:@"+x" onFile:[filesRoot stringByAppendingPathComponent:@"gzip"] isRecursive:NO];
		[self changePermissions:@"+x" onFile:[filesRoot stringByAppendingPathComponent:@"gunzip"] isRecursive:NO];
		//NSLog(@"gzip and gunzip installed or already installed\n\n");
		return ( TRUE );
	}
	
	return ( FALSE );
	
}

- (id)init
{
	if(self = [super init]) {
		
		
	}
	_man = [NSFileManager defaultManager];
	return self;
}



- (NSString *)mountImage:(NSString *)irString
{
	NSTask *irTask = [[NSTask alloc] init];
	NSPipe *hdip = [[NSPipe alloc] init];
    NSFileHandle *hdih = [hdip fileHandleForReading];
	
	NSMutableArray *irArgs = [[NSMutableArray alloc] init];

	//[irArgs addObject:@"attach"];
	//[irArgs addObject:@"-plist"];
	[irArgs addObject:@"mount"];
    [irArgs addObject:@"-owners"];
    [irArgs addObject:@"on"];
	[irArgs addObject:irString];
	
	[irTask setLaunchPath:@"/usr/bin/hdiutil"];
	
	[irTask setArguments:irArgs];
	
	[irArgs release];
	
	[irTask setStandardError:hdip];
	[irTask setStandardOutput:hdip];
	//NSLog(@"hdiutil %@", [[irTask arguments] componentsJoinedByString:@" "]);
	[irTask launch];
	[irTask waitUntilExit];
	
	NSData *outData;
	outData = [hdih readDataToEndOfFile];
	NSString *error;
	NSPropertyListFormat format;
	id plist;
	plist = [NSPropertyListSerialization propertyListFromData:outData
			
												 mutabilityOption:NSPropertyListImmutable
			
														   format:&format
			
												 errorDescription:&error];
	if(!plist)
			
	{
			
		NSLog(error);
			
		[error release];
			
	}
		//NSLog(@"plist: %@", plist);
		
		NSArray *plistArray = [plist objectForKey:@"system-entities"];
	
		//int theItem = ([plistArray count] - 1);
		
		NSDictionary *mountDict = [plistArray lastObject];
		
		NSString *mountPath = [mountDict objectForKey:@"mount-point"];
		
		//NSLog(@"Mount Point: %@", mountPath);
		
		
	int rValue = [irTask terminationStatus];
	
	if (rValue == 0)
	{	[irTask release];
		irTask = nil;
		return mountPath;
	}
	
	[irTask release];
	irTask = nil;	
	return nil;
}

- (NSString *)runPath {
    return [[runPath retain] autorelease];
}

- (void)setRunPath:(NSString *)value {
    if (runPath != value) {
        [runPath release];
        runPath = [value copy];
    }
}





- (int)bunZip:(NSString *)inputTar toLocation:(NSString *)toLocation
{
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

- (void)changePermissions:(NSString *)perms onFile:(NSString *)theFile isRecursive:(BOOL)isR
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
}

- (void)changeOrder:(NSString *)value toOrder:(NSString *)value2
{
	NSString *fullPath=value;
	NSString *thevalue2 = value2;
	float value2_1= [thevalue2 floatValue];
	NSNumber *value22 = [[NSNumber alloc] initWithFloat:value2_1];
	fullPath=[fullPath stringByAppendingPathComponent:@"/Contents/Info.plist"];
	NSDictionary *infoplist=[[NSDictionary alloc] initWithContentsOfFile:fullPath];
	[infoplist setValue:value22 forKey:@"FRAppliancePreferedOrderValue"];
	[infoplist writeToFile:fullPath atomically:YES];
	
}

- (BOOL)wasWritable {
	
    return wasWritable;
	
}








- (int)isWritable
{
	struct statfs statBuf; 

	if ( statfs("/", &statBuf) == -1 ) 
	{ 
		NSLog( @"statfs(\"/\"): %d", errno ); 
		return ( 1 ); 
	} 
	
	// check mount flags -- do we even need to make a modification ? 
	if ( (statBuf.f_flags & MNT_RDONLY) == 0 ) 
	{ 
		NSLog( @"Root filesystem already writable\n\n" );
		wasWritable = YES;
		return ( 0 ); 
	} 
	return (1);
}

- (BOOL)makeSystemWritable 
{ 
	//NSLog(@"%@ %s", self, _cmd);
	struct statfs statBuf; 
	
	//if ( pModified != NULL ) 
//		*pModified = NO; 
	
	if ( statfs("/", &statBuf) == -1 ) 
	{ 
		NSLog( @"statfs(\"/\"): %d", errno ); 
		return ( NO ); 
	} 
	
	// check mount flags -- do we even need to make a modification ? 
	if ( (statBuf.f_flags & MNT_RDONLY) == 0 ) 
	{ 
		NSLog( @"Root filesystem already writable\n\n" );
		wasWritable = YES;
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
		NSLog( @"Remount as writable returned bad status %d (%#x)", status, status ); 
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
	//NSLog(@"%@ %s", self, _cmd);
	struct statfs statBuf; 
	
	if ( statfs("/", &statBuf) == -1 ) 
	{ 
		NSLog( @"statfs() on root failed, not reverting to read-only\n\n" ); 
		return; 
	} 
	
	if ( (statBuf.f_flags & MNT_RDONLY) != 0 ) 
	{ 
		NSLog( @"Root filesystem already read-only\n\n" ); 
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
		NSLog( @"Remount read-only returned bad status %d (%#x)\n\n", status, status ); 
} 

- (int)toggleVNC:(BOOL)tosetting
{
	NSLog(@"toggleVNC");
	//fprintf(stdout, "\nToggleVNC: ")
	//fprintf(stdout, [)
	if(!tosetting)
	{
		//printf("hello");
		NSLog(@"OFF");
		AGProcess *argAgent = [AGProcess processForCommand:@"AppleVNCServer"];
		if (argAgent != nil)
			[argAgent terminate];
		NSTask * configureKickstart =[NSTask alloc];
		NSArray *configArgs = [NSArray arrayWithObjects:@"-deactivate",nil];
		[configureKickstart setArguments:configArgs];
		[configureKickstart setLaunchPath:@"/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"];
		[configureKickstart launch];
		[configureKickstart waitUntilExit];
		NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 1];
		[NSThread sleepUntilDate:future];
	}
	else
	{
		NSLog(@"ON");
		/*if(![_man fileExistsAtPath:@"/Library/Preferences/com.apple.VNCSettings.txt"])
		{
			NSString *passKey = @"71463E00FFDAAA95FF1C39567390ADCA";
			[passKey writeToFile:@"/Library/Preferences/com.apple.VNCSettings.txt" atomically:YES];
		}
		NSTask * configureKickstart =[NSTask alloc];
		NSArray *configArgs = [NSArray arrayWithObjects:@"-configure",@"-clientopts",@"-setvnclegacy",@"-vnclegacy",@"yes",nil];
		[configureKickstart setArguments:configArgs];
		[configureKickstart setLaunchPath:@"/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"];
		[configureKickstart launch];
		[configureKickstart waitUntilExit];*/
		
		NSTask * runKick =[NSTask alloc];
		NSArray *runArgs = [NSArray arrayWithObjects:@"-activate",nil];
		[runKick setArguments:runArgs];
		[runKick setLaunchPath:@"/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"];
		[runKick launch];
		[runKick waitUntilExit];
		[NSTask launchedTaskWithLaunchPath:@"/System/Library/CoreServices/RemoteManagement/AppleVNCServer.bundle/Contents/MacOS/AppleVNCServer" arguments:[NSArray arrayWithObjects:@"&",nil]];
		
	}
	return 0;
	
}
- (int)toggleSSH:(BOOL)tosetting
{
	NSString *sshType = nil;
	if ( [[NSFileManager defaultManager] fileExistsAtPath: @"/usr/bin/dropbear"] == YES )
	{ 
		sshType = @"com.atvMod.dropbear";
	}
	else
	{
		sshType = @"ssh";
	}
	int theTerm;
	if(tosetting)
	{
		theTerm=[self enableService:sshType];
	}
	else
	{
		theTerm=[self disableService:sshType];
	}
	return theTerm;
}
- (int)toggleFTP:(BOOL)tosetting
{
	int theTerm;
	if(tosetting)
	{
		theTerm=[self enableService:@"ftp"];
	}
	else
	{
		theTerm=[self disableService:@"ftp"];
	}
	return theTerm;
}
/*- (int) toggleRowmote:(BOOL)tosetting
{
	int returnValue =1;
	if(![_man fileExistsAtPath:[[FRAP_PATH stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMBak"]])
		[_man createDirectoryAtPath:[[FRAP_PATH stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMBak"] attributes:nil];
	if(tosetting)
	{
		[_man movePath:[[[FRAP_PATH stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMBak"] stringByAppendingPathComponent:@"RowmoteHelperATV.frappliance"] toPath:[FRAP_PATH stringByAppendingPathComponent:@"RowmoteHelperATV.frappliance"] handler:nil];
		if([_man fileExistsAtPath:[FRAP_PATH stringByAppendingPathComponent:@"RowmoteHelperATV.frappliance"]])
		{
			returnValue=0;
		}
	}
	else
	{
		[_man movePath:[FRAP_PATH stringByAppendingPathComponent:@"RowmoteHelperATV.frappliance"] toPath:[[[FRAP_PATH stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMBak"] stringByAppendingPathComponent:@"RowmoteHelperATV.frappliance"] handler:nil];
		if([_man fileExistsAtPath:[[FRAP_PATH stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMBak"]])
		{
			returnValue=0;
		}
	}
	return returnValue;
}*/
-(int)toggleRowmote:(BOOL)tosetting
{
	AGProcess *argAgent = [AGProcess processForCommand:@"RowmoteHelperATV"];
	if (argAgent != nil && !tosetting)
		[argAgent terminate];
	if(argAgent ==nil && tosetting)
		[NSTask launchedTaskWithLaunchPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/RowmoteHelperATV.frappliance/Contents/Resources/RowmoteHelperATV" arguments:[NSArray arrayWithObjects:nil]];
	return 0;
}
- (int)toggleTweak:(NSString *)setting toValue:(NSString *)toValue
{
	int result = 0;
	BOOL toggle=NO;
	if([toValue isEqualToString:@"ON"])
	{
		toggle = YES;
	}
	
	
	if([setting isEqualToString:@"VNC"])
	{
		[self toggleVNC:toggle];
	}
	else if([setting isEqualToString:@"FTP"])
	{
		[self toggleFTP:toggle];
	}
	else if([setting isEqualToString:@"SSH"] || [setting isEqualToString:@"Dropbear"])
	{
		result=[self toggleSSH:toggle];
	}
	else if([setting isEqualToString:@"AFP"])
	{
		[self toggleAFP:toggle];
	}
	else if([setting isEqualToString:@"Rowmote"])
	{
		[self toggleRowmote:toggle];
	}
	else if([setting isEqualToString:@"RW"])
	{
		if(!toggle){
			NSLog(@"Make read only");
			[self makeSystemReadOnly];
		}
		else
		{
			NSLog(@"Make Writable");
			[self makeSystemWritable];
		}
	}
	return result;
}
- (int)disableService:(NSString *)theService
{
	NSString *launchCtl = [NSString stringWithFormat:@"/bin/launchctl unload -w /System/Library/LaunchDaemons/%@.plist", theService];
	
	chdir( "/" );
	
    // *really* become root
    setuid( 0 );
    setgid( 0 );
	
    int status = system( [launchCtl UTF8String] );
	
	
    if ( status != 0 )
    {
        NSLog( @"launchctl returned bad status '%d' (%#x)", status, status );
        
        return ( 1 );
    }
	if([theService isEqualToString:@"com.atvMod.dropbear"])
	{
		NSLog(@"killing dropbear");
		AGProcess *argAgent = [AGProcess processForCommand:@"dropbear"];
		if (argAgent != nil)
			[argAgent terminate];
	}
	
    return ( 0 );
}
- (int)enableService:(NSString *)theService
{
	NSString *launchCtl = [NSString stringWithFormat:@"/bin/launchctl load -w /System/Library/LaunchDaemons/%@.plist", theService];
	
	
	chdir( "/" );
	
    // *really* become root
    setuid( 0 );
    setgid( 0 );
	
    int status = system( [launchCtl UTF8String] );
	
	
    if ( status != 0 )
    {
        NSLog( @"launchctl returned bad status '%d' (%#x)", status, status );
        
        return ( 1 );
    }
	
    return ( 0 );
}
- (int)toggleAFP:(BOOL)tosetting
{
	int result;
	if(tosetting)
	{
		result= [self EnableAppleShareServer];
	}
	else
	{
		result= [self DisableAppleShareServer];
	}
	return result;
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
		NSLog(@"Failed To Load hostconfig");
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
            NSLog( @"AFP Server hostconfig entry not found, adding..." );
            [hostconfig insertString: @"AFPSERVER=-YES-\n" atIndex: 0];
        }
        else
        {
            NSLog( @"AFP Server already enabled" );
            return ( 1 );     // don't write file or start server
        }
    }
	
    if ( [hostconfig writeToFile: @"/etc/hostconfig" atomically: YES] == NO )
    {
        //ATVErrorLog( @"Failed to write hostconfig" );
       /* PostNSError( EIO, NSPOSIXErrorDomain,
					LocalizedError(@"HostconfigWriteFailed", @"Unable to write /etc/hostconfig"),
					nil );*/
		NSLog(@"Cannot write Hostconfig");
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
		NSLog(@"Cannot load hostconfig");
        return ( 1 );
    }
	
    if ( [hostconfig replaceOccurrencesOfString: @"AFPSERVER=-YES-"
                                     withString: @"AFPSERVER=-NO-"
                                        options: 0
                                          range: NSMakeRange(0, [hostconfig length])] == 0 )
    {
        NSLog( @"AFP Server already stopped, or not configured" );
        return ( 1 );
    }
	
    if ( [hostconfig writeToFile: @"/etc/hostconfig" atomically: YES] == NO )
    {
        /*ATVErrorLog( @"Failed to write hostconfig" );
        PostNSError( EIO, NSPOSIXErrorDomain,
					LocalizedError(@"HostconfigWriteFailed", @"Unable to write /etc/hostconfig"),
					nil );*/
		NSLog(@"cannot write hostconfig");
    }
	
    NSString * pidString = [NSString stringWithContentsOfFile: @"/var/run/AppleFileServer.pid"];
    pid_t procID = (pid_t) [pidString intValue];
    NSLog( @"Killing AFP server, process ID '%d'", (int) procID );
	
    if ( procID > 0 )
        kill( procID, SIGTERM );
	
    return ( 0 );
}
-(int)runscript:(NSString *)scriptpath
{
	NSTask *task = [[NSTask alloc] init];
	//NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
	[task setArguments:[NSArray arrayWithObjects:scriptpath,nil]];
	[task setLaunchPath:@"/bin/bash"];
	//NSPipe *outPipe = [[NSPipe alloc] init];
	
	//[task setStandardOutput:outPipe];
	//[task setStandardError:outPipe];
	//NSFileHandle *file;
	//file = [outPipe fileHandleForReading];
	
	[task launch];
	[task waitUntilExit];
	return 0;
}
-(int)installScreenSaver
{
    //BOOL read=YES;

    [self makeSystemWritable];
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"])
        [self removeFile:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"];
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SMM.frss"])
        [self removeFile:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SMM.frss"];
    NSLog(@"path: %@",[[[self runPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMM.frss"]);
	[_man copyPath:[[[self runPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMM.frss"] toPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SMM.frss" handler:nil];
	//[self unZip:[[[self runPath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMM.frss.zip"] toLocation:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/"];
    [self makeSystemReadOnly];
    return 0;
}


-(int)restart:(NSString *)value
{
	return 0;
}
-(int)runscript
{
	return 0;
}
@end
