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
		[meta setDescription:[settingDescriptions objectAtIndex:item]];		
		BRMetadataPreviewControl *previewtoo =[[BRMetadataPreviewControl alloc] init];
		[previewtoo setShowsMetadataImmediately:YES];
		[previewtoo setDeletterboxAssetArtwork:YES];
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
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: @"Settings"];
	settingNames = [[NSMutableArray alloc] initWithObjects:@"Perian",
					@"RemoveSapphireMetaData",
					@"toggleRW",
					@"toggleDropbear",
					@"toggleRowmote",
					@"toggleAFP",
					@"toggleVNC",
					@"installDropbear",
					@"installRowmote",
					nil];
	settingDisplays = [[NSMutableArray alloc] initWithObjects:@"Install Perian",
					   @"Fix Sapphire",
					   @"Disk Read/Write toggle",
					   @"Dropbear SSH toggle",
					   @"Rowmote toggle",
					   @"AFP toggle",
					   @"VNC toggle",
					   @"install Dropbear SSH",
					   @"install Rowmote",
					   nil];
	settingDescriptions = [[NSMutableArray alloc] initWithObjects:@"Will download and Install Perian",
						   @"Deletes the Sapphire Metadata, which can cause a problem after upgrade",
						   @"Changes the disk status from Read-Write to Read-Only",
						   @"Activates Rowmote (Requires Restarting the Finder)",
						   @"Toggle AFP server",
						   @"Toggle VNC server",
						   @"Install Dropbear (will Fix SSH in case you somehow broke it)",
						   @"Install Rowmote (www.rowmote.com - needs the iphone/ipod program rowmote)",
						   nil];
	settingType = [[NSMutableArray alloc] initWithObjects:@"Download",
				   @"Fix",
				   @"toggle",
				   @"toggle",
				   @"toggle",
				   @"toggle",
				   @"toggle",
				   @"install",
				   @"install",
				   nil];
	return self;
}
-(id)initCustom
{

	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];

	
	int i,counter;
	i=[settingNames count];
	for(counter=0;counter<i;counter++)
	{
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc] init];
		[item setTitle:[settingDisplays objectAtIndex:counter]];
		[_options addObject:[NSArray arrayWithObjects:[settingType objectAtIndex:counter],[settingNames objectAtIndex:counter],[settingDisplays objectAtIndex:counter],nil]];
		[_items addObject:item];
		
		
	}
	id list = [self list];
	[list setDatasource: self];
	return self;
}
-(void)itemSelected:(long)fp8
{
	
}
/*- (id)titleForRow:(long)row			{ return [settingDisplays objectAtIndex:row];}
- (long)rowForTitle:(id)title			{ return (long)[settingDisplays indexOfObject:title];}
- (float)heightForRow:(long)row		{ return 0.0f; }
- (BOOL)rowSelectable:(long)row		{ return YES;}
- (long)itemCount					{ return (long)[settingDisplays count];}
- (id)itemForRow:(long)row
{
	return [_items objectAtIndex:row];
}*/
- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					
{ 
	NSString *title = [settingDisplays objectAtIndex:row];
	BOOL setDimmed=NO;

	BRTextMenuItemLayer *item = [BRTextMenuItemLayer menuItem];
	if([[settingType objectAtIndex:row] isEqualToString:@"toggle"])
	{
		[item setRightJustifiedText:[self getToggleRightText:row]];
	}
	
	if([[settingNames objectAtIndex:row] isEqualToString:@"toggleDropbear"])
	{
		if([self dropbearIsRunning]){[item setRightJustifiedText:@"YES"];}
		else{[item setRightJustifiedText:@"NO"];}
		
		if(![self dropbearIsInstalled]){[item setDimmed:NO];}
	}
	
	else if([[settingNames objectAtIndex:row] isEqualToString:@"installDropbear"])
	{
		if(![self dropbearIsInstalled]){[item setDimmed:YES];}
	}
	
	else if([[settingNames objectAtIndex:row] isEqualToString:@"toggleVNC"])
	{
		if([self VNCIsRunning]){[item setRightJustifiedText:@"YES"];}
		else{[item setRightJustifiedText:@"NO"];}
		if(![self VNCIsInstalled]){[item setDimmed:YES];}
	}
	else if([[settingNames objectAtIndex:row] isEqualToString:@"toggleRowmote"])
	{
		if(![self RowmoteIsInstalled])
		{
			[item setRightJustifiedText:@"ON"];
		}
	}
		
		
	else if([[settingNames objectAtIndex:row] isEqualToString:@"toggleAFP"])
	{
		if(![self AFPIsRunning])
		{
			[item setRightJustifiedText:@"NO"];
		}
	}
			
	
	NSLog(@"settingDisplays: %@",settingDisplays);
	[item setTitle:[settingDisplays objectAtIndex:row]];
	return item;
	
//return [_items objectAtIndex:row]; 
}
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }

-(BOOL)dropbearIsInstalled
{
	return ( [[NSFileManager defaultManager] fileExistsAtPath: @"/usr/sbin/dropbear"] );
}
-(BOOL)RowmoteIsInstalled
{
	return ([[NSFileManager defaultManager] fileExistsAtPath: @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/RowmoteHelperATVHook.frappliance"]);
}
-(BOOL)VNCIsInstalled
{
	BOOL result = YES;
	if (![[NSFileManager defaultManager] fileExistsAtPath: @"/System/Library/CoreServices/RemoteManagement"] || 
		![[NSFileManager defaultManager] fileExistsAtPath: @"/System/Library/Perl/"] ||
		![[NSFileManager defaultManager] fileExistsAtPath: @"/System/Library/Perl/5.8.6/"])
	{
		result=NO;
	}
	
	return result;
}
-(BOOL)dropbearIsRunning
{
	BOOL result = NO;
	
    if ( [self dropbearIsInstalled] == NO )
        return ( NO );
	
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile: @"/System/Library/LaunchDaemons/com.atvMod.dropbear.plist"];
    if ( dict != nil )
    {
        result = YES;
        NSNumber * num = (NSNumber *) [dict objectForKey: @"Disabled"];
        if ( num != nil )
            result = (![num boolValue]);
    }
	
    return ( result );
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
/*-(BOOL)VNCIsRunning
{
	BOOL result =NO;
	NSWorkspace *workspace ;
	NSArray *apps = [workspace valueForKeyPath:@"launchedApplications.NSApplicationName"];
	NSArray *pids = [workspace valueForKeyPath:@"launchedApplications.NSApplicationProcessIdentifier"];
	// if (DEBUG_MODE) NSLog([NSString stringWithFormat:@"apps = %@",apps]);
	// if (DEBUG_MODE) NSLog([NSString stringWithFormat:@"pids = %@",pids]);
	
	int i;
	for (i=0; i<[apps count]; i++)
	{
		if ([@"AppleVNCServer" isEqualToString:[apps objectAtIndex:i]])
		{
			//thePID = [[pids objectAtIndex:i] intValue];
			result=YES;
		}
	}
	return result;
}*/
-(BOOL)VNCIsRunning
{
	return NO;
}




@end
