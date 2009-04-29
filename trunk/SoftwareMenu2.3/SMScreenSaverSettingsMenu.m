//
//  SMTweaks.m
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "SMScreenSaverMenu.h"
#import "SMScreenSaverSettingsMenu.h"
#import "SMGeneralMethods.h"
#import "SMMedia.h"
#import "SMDefaultPhotos.h"
#import "AGProcess.h"
#import "SMMediaPreview.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>
#import <objc/objc-class.h>
#import "SMFolderBrowser.h"
#import "SMPhotoPreview.h"
#import "SoftwarePasscodeController.h"
#define SCREEN_SAVER_PATH @"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"


@implementation SMScreenSaverSettingsMenu
- (id) previewControlForItem: (long) item
{
    // If subclassing BRMediaMenuController, this function is called when the selection cursor
    // passes over an item.
	if(item >= [_items count])
		return nil;
	else if([[_dividers valueForKey:@"Favorites"]intValue] != [[_dividers valueForKey:@"Current"]intValue] && item == [settingNames count])
	{
		SMMedia	*meta = [[SMMedia alloc] init];
		[meta setTitle:(NSString *)[[_items objectAtIndex:item] title]];
		[meta setBRImage:[SMPhotoPreview firstPhotoForPath:[SMGeneralMethods stringForKey:@"PhotoDirectory"]]];
		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
		[preview setAsset:meta];
		return [preview autorelease];
	}
	else if(item >= [settingNames count])
	{
		SMMedia	*meta = [[SMMedia alloc] init];
		[meta setTitle:(NSString *)[[_items objectAtIndex:item] title]];
		[meta setBRImage:[SMPhotoPreview firstPhotoForPath:[paths objectAtIndex:item]]];
		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
		[preview setAsset:meta];
		return [preview autorelease];
		
	}
	else
	{
		SMMedia *meta = [[SMMedia alloc] init];
		[meta setDescription:[settingDescriptions objectAtIndex:item]];
		[meta setTitle:[settingDisplays objectAtIndex:item]];
		switch([[settingNumberType objectAtIndex:item] intValue])
		{
			case kSMSSSDefaultImages:
			case kSMSSSFDefaults:
			case kSMSSSRotation:
			case kSMSSSType:
			case kSMSSSSlideTime:
				[meta setBRImage:[[BRThemeInfo sharedTheme] photosImage]];
				//[meta setDefaultImage];
				break;
		};
		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
		[preview setShowsMetadataImmediately:YES];
		//[previewtoo setDeletterboxAssetArtwork:YES];
		[preview setAsset:meta];
		
		return [preview autorelease];
	}
}
- (void)dealloc
{
	[_man release];
	[paths release];
	[_items release];
	
	[settingNames release];
	[settingDisplays release];
	[settingType release];
	[settingDescriptions release];
	[settingNumberType release];
	[_dividers release];
	[paths release];
	//NSWorkspace *workspace;
	[_man release];
	[_items release];
	[_options release];
	[super dealloc];  
}
-(id)init
{
	//NSLog(@"collectionID: %@",[[ATVDefaultPhotos applePhotosCollection] collectionID]);
	self=[super init];
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	[SMGeneralMethods checkFolders];
	[[self list] removeDividers];
	
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Custom Options",@"Custom Options")];
	settingNames = [[NSMutableArray alloc] initWithObjects:
					@"SlideShowType",
					@"defaultimages",
					@"timePerSlide",
					@"FloatingRotationDelay",
					@"FloatingDefaults",
					nil];
	settingDisplays = [[NSMutableArray alloc] initWithObjects:
					   BRLocalizedString(@"Slide Show Type",@"Slide Show Type"),
					   BRLocalizedString(@"Set Apple Images",@"Set Apple Images"),
					   BRLocalizedString(@"Time Per Slide",@"Time Per Slide"),
					   BRLocalizedString(@"Rotation Delay",@"Rotation Delay"),
					   BRLocalizedString(@"Defaults",@"Defaults"),
					   nil];
	settingDescriptions = [[NSMutableArray alloc] initWithObjects:
						   @"Switches the SlideShow between different types:      SlideShow / Floating Images",
						   @"Set Image folder to flowery apple images",
						   @"Set Number of seconds per slide",
						   @"Time Between different rotations",
						   @"Set Floating Menu Back to Defaults",
						   nil];
	settingNumberType = [[NSMutableArray alloc] initWithObjects:
						 [NSNumber numberWithInt:0],
						 [NSNumber numberWithInt:3],
						 [NSNumber numberWithInt:4],
						 [NSNumber numberWithInt:1],
						 [NSNumber numberWithInt:2],
						 nil];
	
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_dividers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
	_man = [NSFileManager defaultManager];
	paths = [[NSMutableArray alloc] initWithObjects:nil];
	[self setListIcon:[[BRThemeInfo sharedTheme] photoSettingsImage] horizontalOffset:0.5f kerningFactor:0.2f];
	return self;
}
-(id)initCustom
{
	[_items removeAllObjects];
	[paths removeAllObjects];
	
	
	int i,counter;
	i=[settingNames count];
	for(counter=0;counter<i;counter++)
	{
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc]init];
		[item setTitle:[settingDisplays objectAtIndex:counter]];
		[_items addObject:item];
		[paths addObject:@"nil"];
		
	}
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:1 withLabel:@"General"];
	[[self list] addDividerAtIndex:2 withLabel:@"Slideshow"];
	[[self list] addDividerAtIndex:3 withLabel:@"Floating"];
	return self;
}
-(void)itemSelected:(long)row
{
	BOOL randomV =NO;
	//NSString *usedString = nil;
	switch([[settingNumberType objectAtIndex:row] intValue])
	{
		case kSMSSSDefaultImages:
			[SMGeneralMethods setString:DEFAULT_IMAGES_PATH forKey:PHOTO_DIRECTORY_KEY];
			break;
		case kSMSSSType:
			if([[SMGeneralMethods stringForKey:@"SlideShowType"] isEqualToString:@"Floating Images"])
			{
				[SMGeneralMethods setString:@"Slideshow" forKey:@"SlideShowType"];
			}
			else
			{
				[SMGeneralMethods setString:@"Floating Images" forKey:@"SlideShowType"];
			}
			break;
		case kSMSSSRotation:
			randomV = NO;
			int i = nil;
			id newController = [[SoftwarePasscodeController alloc] initWithTitle:BRLocalizedString(@"Set Delay",@"Spin Delay") 
																 withDescription:BRLocalizedString(@"Please enter delay time between each spin (in secs)", @"Please enter delay time between each spin (in secs)")
																	   withBoxes:3
																		 withKey:PHOTO_SPIN_FREQUENCY];
			[newController setBRImage:[[BRThemeInfo sharedTheme] photosImage]];
			[newController setInitialValue:[SMGeneralMethods integerForKey:PHOTO_SPIN_FREQUENCY]];
			[[self stack] pushController:newController];
			i = [SMGeneralMethods integerForKey:PHOTO_SPIN_FREQUENCY];
			break;
		case kSMSSSSlideTime:
			randomV = NO;
			id controller = [[SoftwarePasscodeController alloc] initWithTitle:BRLocalizedString(@"Set Time Per Slide",@"Set Time Per Slide")
															  withDescription:BRLocalizedString(@"Please enter a time in seconds",@"Please enter a time in seconds")
																	withBoxes:5
																	  withKey:nil];
			[controller setBRImage:[[BRThemeInfo sharedTheme] photosImage]];
			[controller setValue:[NSNumber numberWithInt:1] forKey:@"options"];
			[controller setInitialValue:[[BRSettingsFacade singleton] slideshowSecondsPerSlide]];
			[[self stack] pushController:controller];
			break;
		case kSMSSSFDefaults:
			randomV = NO;
			[SMGeneralMethods setInteger:60 forKey:PHOTO_SPIN_FREQUENCY];
			break;
				
			
	}
	[[self list] reload];
}
- (void) textDidChange: (id) sender
{
	//Do Nothing Now
}
- (void) textDidEndEditing: (id) sender
{
	[[self stack] popController];
	//int i = [sender intValue];
	//NSLog(@"sender: %@", thetext);
	[SMGeneralMethods setInteger:[[sender stringValue] intValue] forKey:PHOTO_SPIN_FREQUENCY];
	[[self list] reload];
}
- (id)itemForRow:(long)row					
{ 
	//NSLog(@"itemForRow");
	if(row >= [_items count])
		return nil;
	BRTextMenuItemLayer *item  = [_items objectAtIndex:row];
	NSString *usedString = nil;
	int i;
	switch ([[settingNumberType objectAtIndex:row] intValue])
	{
		case kSMSSSDefaultImages:
			usedString = [SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY];
			if([usedString isEqualToString:DEFAULT_IMAGES_PATH])
			{
				[item setRightJustifiedText:@"Default"];
			}
			else
			{
				[item setRightJustifiedText:nil];
			}
			break;
		case kSMSSSType:
			usedString = [SMGeneralMethods stringForKey:@"SlideShowType"];
			if([usedString isEqualToString:@"Floating Images"])
			{
				[item setRightJustifiedText:@"Floating Images"];
			}
			else
			{
				[item setRightJustifiedText:@"Slideshow"];
				[SMGeneralMethods setString:@"Slideshow" forKey:@"SlideShowType"];
			}
			break;
		case kSMSSSRotation:
			i = [SMGeneralMethods integerForKey:PHOTO_SPIN_FREQUENCY];
			if(i==nil || i == 0)
				i=60;
			[item setRightJustifiedText:[NSString stringWithFormat:@"(%@ seconds)",[NSNumber numberWithInt:i],nil]];
			break;
		case kSMSSSSlideTime:
			i = [[BRSettingsFacade singleton] slideshowSecondsPerSlide];
			[item setRightJustifiedText:[NSString stringWithFormat:@"(%@ seconds)",[NSNumber numberWithInt:i],nil]];
			break;
			
	}
	return item;
	
	//return [_items objectAtIndex:row]; 
}
-(void)wasExhumed
{
	[self initCustom];
	[[self list] reload];
}




@end



