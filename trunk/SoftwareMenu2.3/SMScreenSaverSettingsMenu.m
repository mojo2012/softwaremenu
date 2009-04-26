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

					@"FloatingRotationDelay",
					@"FloatingDefaults",
					nil];
	settingDisplays = [[NSMutableArray alloc] initWithObjects:
					   BRLocalizedString(@"Slide Show Type",@"Slide Show Type"),
					   BRLocalizedString(@"Set Apple Images",@"Set Apple Images"),

					   BRLocalizedString(@"Rotation Delay",@"Rotation Delay"),
					   BRLocalizedString(@"Defaults",@"Defaults"),
					   nil];
	settingDescriptions = [[NSMutableArray alloc] initWithObjects:
						   @"Switches the SlideShow between different types:      SlideShow / Floating Images",
						   @"Set Image folder to flowery apple images",

						   @"Time Between different rotations",
						   @"Set Floating Menu Back to Defaults",
						   nil];
	settingNumberType = [[NSMutableArray alloc] initWithObjects:
						 [NSNumber numberWithInt:0],
						 [NSNumber numberWithInt:3],
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
	[[self list] addDividerAtIndex:2 withLabel:@"Floating"];
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
																	   withBoxes:4
																		 withKey:PHOTO_SPIN_FREQUENCY];
			[[self stack] pushController:newController];
			i = [SMGeneralMethods integerForKey:PHOTO_SPIN_FREQUENCY];
			/*if(i==nil || i == 0)
				i=DEFAULT_SPIN_FREQUENCY;
			BRPasscodeEntryControl *pass = [[BRPasscodeEntryControl alloc] initWithNumDigits:4 userEditable:YES hideDigits:NO];
			[pass setDelegate:self];
			BRTextEntryController *textinput = [[BRTextEntryController alloc] 
												initWithTextEntryStyle:3];
			[textinput setTitle:@"Set Delay (in seconds)"];
			[textinput setInitialTextEntryText:[NSString stringWithFormat:@"%@",[NSNumber numberWithInt:i],nil]];
			[textinput setTextEntryCompleteDelegate:self];
			[[self stack] pushController:textinput];*/
			break;
		case kSMSSSFDefaults:
			randomV = NO;
			[SMGeneralMethods setInteger:60 forKey:PHOTO_SPIN_FREQUENCY];
			break;
				
			
	}
	[[self list] addDividerAtIndex:1 withLabel:@"Floating Menu"];
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
			[item setRightJustifiedText:[NSString stringWithFormat:@"(%@ seconds)",[NSNumber numberWithInt:[SMGeneralMethods integerForKey:PHOTO_SPIN_FREQUENCY]],nil]];
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
/*- (BOOL)brEventAction:(BREvent *)event
{
	long selitem;
	unsigned int hashVal = (uint32_t)((int)[event page] << 16 | (int)[event usage]);
	if ([(BRControllerStack *)[self stack] peekController] != self)
		hashVal = 0;
	
	//int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	
	//NSLog(@"hashval =%i",hashVal);
	switch (hashVal)
	{
		case 65676:  // tap up
			//NSLog(@"type up");
			break;
		case 65677:  // tap down
			//NSLog(@"type down");
			break;
		case 65675:  // tap left
			//NSLog(@"type left");
			selitem = 0;
			
			selitem = [self getSelection];
			//NSLog(@"selection :%d",selitem);
			if(![self usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
			{
				[lastFilterChangeDate release];
				lastFilterChangeDate = [[NSDate date] retain];
				NSMutableArray *favorites = [[NSMutableArray alloc] initWithObjects:nil];
				[favorites addObjectsFromArray:[SMGeneralMethods arrayForKey:@"PhotosFavorites"]];
				if([favorites containsObject:[paths objectAtIndex:selitem]])
				{
					[favorites removeObjectAtIndex:[favorites indexOfObject:[paths objectAtIndex:selitem]]];
					[SMGeneralMethods setArray:favorites forKey:@"PhotosFavorites"];
					[_items removeObjectAtIndex:[paths indexOfObject:[paths objectAtIndex:selitem]]];
					[paths removeObjectAtIndex:[paths indexOfObject:[paths objectAtIndex:selitem]]];
					[[self list] removeDividers];
					if([[_dividers valueForKey:@"Favorites"]intValue] != [[_dividers valueForKey:@"Current"]intValue])
						[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Current"]intValue] withLabel:@"Current"];
					int i = [[_dividers valueForKey:@"Volumes"] intValue];
					i--;
					[_dividers setObject:[NSNumber numberWithInt:i] forKey:@"Volumes"];
					
					i= [[_dividers valueForKey:@"Folders"] intValue];
					i--;
					[_dividers setObject:[NSNumber numberWithInt:i] forKey:@"Folders"];
					if([[_dividers valueForKey:@"Volumes"]intValue] != [[_dividers valueForKey:@"Favorites"]intValue])
						[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Favorites"]intValue] withLabel:@"Favorites"];
					if([[_dividers valueForKey:@"Folders"]intValue] != [[_dividers valueForKey:@"Volumes"]intValue])
						[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Volumes"]intValue] withLabel:@"Volumes"];
					[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Folders"]intValue] withLabel:@"Folders"];
					
					//[[self list] addDividerAtIndex:8 withLabel:BRLocalizedString(@"Installs",@"Installs")];
					//[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Restart Finder",@"Restart Finder")];
					[[self list] reload];
					
					
					
					
				}
			}
			
			
			break;
		case 65674:  // tap right
			//NSLog(@"type right");
			//[self setSelectedItem:1];
			selitem = 0;
			
			selitem = [self getSelection];
			if(selitem>=[settingNames count])
			{
				if(![self usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
				{
					[lastFilterChangeDate release];
					lastFilterChangeDate = [[NSDate date] retain];
					NSLog(@"Row: %@",[NSNumber numberWithInt:selitem]);
					[SMGeneralMethods setString:[paths objectAtIndex:selitem] forKey:@"PhotoDirectory"];
					[self initCustom];
					[[self list] reload];
				}
			}
			
			break;
		case 65673:  // tap play
			/*selitem = [self selectedItem];
			 [[_items objectAtIndex:selitem] setWaitSpinnerActive:YES];
			//NSLog(@"type play");
			break;
	}
	return [super brEventAction:event];
}*/





@end



