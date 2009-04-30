//
//  SMTweaks.m
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMTweaks.h"
#import "SMGeneralMethods.h"
#import "SMMedia.h"
#import "SoftwareSettings.h"
#import "AGProcess.h"
#import "SMMediaPreview.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>
 
@implementation SMTweaks
- (id) previewControlForItem: (long) item
{
    // If subclassing BRMediaMenuController, this function is called when the selection cursor
    // passes over an item.
	if(item >= [_items count])
		return nil;
	else
	{
		
		
		SMMedia	*meta = [[SMMedia alloc] init];
		[meta setDefaultImage];
		[meta setTitle:[[_items objectAtIndex:item] title]];
		NSString *imageName = nil;		
		NSLog(@"preview");
		[meta setDescription:[settingDescriptions objectAtIndex:item]];	

		switch([[settingNumberType objectAtIndex:item] intValue])
		{
			case kSMTwRestart:
				imageName = [settingNames objectAtIndex:item];
			case kSMTwToggle:
				imageName = [[settingNames objectAtIndex:item] substringFromIndex:6];
				break;
			case kSMTwDownloadRowmote:
				[meta setDev:[_rowmoteDict valueForKey:@"Developer"]];

				[meta setTitle:[@"Rekeased: " stringByAppendingString:[[_rowmoteDict valueForKey:@"ReleaseDate"] descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:nil]]];
				[meta setDescription:[_rowmoteDict valueForKey:@"ShortDescription"]];
				[meta setOnlineVersion:[_rowmoteDict valueForKey:@"displayVersion"]];
			case kSMTwDownload:
			case kSMTwDownloadPerian:
				imageName = [[settingNames objectAtIndex:item] substringFromIndex:8];
				break;

			case kSMTwFix:
				imageName = [[settingNames objectAtIndex:item] substringFromIndex:3];
				break;
			case kSMTwInstall:
				imageName = [[settingNames objectAtIndex:item] substringFromIndex:7];
				break;
			case kSMTwReload:
				[meta setBRImage:[[SMThemeInfo sharedTheme] refreshImage]];
				break;
		} ;
		if([_man fileExistsAtPath:[[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"]])
		{
			[meta setImagePath:[[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"]];
		}
		else
		{
			[meta setDefaultImage];
		}
		
		
		SMMediaPreview *previewtoo =[[SMMediaPreview alloc] init];
		[previewtoo setShowsMetadataImmediately:YES];
		//[previewtoo setDeletterboxAssetArtwork:YES];
		[previewtoo setAsset:meta];
		
		return [previewtoo autorelease];
	}
}
-(void)getDict;
{
	_infoDict=[NSMutableDictionary dictionaryWithContentsOfURL:(NSURL *)[BASE_URL stringByAppendingString:@"tweaks.plist"]];
	[_infoDict retain];
}
-(id)init
{
	self=[super init];
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	[SMGeneralMethods checkFolders];
	_rowmoteDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
	[_rowmoteDict addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://rowmote.com/rowmote-atv-version.plist"]]];
	NSMutableDictionary *nitoUpdatesDict = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://nitosoft.com/version.plist"]];
	if(nitoUpdatesDict != nil)
	{
		[_rowmoteDict setObject:[nitoUpdatesDict objectForKey:@"perianDisplayVersion"] forKey:@"perianDisplayVersion"];
		[_rowmoteDict setObject:[nitoUpdatesDict objectForKey:@"perianVersion"] forKey:@"perianVersion"];
		[_rowmoteDict setObject:[nitoUpdatesDict objectForKey:@"perianDownloadLink"] forKey:@"perianDownloadLink"];
	}
	[[self list] removeDividers];
	
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Tweaks Menu",@"Tweaks Menu")];
	settingNames = [[NSMutableArray alloc] initWithObjects:
					@"restartFinder",
					@"reloadList",
					@"fixSapphire",
					@"toggleRW",
					@"toggleDropbear",
					@"toggleRowmote",
					@"toggleAFP",
					@"toggleVNC",
					@"toggleFTP",
					@"installDropbear",
					@"downloadRowmote",
					@"downloadPerian",
					nil];
	settingDisplays = [[NSMutableArray alloc] initWithObjects:
					   BRLocalizedString(@"Restart Finder",@"Restart Finder"),
					   BRLocalizedString(@"Refresh",@"Refresh"),
					   BRLocalizedString(@"Fix Sapphire",@"Fix Sapphire"),
					   BRLocalizedString(@"Disk Read/Write toggle",@"Disk Read/Write toggle"),
					   BRLocalizedString(@"Dropbear SSH toggle",@"Dropbear SSH toggle"),
					   BRLocalizedString(@"Rowmote toggle",@"Rowmote toggle"),
					   BRLocalizedString(@"AFP toggle",@"AFP toggle"),
					   BRLocalizedString(@"VNC toggle",@"VNC toggle"),
					   BRLocalizedString(@"FTP toggle",@"FTP toggle"),
					   BRLocalizedString(@"Install Dropbear SSH",@"Install Dropbear SSH"),
					   BRLocalizedString(@"Install Rowmote",@"Install Rowmote"),
					   BRLocalizedString(@"Install Perian",@"Install Perian"),
					   nil];
	settingDescriptions = [[NSMutableArray alloc] initWithObjects:
						   @"Restarts the Finder, necessary after install of Perian or Rowmote",
						   @"Refreshes the List because sometimes changes can take a while to be taken into effect",
						   @"Deletes the Sapphire Metadata, which can cause a problem after upgrade",
						   @"Changes the disk status from Read-Write to Read-Only",
						   @"Turn SSH On/Off -- If dropbear is installed, it will using that is what you are using",
						   @"Toggle Rowmote ON/OFF",
						   @"Toggle AFP server",
						   @"Toggle VNC server",
						   @"Toggle FTP server",
						   @"Install Dropbear (will Fix SSH in case you somehow broke it) - Does not work yet",
						   @"Install Rowmote Helper Program for AppleTV                (www.rowmote.com - needs the iphone/ipod program rowmote)",
						   @"Will download and Install Perian",
						   nil];
	/*settingType = [[NSMutableArray alloc] initWithObjects:
				   @"Fix",
				   @"toggle",
				   @"toggle",
				   @"toggle",
				   @"toggle",
				   @"toggle",
				   @"toggle",
				   @"install",
				   @"Download",
				   @"Download",
				   nil];*/
	settingNumberType = [[NSMutableArray alloc] initWithObjects:
						 [NSNumber numberWithInt:0],
						 [NSNumber numberWithInt:6],
						 [NSNumber numberWithInt:1],
						 [NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:3],
						 [NSNumber numberWithInt:5],
						 [NSNumber numberWithInt:4],
						 nil];
	
	
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	_infoDict= [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
	_man = [NSFileManager defaultManager];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	
	
	int i,counter;
	i=[settingNames count];
	for(counter=0;counter<i;counter++)
	{
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc]init];
		[item setTitle:[settingDisplays objectAtIndex:counter]];
		//[_options addObject:[NSArray arrayWithObjects:[settingType objectAtIndex:counter],[settingNames objectAtIndex:counter],[settingDisplays objectAtIndex:counter],nil]];
		[_items addObject:item];
		
		
	}
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:9 withLabel:BRLocalizedString(@"Installs",@"Installs")];
	[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Restart Finder",@"Restart Finder")];
	[[self list] addDividerAtIndex:2 withLabel:@"Toggles"];
	
	return self;
}
-(id)initCustom
{

		return self;
}
-(void)itemSelected:(long)row
{
	NSMutableArray * args = [[NSMutableArray alloc] initWithObjects:nil];
	NSMutableDictionary *dlDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	NSString *a=nil;
	NSLog(@"option selected: %@",[settingDisplays objectAtIndex:row]);
	if(![[self itemForRow:row] dimmed])
	{
		
		switch([[settingNumberType objectAtIndex:row]intValue])
		{
			case kSMTwRestart:
				a=nil;
				AGProcess *killFinder = [AGProcess processForCommand:@"Finder"];
				[killFinder terminate];
				break;
			case kSMTwToggle:
				NSLog(@"toggle");
				[args addObject:@"-toggleTweak"];
				[args addObject:[[settingNames objectAtIndex:row] substringFromIndex:6]];
				if([self getToggleRightText:[settingNames objectAtIndex:row]])
				{
					[args addObject:@"OFF"];
					if([[settingNames objectAtIndex:row] isEqualToString:@"toggleRowmote"])
					{
						[SMGeneralMethods setBool:YES forKey:@"DisableRowmote" forDomain:ROWMOTE_DOMAIN_KEY];
					}
				}
				else
				{
					[args addObject:@"ON"];
					if([[settingNames objectAtIndex:row] isEqualToString:@"toggleVNC"])
					{
						[self VNCFix];
					}
					if([[settingNames objectAtIndex:row] isEqualToString:@"toggleRowmote"])
					{
						[SMGeneralMethods setBool:NO forKey:@"DisableRowmote" forDomain:ROWMOTE_DOMAIN_KEY];
					}
				}
				
				[SMGeneralMethods runHelperApp:args];
				break;
			case kSMTwDownloadRowmote:
				NSLog(@"Rowmote");
				SMDownloaderTweaks *rowmoteDownloader = [[SMDownloaderTweaks alloc] init];
				[dlDict setValue:[_rowmoteDict valueForKey:@"URL"] forKey:@"url"];
				[dlDict setValue:[NSString stringWithFormat:@"Rowmote Helper Version %@",[_rowmoteDict valueForKey:@"Version"],nil] forKey:@"name"];
				[dlDict setValue:[NSString stringWithFormat:@"Downloading Rowmote Version: %@\nfromURL: %@",[_rowmoteDict valueForKey:@"Version"],[_rowmoteDict valueForKey:@"URL"]] forKey:@"downloadtext"];
				[rowmoteDownloader setInformationDict:dlDict];
				[[self stack]pushController:rowmoteDownloader];
				break;
			case kSMTwDownloadPerian:
				NSLog(@"Perian");
				SMDownloaderTweaks *perianDownloader = [[SMDownloaderTweaks alloc] init];
				[dlDict setValue:[_rowmoteDict valueForKey:@"perianDownloadLink"] forKey:@"url"];
				[dlDict setValue:[NSString stringWithFormat:@"Perian Version %@(%@)",[_rowmoteDict valueForKey:@"perianDisplayVersion"],[_rowmoteDict valueForKey:@"perianVersion"], nil] forKey:@"name"];
				[dlDict setValue:[NSString stringWithFormat:@"Downloading Rowmote Version: %@\nfromURL: %@",[_rowmoteDict valueForKey:@"perianDisplayVersion"],[_rowmoteDict valueForKey:@"perianDownloadLink"]] forKey:@"downloadtext"];
				[perianDownloader setInformationDict:dlDict];
				[[self stack]pushController:perianDownloader];
				break;
			case kSMTwFix:
				[_man removeFileAtPath:@"/Users/frontrow/Library/Application Support/Sapphire/metaData.plist" handler:nil];
				break;
			case kSMTwReload:
				[[self list] reload];
				break;

				
				
		} 

		
	}
		
	[[self list] reload];
}
- (id)itemForRow:(long)row					
{ 
	NSString *LocalVersion = nil;
	NSString *title = [settingNames objectAtIndex:row];
	//BOOL setDimmed=NO;

	BRTextMenuItemLayer *item = [BRTextMenuItemLayer menuItem];
	BOOL result = NO;

	switch([[settingNumberType objectAtIndex:row] intValue])
	{
		case kSMTwToggle:
			result = ![self getToggleDimmed:title];
			[item setDimmed:result];
		
			if(![item dimmed])
			{
				NSString *rightText = @"OFF";
				BOOL isActive = NO;
				[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] redGem], @"BRMenuIconImageKey",nil]];
				if([self getToggleRightText:title])
				{
					rightText=@"ON";
					isActive = YES;
					[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] greenGem], @"BRMenuIconImageKey",nil]];

				}
				//[item setRightJustifiedText:rightText];
				[_infoDict setObject:[NSArray arrayWithObjects:[NSNumber numberWithBool:result],[NSNumber numberWithBool:isActive],nil] forKey:title];
			}
			else
			{
				[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] greyGem], @"BRMenuIconImageKey",nil]];
				[_infoDict setObject:[NSArray arrayWithObjects:[NSNumber numberWithBool:result],nil] forKey:title];
			}
			break;
		case kSMTwDownloadRowmote:
			LocalVersion = nil;
			LocalVersion = [self getRowmoteVersion];
			if([LocalVersion compare:[_rowmoteDict valueForKey:@"Version"]]==NSOrderedAscending)		
						{[item setRightJustifiedText:[_rowmoteDict valueForKey:@"displayVersion"]];}
			else 		{[item setDimmed:YES];}
			break;
		case kSMTwDownloadPerian:
			LocalVersion = [self getPerianVersion];
			if([LocalVersion compare:[_rowmoteDict valueForKey:@"perianDisplayVersion"]]==NSOrderedAscending)		{[item setRightJustifiedText:[_rowmoteDict valueForKey:@"perianDisplayVersion"]];}
			else		{[item setDimmed:YES];}
			break;
		case kSMTwInstall:
			[item setDimmed:YES];
			break;
	}
	

			
	
	[item setTitle:[settingDisplays objectAtIndex:row]];
	return item;
	
}
- (NSString *)getRowmoteVersion
{
	NSString * RowmoteVersion =@"0.0";
	NSString *pListPath = nil;
	if([_man fileExistsAtPath: @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/RowmoteHelperATV.frappliance"])
	{
		pListPath = @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/RowmoteHelperATV.frappliance/Contents/Info.plist";
	}
	NSDictionary *rowDict = [NSDictionary dictionaryWithContentsOfFile:pListPath];
	if(rowDict !=nil)
		RowmoteVersion = [rowDict valueForKey:@"CFBundleVersion"];
	NSLog(@"RowMoteVersion: %@, pListPath: %@", [rowDict valueForKey:@"CFBundleVersion"],pListPath,nil);
	return RowmoteVersion;
}
-(NSString *)getPerianVersion
{
	NSString * PerianVersion =@"0.0";
	NSString *pListPath = nil;
	if([_man fileExistsAtPath: @"/Library/QuickTime/Perian.component"])
	{
		pListPath = @"/Library/QuickTime/Perian.component/Contents/Info.plist";
	}
	NSDictionary *rowDict = [NSDictionary dictionaryWithContentsOfFile:pListPath];
	if(rowDict !=nil)
		PerianVersion = [rowDict valueForKey:@"CFBundleVersion"];
	NSLog(@"perianVersion: %@", [rowDict valueForKey:@"CFBundleVersion"]);
	return PerianVersion;
}
-(BOOL)dropbearIsInstalled
{
	return YES;//( [[NSFileManager defaultManager] fileExistsAtPath: @"/usr/bin/dropbear"] );
}
-(BOOL)RowmoteIsInstalled
{
	return ([_man fileExistsAtPath: @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/RowmoteHelperATV.frappliance"]);
}
-(BOOL)RowmoteIsRunning
{
	BOOL result = NO;
	AGProcess *argAgent = [AGProcess processForCommand:@"RowmoteHelperATV"];
	if (argAgent != nil)
		result = YES;
return result;
}

-(BOOL)VNCIsInstalled
{
	BOOL result = NO;
	if ([_man fileExistsAtPath: @"/System/Library/CoreServices/RemoteManagement"] && 
		[_man fileExistsAtPath: @"/System/Library/Perl/"] &&
		[_man fileExistsAtPath: @"/System/Library/Perl/5.8.6/"])
	{
		result=YES;
	}
	return result;
}

- (BOOL)sshStatus //0 = on, 1 = off //YES=ON, NO=OFF
{
	NSString *sshType = nil;
	if ( [[NSFileManager defaultManager] fileExistsAtPath: @"/usr/bin/dropbear"] == YES )
		sshType = @"com.atvMod.dropbear";
	else
		sshType = @"ssh";
	
	NSTask *serviceTask = [[NSTask alloc] init];
	[serviceTask setLaunchPath:@"/sbin/service"];
	
	[serviceTask setArguments:[NSArray arrayWithObjects:@"--test-if-configured-on", sshType,nil]];
	[serviceTask launch];
	[serviceTask waitUntilExit];
	int termStatus = [serviceTask terminationStatus];
	[serviceTask release];
	serviceTask = nil;
	return ![[NSNumber numberWithInt:termStatus] boolValue];
}
- (BOOL)serviceIsRunning:(NSString *)serviceType
{
	NSTask *serviceTask = [[NSTask alloc] init];
	[serviceTask setLaunchPath:@"/sbin/service"];
	
	[serviceTask setArguments:[NSArray arrayWithObjects:@"--test-if-configured-on", serviceType,nil]];
	[serviceTask launch];
	[serviceTask waitUntilExit];
	int termStatus = [serviceTask terminationStatus];
	[serviceTask release];
	serviceTask = nil;
	return ![[NSNumber numberWithInt:termStatus] boolValue];
}

-(BOOL)AFPIsRunning
{
	BOOL result = NO;
	
    NSString * str = [NSString stringWithContentsOfFile: @"/etc/hostconfig"];
    if ( str != nil )
    {
        NSRange range = [str rangeOfString: @"AFPSERVER=-YES-"];
        if ( range.location != NSNotFound )
            result = YES;
    }
	
    return ( result );
}
-(BOOL)VNCIsRunning
{
	BOOL result = NO;
	AGProcess *argAgent = [AGProcess processForCommand:@"AppleVNCServer"];
	if (argAgent != nil)
		result = YES;
	return result;
}
/*-(BOOL)VNCIsRunning
{
	return NO;
}*/
-(BOOL)isRW
{
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
		return ( YES ); 
	} 
	return (NO);
}
-(BOOL)FTPIsInstalled
{
	BOOL result = NO;
	if ([_man fileExistsAtPath: @"/usr/libexec/ftpd"] && 
		[_man fileExistsAtPath: @"/etc/ftpusers"])
	{
		result=YES;
	}
	return result;
}

-(BOOL)AFPIsInstalled
{
	BOOL result = NO;
	if([_man fileExistsAtPath:@"/System/Library/Frameworks/AppleTalk.framework"] &&
		[_man fileExistsAtPath:@"/System/Library/Frameworks/AppleShareClient.framework"] &&
		[_man fileExistsAtPath:@"/System/Library/Frameworks/AppleShareClientCore.framework"] &&
		[_man fileExistsAtPath:@"/System/Library/Filesystems/AppleShare"] &&
		[_man fileExistsAtPath:@"/System/Library/CoreServices/AppleFileServer.app"] &&
		[_man fileExistsAtPath:@"/System/Library/PrivateFrameworks/ByteRangeLocking.framework"] &&
		[_man fileExistsAtPath:@"/System/Library/PrivateFrameworks/BezelServices.framework"] &&
		[_man fileExistsAtPath:@"/usr/bin/a2p"] &&
		[_man fileExistsAtPath:@"/usr/sbin/named"] &&
		[_man fileExistsAtPath:@"/usr/sbin/named-checkconf"] &&
		[_man fileExistsAtPath:@"/sbin/mount_afp"] &&
		[_man fileExistsAtPath:@"/usr/sbin/appletalk"] &&
		[_man fileExistsAtPath:@"/System/Library/PrivateFrameworks/Calculate.framework"])
		result = YES;
	return result;
}
-(BOOL)getToggleRightText:(NSString *)title
{
	BOOL result = NO;
	if([title isEqualToString:@"toggleRW"])
	{
		result=[self isRW];
	}
	else if([title isEqualToString:@"toggleFTP"])
	{
		result = [self serviceIsRunning:@"ftp"];
	}
	else if([title isEqualToString:@"toggleDropbear"])
	{
		result = [self sshStatus];
	}
	else if([title isEqualToString:@"toggleRowmote"])
	{
		result = [self RowmoteIsRunning];
	}
	else if([title isEqualToString:@"toggleAFP"])
	{
		result = [self AFPIsRunning];
	}
	else if([title isEqualToString:@"toggleVNC"])
	{

		result = [self VNCIsRunning];
	}
	return result;
}
-(BOOL)getToggleDimmed:(NSString *)title //NO means it is Not
{
	BOOL result = NO;
	if([title isEqualToString:@"toggleRW"])
	{
		result=YES;
	}
	else if([title isEqualToString:@"toggleDropbear"])
	{
		result = [self dropbearIsInstalled];
	}
	else if([title isEqualToString:@"toggleRowmote"])
	{
		result = [self RowmoteIsInstalled];
	}
	else if([title isEqualToString:@"toggleAFP"])
	{
		result = [self AFPIsInstalled];
	}
	else if([title isEqualToString:@"toggleFTP"])
	{
		result = [self FTPIsInstalled];
	}
	else if([title isEqualToString:@"toggleVNC"])
	{
		result = [self VNCIsInstalled];
	}
	return result;		
}
-(int)VNCFix
{
	NSLog(@"VNC");
	NSString *script = @"#/bin/sh\necho \"frontrow\" | sudo -S command\nsudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart  -configure -clientopts -setvnclegacy -vnclegacy yes\nsudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart  -activate -configure -access -on -users frontrow -privs -all -restart -agent -menu";
	if([_man fileExistsAtPath:[@"~/configure_kickstart.sh" stringByExpandingTildeInPath]])
	{
		[_man removeFileAtPath:[@"~/configure_kickstart.sh" stringByExpandingTildeInPath] handler:nil];
	}
	[script writeToFile:[@"~/configure_kickstart.sh" stringByExpandingTildeInPath] atomically:YES];
	[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-script",[@"~/configure_kickstart.sh" stringByExpandingTildeInPath],@"0",nil]];
	[_man removeFileAtPath:[@"~/configure_kickstart.sh" stringByExpandingTildeInPath] handler:nil];
	return 0;
}
-(void)wasExhumed
{
	[[self list] reload];
}



@end


@implementation SMDownloaderTweaks

-(void) processdownload
{
	if([[_outputPath pathExtension] isEqualToString:@"dmg"])
	{
		NSArray *arguments =[NSArray arrayWithObjects:@"-install_perian",_outputPath,@"/",nil];
		[SMGeneralMethods runHelperApp:arguments];
	}
	else if([[_outputPath pathExtension] isEqualToString:@"tgz"] || [[_outputPath pathExtension] isEqualToString:@"tar.gz"])
	{
		NSArray *arguments =[NSArray arrayWithObjects:@"-installTGZ",_outputPath,@"/",nil];
		[SMGeneralMethods runHelperApp:arguments];
	}
	[self appendSourceText:@"Please Restart the Finder for changes to take effect"];
	if([SMGeneralMethods boolForKey:@"ARF"])
	{
		AGProcess * FinderProcess = [AGProcess processForCommand:@"Finder"];
		[FinderProcess terminate];
	}
	[[self stack] popController];

}


@end
