//
//  SMTweaks.m
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMScreenSaverMenu.h"
#import "SMGeneralMethods.h"
#import "SMMedia.h"
#import "SoftwareSettings.h"
#import "AGProcess.h"
#import "SMMediaPreview.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>

@implementation SMScreenSaverMenu
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
		} TweakType;
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
	_SoftwareDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
	//[_rowmoteDict addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://rowmote.com/rowmote-atv-version.plist"]]];
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
					@"StartShow",
					@"SlideshowTimePerSlide",
					@"SlideshowFolder",
					@"SlideshowType",
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
						   
						   @"Deletes the Sapphire Metadata, which can cause a problem after upgrade",
						   @"Changes the disk status from Read-Write to Read-Only",
						   @"Turn SSH On/Off -- If dropbear is installed, it will using that is what you are using",
						   @"Toggle Rowmote ON/OFF",
						   @"Toggle AFP server",
						   @"Toggle VNC server",
						   @"Toggle FTP server",
						   @"Install Dropbear (will Fix SSH in case you somehow broke it)",
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
	return self;
}
-(id)initCustom
{
	
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
	[[self list] addDividerAtIndex:8 withLabel:BRLocalizedString(@"Installs",@"Installs")];
	[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Restart Finder",@"Restart Finder")];
	[[self list] addDividerAtIndex:1 withLabel:@"Toggles"];
	[list setDatasource: self];
	return self;
}
-(void)itemSelected:(long)row
{
	NSMutableArray * args = [[NSMutableArray alloc] initWithObjects:nil];
	NSMutableDictionary *dlDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	NSString *a=nil;
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
				
				
				
		} TweakType;
		
		
	}
	
	[[self list] reload];
}
- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[settingNames count];}
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
				if([self getToggleRightText:title])
				{
					rightText=@"ON";
					isActive = YES;
					
				}
				[item setRightJustifiedText:rightText];
				[_infoDict setObject:[NSArray arrayWithObjects:[NSNumber numberWithBool:result],[NSNumber numberWithBool:isActive],nil] forKey:title];
			}
			else
			{
				[_infoDict setObject:[NSArray arrayWithObjects:[NSNumber numberWithBool:result],nil] forKey:title];
			}
			break;
		case kSMTwDownloadRowmote:
			NSLog(@"kSMTwDownloadRowmote");
			LocalVersion = nil;
			LocalVersion = [self getRowmoteVersion];
			NSLog(@"LocalVersion of Rowmote:%@",LocalVersion);
			if([LocalVersion compare:[_rowmoteDict valueForKey:@"Version"]]==NSOrderedAscending)		
			{
				[item setRightJustifiedText:[_rowmoteDict valueForKey:@"displayVersion"]];
				NSLog(@"Bigger");
			}
			else 		
			{
				[item setDimmed:YES];
				NSLog(@"Other");
			}
			break;
		case kSMTwDownloadPerian:
			LocalVersion = [self getPerianVersion];
			if([LocalVersion compare:[_rowmoteDict valueForKey:@"perianDisplayVersion"]]==NSOrderedAscending)		{[item setRightJustifiedText:[_rowmoteDict valueForKey:@"perianDisplayVersion"]];}
			else		{[item setDimmed:YES];}
			break;
	}
	
	
	
	
	[item setTitle:[settingDisplays objectAtIndex:row]];
	return item;
	
	//return [_items objectAtIndex:row]; 
}
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }
/*- (id)titleForRow:(long)row					
 {
 return [settingDisplays objectAtIndex:row];
 }
 - (long) rowForTitle: (id) title
 {
 long result = -1;
 long i, count = [self itemCount];
 for ( i = 0; i < count; i++ )
 {
 if ( [title isEqualToString: [self titleForRow: i]] )
 {
 result = i;
 break;
 }
 }
 
 return ( result );
 }*/
-(void)wasExhumed
{
	[[self list] reload];
}



@end



