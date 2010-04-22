//
//  SMTweaks.m
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//#import "SMScreenSaverMenu.h"
//#import "SMScreenSaverSettingsMenu.h"

#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>
#import <objc/objc-class.h>
#import "SMPhotosSettingsMenu.h"
#define SCREEN_SAVER_PATH @"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"


@implementation SMPhotosSettingsMenuNew
- (id) previewControlForItem: (long) item
{
    // If subclassing BRMediaMenuController, this function is called when the selection cursor
    // passes over an item.
	if(item >= [_items count])
		return nil;
//	else if([[_dividers valueForKey:@"Favorites"]intValue] != [[_dividers valueForKey:@"Current"]intValue] && item == [settingNames count])
//	{
//		SMFBaseAsset	*meta = [[SMFBaseAsset alloc] init];
//		[meta setTitle:(NSString *)[[_items objectAtIndex:item] title]];
//		[meta setCoverArt:[SMPhotoPreview firstPhotoForPath:[SMPreferences stringForKey:@"PhotoDirectory"]]];
//		SMFMediaPreview *preview =[[SMFMediaPreview alloc] init];
//		[preview setAssetMeta:meta];
//		return preview;
//	}
    if(item >= [settingNames count])
	{
		SMFBaseAsset	*meta = [[SMFBaseAsset alloc] init];
		[meta setTitle:(NSString *)[[_items objectAtIndex:item] title]];
		[meta setCoverArt:[SMPhotoPreview firstPhotoForPath:[_options objectAtIndex:item]]];
		SMFMediaPreview *preview =[[SMFMediaPreview alloc] init];
		[preview setAsset:meta];
		return preview ;
		
	}
	else
	{
		SMFBaseAsset *meta = [[SMFBaseAsset alloc] init];
		[meta setSummary:[settingDescriptions objectAtIndex:item]];
		[meta setTitle:[settingDisplays objectAtIndex:item]];
        [meta setCoverArt:[[BRThemeInfo sharedTheme]photosImage]];
		SMFMediaPreview *preview =[[SMFMediaPreview alloc] init];
		[preview setShowsMetadataImmediately:YES];
		//[previewtoo setDeletterboxAssetArtwork:YES];
		[preview setAsset:meta];
		
		return preview;
	}
    return [super previewControlForItem:item];
}
- (void)dealloc
{
	//[_options release];
	//[_items release];
	
	[settingNames release];
	[settingDisplays release];
	[settingType release];
	[settingDescriptions release];
	[settingNumberType release];
	//[_dividers release];
	//[_options release];
	//NSWorkspace *workspace;
	//[_man release];
	//[_items release];
	//[_options release];
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
//					@"ScreensaverType",
//                    @"FloatingRotationDelay",
//					@"FloatingDefaults",
					@"defaultimages",
//					@"screensaverTimeOut",
					@"timePerSlide",
                    SLIDESHOW_TRANSITION,
                    SLIDESHOW_PAN_AND_ZOOM,
                    SLIDESHOW_REPEAT,
                    SLIDESHOW_PHOTOS_SHUFFLE,
                    SLIDESHOW_MUSIC_SHUFFLE,
                    SLIDESHOW_MUSIC_PLAY,
                    SLIDESHOW_PLAYLIST,


					nil];
    
    settingNumberType = [[NSMutableArray alloc] initWithObjects:
//						 [NSNumber numberWithInt:kSMSSSType],
//                         [NSNumber numberWithInt:kSMSSSRotation],
//						 [NSNumber numberWithInt:kSMSSSFDefaults], 
						 [NSNumber numberWithInt:kSMSSSDefaultImages],
//						 [NSNumber numberWithInt:kSMSSSTimeOut],
						 [NSNumber numberWithInt:kSMSSSSlideTime],
                         [NSNumber numberWithInt:kSMSSSTransition],
                         [NSNumber numberWithInt:kSMSSSPAZ],
                         [NSNumber numberWithInt:kSMSSSRepeat],
                         [NSNumber numberWithInt:kSMSSSShufflePhotos],
                         [NSNumber numberWithInt:kSMSSSShuffleMusic],
                         [NSNumber numberWithInt:kSMSSSPlayMusic],
                         [NSNumber numberWithInt:kSMSSSPlaylist],

                        
						 nil];
    
	settingDisplays = [[NSMutableArray alloc] initWithObjects:
//					   BRLocalizedString(@"Slide Show Type",@"Slide Show Type"),
//                       BRLocalizedString(@"Rotation Delay",@"Rotation Delay"),
//					   BRLocalizedString(@"Defaults",@"Defaults"),

					   BRLocalizedString(@"Set Apple Images",@"Set Apple Images"),
//                       					   BRLocalizedString(@"ScreenSaver Timeout",@"ScreenSaver Timeout"),
					   BRLocalizedString(@"Time Per Slide",@"Time Per Slide"),
                       BRLocalizedString(@"Transition Effect",@"Transition Effect"),
                       BRLocalizedString(@"Ken Burns Effect",@"Ken Burns Effect"),
                       BRLocalizedString(@"Repeat SlideShow",@"Repeat SlideShow"),
                       BRLocalizedString(@"Shuffle Photos",@"Shuffle Photos"),
                       BRLocalizedString(@"Shuffle Music",@"Shuffle Music"),
                       BRLocalizedString(@"Play Music",@"Play Music"),
                       BRLocalizedString(@"Slideshow Playlist",@"Slideshow Playlist"),


                       
					   nil];
	settingDescriptions = [[NSMutableArray alloc] initWithObjects:
//						   @"Switches the SlideShow between different types:      SlideShow / Floating Images / Parade",
//                           @"Time Between different rotations",
//						   @"Set Floating Menu Back to Defaults",
						   @"Set Image folder to flowery apple images",
//						   @"Set the screensaver timeout in minutes",
						   @"Set Number of seconds per slide",
                           @"Set SlideShow Transition Effect",
                           @"Set SlideShow Ken Burns Effect",
                           @"Sets if slideshow repeats",
                           @"Sets if photos are shuffled",
                           @"Set SlideShow Shuffle Music",
                           @"Play music during slideshows",
                           @"Set SlideShow Playlist",


                           
						   nil];
	
	
//	_items = [[NSMutableArray alloc] initWithObjects:nil];
//	_options = [[NSMutableArray alloc] initWithObjects:nil];
	[self setListIcon:[[BRThemeInfo sharedTheme] photoSettingsImage] horizontalOffset:0.5f kerningFactor:0.2f];
    [self initCustom];
	return self;
}
-(id)initCustom
{
	[_items removeAllObjects];
	[_options removeAllObjects];
	
	
	int i,counter;
	i=[settingNames count];
    //NSLog(@"%i, %i, %i ,%i",[settingNames count],[settingDisplays count], [settingDescriptions count],[settingNumberType count]);
	for(counter=0;counter<i;counter++)
	{
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc]init];
		[item setTitle:[settingDisplays objectAtIndex:counter]];
		[_items addObject:item];
		[_options addObject:@"nil"];
		
	}
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:0 withLabel:@"General"];
	[[self list] addDividerAtIndex:4 withLabel:@"Slideshow Photos"];
    [[self list] addDividerAtIndex:9 withLabel:@"Slideshow Music"];
	[[self list] addDividerAtIndex:12 withLabel:@"Floating"];
	return self;
}
-(void)itemSelected:(long)row
{
	BOOL randomV =NO;
    //NSLog(@"itemSelected");
	//NSString *usedString = nil;
	switch([[settingNumberType objectAtIndex:row] intValue])
	{
            
		case kSMSSSDefaultImages:
			[SMPreferences setString:DEFAULT_IMAGES_PATH forKey:PHOTO_DIRECTORY_KEY];
			break;
		case kSMSSSType:
        {
            NSString *a = [SMPreferences slideshowType];
            //NSLog(@"aa: %@",a);
            if([a isEqualToString:@"Floating"])
			{
				[SMPreferences setString:@"Parade" forKey:@"ScreensaverType"];
			}
			else if([a isEqualToString:@"Parade"])
            {
                [SMPreferences setString:@"Slideshow" forKey:@"ScreensaverType"];
            }
            else 
            {
                [SMPreferences setString:@"Floating" forKey:@"ScreensaverType"];
            }

            break;
        }
			
		case kSMSSSRotation:
        {
            int i = nil;
            
			id newController = [[SMFPasscodeController alloc] initWithTitle:BRLocalizedString(@"Set Delay",@"Spin Delay") 
                                                            withDescription:BRLocalizedString(@"Please enter delay time between each spin (in secs)", @"Please enter delay time between each spin (in secs)")
                                                                  withBoxes:3
                                                               withDelegate:self];
			//[newController setBRImage:[[BRThemeInfo sharedTheme] photosImage]];
			//[newController setInitialValue:[SMPreferences screensaverSpinFrequency]];
            
			[[self stack] pushController:newController];
			i = [SMPreferences integerForKey:PHOTO_SPIN_FREQUENCY];
			break;
        }
			
		case kSMSSSSlideTime:
        {

            id a =[[SMFPasscodeController alloc]initWithTitle:BRLocalizedString(@"Set Time Per Slide",@"Set Time Per Slide") 
                                              withDescription:BRLocalizedString(@"Please enter a time in seconds",@"Please enter a time in seconds") 
                                                    withBoxes:5 
                                                      withKey:nil 
                                                   withDomain:nil];
            [a setDelegate:self];
            _returnType=kSMSSSSlideTime;
            [[self stack] pushController:a];
            [a release];
			break;  
        }
			

		case kSMSSSTimeOut:
			randomV = NO;
			id controllera = [[SMFPasscodeController alloc] initWithTitle:BRLocalizedString(@"Set Screensaver Time Out",@"Set Screensaver Time Out")
															  withDescription:BRLocalizedString(@"Please enter a time in minutes (zero means never)",@"Please enter a time in minutes (zero means never)")
																	withBoxes:3
																	  withDelegate:self];
			[controllera setBRImage:[[BRThemeInfo sharedTheme] photosImage]];
			[controllera setValue:[NSNumber numberWithInt:2] forKey:@"options"];
			if([[BRSettingsFacade singleton] screenSaverTimeout]<0)
				[controllera setInitialValue:0];
			else
				[controllera setInitialValue:[[BRSettingsFacade singleton] screenSaverTimeout]];
			[[self stack] pushController:controllera];
            break;
		case kSMSSSFDefaults:
			randomV = NO;
			[SMPreferences setInteger:60 forKey:PHOTO_SPIN_FREQUENCY];
			break;
        case kSMSSSTransition:
            randomV = NO;
            SMPhotosTransitionPreferences *TranMenu = [SMPhotosTransitionPreferences slideshowTransitionPreferences];
            //[menu initCustom];
            [[self stack] pushController:TranMenu];
            break;
        case kSMSSSPlaylist:
            randomV = NO;
            SMPlaylistSelection *a = [[SMPlaylistSelection alloc] init];
            //SMSlideShowPlaylistPreferences *PlayMenu = [[SMSlideShowPlaylistPreferences alloc] init];
            //[menu initCustom];
            [[self stack] pushController:a];
            break;
        case kSMSSSPAZ:
            randomV=NO;
            if([[BRSettingsFacade singleton] slideshowPanAndZoom])
            {
                [[BRSettingsFacade singleton] setSlideshowPanAndZoom:NO];
            }
            else {
                [[BRSettingsFacade singleton] setSlideshowPanAndZoom:YES];
            }
            break;
        case kSMSSSPlayMusic:
            randomV=NO;
            if([SMPreferences playsMusicInSlideShow])
            {
                [SMPreferences setPlaysMusicInSlideShow:NO];
            }
            else {
                [SMPreferences setPlaysMusicInSlideShow:YES];
            }
            break;
            
            
        case kSMSSSShuffleMusic:
            randomV=NO;
            if([[BRSettingsFacade singleton] slideshowShuffleMusic])
            {
                [[BRSettingsFacade singleton] setSlideshowShuffleMusic:NO];
            }
            else {
                [[BRSettingsFacade singleton] setSlideshowShuffleMusic:YES];
            }
            break;
        case kSMSSSRepeat:
            randomV=NO;
            if([[BRSettingsFacade singleton] slideshowRepeat])
            {
                [[BRSettingsFacade singleton] setSlideshowRepeat:NO];
            }
            else {
                [[BRSettingsFacade singleton] setSlideshowRepeat:YES];
            }
            break;
        case kSMSSSShufflePhotos:
            randomV=NO;
            if([[BRSettingsFacade singleton] slideshowShufflePhotos])
            {
                [[BRSettingsFacade singleton] setSlideshowShufflePhotos:NO];
            }
            else {
                [[BRSettingsFacade singleton] setSlideshowShufflePhotos:YES];
            }
            break;
            
			
	}
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
    BOOL j;
	switch ([[settingNumberType objectAtIndex:row] intValue])
	{
		case kSMSSSDefaultImages:
			usedString = [SMPreferences stringForKey:PHOTO_DIRECTORY_KEY];
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

				[item setRightJustifiedText:[SMPreferences slideshowType]];
			
			break;
		case kSMSSSTimeOut:
			usedString = [NSString  stringWithFormat:@"(%i minutes)",[[BRSettingsFacade singleton] screenSaverTimeout],nil];
			if([[BRSettingsFacade singleton] screenSaverTimeout]<0)
				[item setRightJustifiedText:@"(Never)"];
			else
				[item setRightJustifiedText:usedString];
			break;
		case kSMSSSRotation:
//			i = [SMPreferences integerForKey:PHOTO_SPIN_FREQUENCY];
//			if(i==nil || i == 0)
//				i=60;
//			[item setRightJustifiedText:[NSString stringWithFormat:@"(%@ seconds)",[NSNumber numberWithInt:i],nil]];
			break;
		case kSMSSSSlideTime:
	//		i = [[BRSettingsFacade singleton] slideshowSecondsPerSlide];
            
			[item setRightJustifiedText:[NSString stringWithFormat:@"(%i seconds)",[[BRSettingsFacade singleton] slideshowSecondsPerSlide],nil]];
			break;
        case kSMSSSShuffleMusic:
            i=0;
            j = [[BRSettingsFacade singleton] slideshowShuffleMusic];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
        case kSMSSSPlayMusic:
            i=0;
            j=[SMPreferences playsMusicInSlideShow];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
        case kSMSSSPAZ:
            i=0;
            j=[[BRSettingsFacade singleton] slideshowPanAndZoom];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
        case kSMSSSShufflePhotos:
            i=0;
            j=[[BRSettingsFacade singleton] slideshowShufflePhotos];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
        case kSMSSSRepeat:
            i=0;
            j=[[BRSettingsFacade singleton] slideshowRepeat];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
            
        case kSMSSSTransition:
            i=0;
            [item setRightJustifiedText:[NSString stringWithFormat:@"(%@)",[[BRSettingsFacade singleton] slideshowSelectedTransitionName]]];
            break;
        case kSMSSSPlaylist:
            [item setRightJustifiedText:[NSString stringWithFormat:@"(%@)",[[BRSettingsFacade singleton] slideshowSelectedPlaylistName]]];
            break;
            
            
			
	}
	return item;
	
	//return [_items objectAtIndex:row]; 
}
//-(id)itemForRow:(long)row
//{
//    return [_items objectAtIndex:row];
//}
-(void)wasExhumed
{
	[self initCustom];
	[[self list] reload];
}

-(void)textDidChange:(NSNotification *)notification
{
}
-(void)textDidEndEditing:(id)sender
{
    [[self stack] popController];
    switch (_returnType) {
        case kSMSSSSlideTime:
        {
            int value=[[sender stringValue] intValue];
            //[SMPreferences setInteger:value forKey:PHOTO_SPIN_FREQUENCY];
            [[BRSettingsFacade singleton] setSlideshowSecondsPerSlide:value];
            break; 
        }
        default:
            break;
    }
    [[self list]reload];
}


@end
@implementation SMPlaylistSelection

-(void)controlWasActivated
{
    [self setListTitle:@"Select Playlist"];
    [self setListIcon:[[BRThemeInfo sharedTheme] iTunesNotes] horizontalOffset:0.5f kerningFactor:0.2f];
    [super controlWasActivated];
}

@end


