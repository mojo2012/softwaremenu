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
	[[SMGeneralMethods sharedInstance] helperFixPerm];
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
						   @"Turn SSH On/Off -- If dropbear is installed, it will using that is what you are using",
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
				   @"Download",
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
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc] init];
		[item setTitle:[settingDisplays objectAtIndex:counter]];
		//[_options addObject:[NSArray arrayWithObjects:[settingType objectAtIndex:counter],[settingNames objectAtIndex:counter],[settingDisplays objectAtIndex:counter],nil]];
		[_items addObject:item];
		
		
	}
	id list = [self list];
	[list setDatasource: self];
	return self;
}
-(void)itemSelected:(long)row
{
	NSMutableArray * args = [[NSMutableArray alloc] initWithObjects:nil];
	NSLog(@"settingType: %@",[settingType objectAtIndex:row]);
	if([[settingType objectAtIndex:row] isEqualToString:@"toggle"])
	{
		//NSLog(@"Toggle");
		[args addObject:@"-toggleTweak"];
		[args addObject:[[settingNames objectAtIndex:row] substringFromIndex:6]];
		if([self getToggleRightText:[settingNames objectAtIndex:row]])
		{
			[args addObject:@"OFF"];
		}
		else
		{
			[args addObject:@"ON"];
		}
		//[args addObject:[[_infoDict valueForKey:[settingNames objectAtIndex:row]] objectAtIndex:1]];
		//[args addObject];
		NSLog(@"Args: %@",args);
	}
	int terminationStatus= [SMGeneralMethods runHelperApp:args];
	[[self list] reload];
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
- (long)itemCount							{ return (long)[settingNames count];}
- (id)itemForRow:(long)row					
{ 
	
	NSString *title = [settingNames objectAtIndex:row];
	//BOOL setDimmed=NO;

	BRTextMenuItemLayer *item = [BRTextMenuItemLayer menuItem];
	if([[settingType objectAtIndex:row] isEqualToString:@"toggle"])
	{
		BOOL result = ![self getToggleDimmed:title];
		[item setDimmed:result];
		
		if(![item dimmed])
		{
			NSString *rightText = @"OFF";
			BOOL isActive = NO;
			if([self getToggleRightText:title])
			{
				rightText=@"YES";
				isActive = YES;
			}
			[item setRightJustifiedText:rightText];
			[_infoDict setObject:[NSArray arrayWithObjects:[NSNumber numberWithBool:result],[NSNumber numberWithBool:isActive],nil] forKey:title];
		}
		else
		{
			[_infoDict setObject:[NSArray arrayWithObjects:[NSNumber numberWithBool:result],nil] forKey:title];
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
	return YES;//( [[NSFileManager defaultManager] fileExistsAtPath: @"/usr/sbin/dropbear"] );
}
-(BOOL)RowmoteIsInstalled
{
	return ([_man fileExistsAtPath: @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/RowmoteHelperATV.frappliance"] || 
			[_man fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/RowmoteHelperATV.frappliance"] || 
			[_man fileExistsAtPath:@"/Users/frontrow/Documents/RowmoteHelper.tgz"] ||
			[_man fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/RowmoteHelper.tgz"]);
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
	return YES;
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
	else if([title isEqualToString:@"toggleDropbear"])
	{
		result = [self sshStatus];
	}
	else if([title isEqualToString:@"toggleRowmote"])
	{
		result = [self RowmoteIsInstalled];
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
	else if([title isEqualToString:@"toggleVNC"])
	{
		result = [self VNCIsInstalled];
	}
	return result;
		
}



@end
