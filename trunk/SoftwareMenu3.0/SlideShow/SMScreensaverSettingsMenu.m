//
//  SMScreensaverSettingsMenu.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/18/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMScreensaverSettingsMenu.h"


@implementation SMScreensaverSettingsMenu
-(id)init
{
    self=[super init];
    [[SMGeneralMethods sharedInstance] helperFixPerm];
    [SMGeneralMethods checkFolders];
    [[self list] removeDividers];
    
    [self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
    [self setListTitle: BRLocalizedString(@"Screensaver Options",@"Screensaver Options")];
    settingNames = [[NSMutableArray alloc] initWithObjects:
					@"ScreensaverType",
                    @"defaultimages",
                    @"screensaverTimeOut",
                    SCREEN_SAVER_USE_APPLE,


                    @"FloatingRotationDelay",
					@"FloatingDefaults",
					@"timePerSlide",
                    SLIDESHOW_TRANSITION,
                    SLIDESHOW_PAN_AND_ZOOM,
//                    SLIDESHOW_REPEAT,
                    SLIDESHOW_PHOTOS_SHUFFLE,
//                    SLIDESHOW_MUSIC_SHUFFLE,
//                    SLIDESHOW_MUSIC_PLAY,
//                    SLIDESHOW_PLAYLIST,
//                    
//                    
					nil];
    settingNumberType = [[NSMutableArray alloc] initWithObjects:
                         [NSNumber numberWithInt:kSMSSSType],
                         [NSNumber numberWithInt:kSMSSSDefaultImages],
                         [NSNumber numberWithInt:kSMSSSTimeOut],
                         [NSNumber numberWithInt:kSMSSSUSEA],
                         [NSNumber numberWithInt:kSMSSSRotation],
                         [NSNumber numberWithInt:kSMSSSFDefaults],
                         [NSNumber numberWithInt:kSMSSSSlideTime],
                         [NSNumber numberWithInt:kSMSSSTransition],
                         [NSNumber numberWithInt:kSMSSSPAZ],
//                         [NSNumber numberWithInt:kSMSSSRepeat],
                         [NSNumber numberWithInt:kSMSSSShufflePhotos],
                         
                         
                         nil];
    
    settingDisplays = [[NSMutableArray alloc] initWithObjects:
                       BRLocalizedString(@"Screensaver Type",@"Screensaver Type"),
                       BRLocalizedString(@"Set Apple Images",@"Set Apple Images"),
                       BRLocalizedString(@"ScreenSaver Timeout",@"ScreenSaver Timeout"),
                       BRLocalizedString(@"Use Screensaver Images",@"Use Screensaver Images"),
                       BRLocalizedString(@"Rotation Delay",@"Rotation Delay"),
                       BRLocalizedString(@"Defaults",@"Defaults"),
                       
                       BRLocalizedString(@"Time Per Slide",@"Time Per Slide"),
                       BRLocalizedString(@"Transition Effect",@"Transition Effect"),
                       BRLocalizedString(@"Ken Burns Effect",@"Ken Burns Effect"),
//                       BRLocalizedString(@"Repeat SlideShow",@"Repeat SlideShow"),
                       BRLocalizedString(@"Shuffle Photos",@"Shuffle Photos"),
//                       
                       
                       
                       nil];
    settingDescriptions = [[NSMutableArray alloc] initWithObjects:
                           @"Switches the Screensaver between different types:      SlideShow / Floating Images / Parade",
                           @"Set Image folder to flowery apple images",
                           @"Set the screensaver timeout in minutes",
                           @"Use Images chosen in screensaver.frap",

                           @"Time Between different rotations",
                           @"Set Floating Menu Back to Defaults",
                           @"Set Number of seconds per slide",
                           @"Set SlideShow Transition Effect",
                           @"Set SlideShow Ken Burns Effect",
//                           @"Sets if slideshow repeats",
                           @"Sets if photos are shuffled",
                           nil];
//    return self;
    [_items release];
    _items = [[NSMutableArray alloc] initWithObjects:nil];
    [_items retain];
	[self setListIcon:[[BRThemeInfo sharedTheme] photoSettingsImage] horizontalOffset:0.5f kerningFactor:0.2f];
//    return self;
//}
//-(id)initCustom
//{

    [_items removeAllObjects];
	
	
	int i,counter;
	i=[settingDescriptions count];
	for(counter=0;counter<i;counter++)
	{
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc]init];
		[item setTitle:[settingDisplays objectAtIndex:counter]];
		[_items addObject:item];
		
	}
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:0 withLabel:@"General"];
	[[self list] addDividerAtIndex:3 withLabel:@"Floating"];
    [[self list] addDividerAtIndex:5 withLabel:@"Slideshow"];
//	[[self list] addDividerAtIndex:12 withLabel:@"Floating"];
    [[self list] reload];
	return self;
}
//-(id)itemForRow:(long)row
//{
//    NSLog(@"row: %i %i",row,[_items count]);
//    return [super itemForRow:row];
//}
- (id)itemForRow:(long)row					
{ 
	//NSLog(@"itemForRow");
	if(row >= [_items count])
		return nil;
	BRTextMenuItemLayer *item  = [_items objectAtIndex:row];
	int i;
    BOOL j;
	switch ([[settingNumberType objectAtIndex:row] intValue])
	{
		case kSMSSSDefaultImages:
        {
            NSString *usedString = [SMPreferences screensaverFolder];
			if([usedString isEqualToString:DEFAULT_IMAGES_PATH])
			{
				[item setRightJustifiedText:@"Default"];
			}
			else
			{
				[item setRightJustifiedText:nil];
			}
			break;
        }

		case kSMSSSType:
            
            [item setRightJustifiedText:[SMPreferences slideshowType]];
			
			break;
		case kSMSSSTimeOut:
        {
            NSString *usedString = [NSString  stringWithFormat:@"(%i minutes)",[[BRSettingsFacade singleton] screenSaverTimeout],nil];
			if([[BRSettingsFacade singleton] screenSaverTimeout]<0)
				[item setRightJustifiedText:@"(Never)"];
			else
				[item setRightJustifiedText:usedString];
			break;
        }

		case kSMSSSRotation:
			i = [SMPreferences screensaverSpinFrequency];
			[item setRightJustifiedText:[NSString stringWithFormat:@"(%@ seconds)",[NSNumber numberWithInt:i],nil]];
			break;
		case kSMSSSSlideTime:
			i = [SMPreferences screensaverSecondsPerSlide];
			[item setRightJustifiedText:[NSString stringWithFormat:@"(%@ seconds)",[NSNumber numberWithInt:i],nil]];
			break;
        case kSMSSSPAZ:
            i=0;
            j=[SMPreferences screensaverPanAndZoom];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
        case kSMSSSShufflePhotos:
            i=0;
            j=[SMPreferences screensaverShufflePhotos];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
        case kSMSSSRepeat:
            i=0;
            j=[SMPreferences screensaverRepeat];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
            
        case kSMSSSTransition:
            i=0;
            [item setRightJustifiedText:[NSString stringWithFormat:@"(%@)",[SMPreferences screensaverSelectedTransitionName]]];
            break;
        case kSMSSSPlaylist:
            [item setRightJustifiedText:[NSString stringWithFormat:@"(%@)",[[BRSettingsFacade singleton] slideshowSelectedPlaylistName]]];
            break;
        case kSMSSSUSEA:
            i=0;
            j=[SMPreferences screensaverUseAppleProvider];
            if (!j){[item setRightJustifiedText:@"(NO)"];}
            else  {[item setRightJustifiedText:@"(YES)"];}
            break;
            
	}
	return item;
	
	//return [_items objectAtIndex:row]; 
}
-(void)itemSelected:(long)row
{
	BOOL randomV =NO;
	//NSString *usedString = nil;
	switch([[settingNumberType objectAtIndex:row] intValue])
	{
            
		case kSMSSSDefaultImages:
			[SMPreferences setScreensaverFolder:DEFAULT_IMAGES_PATH];
			break;
		case kSMSSSType:
        {
            NSString *a = [SMPreferences slideshowType];
            NSLog(@"aa: %@",a);
            if([a isEqualToString:@"Floating"])
			{
				[SMGeneralMethods setString:@"Parade" forKey:@"ScreensaverType"];
			}
			else if([a isEqualToString:@"Parade"])
            {
                [SMGeneralMethods setString:@"Slideshow" forKey:@"ScreensaverType"];
            }
            else 
            {
                [SMGeneralMethods setString:@"Floating" forKey:@"ScreensaverType"];
            }
            
            break;
        }
			
		case kSMSSSRotation:
        {
			id newController = [[SoftwarePasscodeController alloc] initWithTitle:BRLocalizedString(@"Set Delay",@"Spin Delay") 
																 withDescription:BRLocalizedString(@"Please enter delay time between each spin (in secs)", @"Please enter delay time between each spin (in secs)")
																	   withBoxes:3
																		 withKey:SCREEN_SAVER_SPIN_FREQ];
			[newController setBRImage:[[BRThemeInfo sharedTheme] photosImage]];
			[newController setInitialValue:[SMPreferences screensaverSpinFrequency]];
			[[self stack] pushController:newController];
			//i = [SMGeneralMethods integerForKey:SCREEN_SAVER_SPIN_FREQ];
			break;
        }
		case kSMSSSSlideTime: //Time Per Slide
        {
			id controller = [[SoftwarePasscodeController alloc] initWithTitle:BRLocalizedString(@"Set Time Per Slide",@"Set Time Per Slide")
															  withDescription:BRLocalizedString(@"Please enter a time in seconds",@"Please enter a time in seconds")
																	withBoxes:5
																	  withKey:SCREEN_SAVER_SECONDS_PER_S];
			[controller setBRImage:[[BRThemeInfo sharedTheme] photosImage]];
			[controller setValue:[NSNumber numberWithInt:1] forKey:@"options"];
			[controller setInitialValue:[SMPreferences screensaverSecondsPerSlide]];
			[[self stack] pushController:controller];
            break;
        }
		case kSMSSSTimeOut: //Screensaver Time Out
        {
			id controller = [[SoftwarePasscodeController alloc] initWithTitle:BRLocalizedString(@"Set Screensaver Time Out",@"Set Screensaver Time Out")
                                                               withDescription:BRLocalizedString(@"Please enter a time in minutes (zero means never)",@"Please enter a time in minutes (zero means never)")
                                                                     withBoxes:3
                                                                       withKey:nil];
			[controller setBRImage:[[BRThemeInfo sharedTheme] photosImage]];
			[controller setValue:[NSNumber numberWithInt:2] forKey:@"options"];
			if([[BRSettingsFacade singleton] screenSaverTimeout]<0)
				[controller setInitialValue:0];
			else
				[controller setInitialValue:[[BRSettingsFacade singleton] screenSaverTimeout]];
			[[self stack] pushController:controller];
            break;
        }
		case kSMSSSFDefaults:
        {
            [SMPreferences setScreensaverSpinFrequency:60];
			break; 
        }
        case kSMSSSTransition:
        {
            [[self stack] pushController:[[SMPhotosTransitionPreferences alloc] init]];
            break; 
        }
        case kSMSSSPAZ:
        {
            if([SMPreferences screensaverPanAndZoom])
            {
                [SMPreferences setScreensaverPanAndZoom:NO];
            }
            else {
                [SMPreferences setScreensaverPanAndZoom:YES];
            }
            break;
        }            
//        case kSMSSSRepeat:
//            randomV=NO;
//            if([[BRSettingsFacade singleton] slideshowRepeat])
//            {
//                [[BRSettingsFacade singleton] setSlideshowRepeat:NO];
//            }
//            else {
//                [[BRSettingsFacade singleton] setSlideshowRepeat:YES];
//            }
//            break;
        case kSMSSSShufflePhotos:
            randomV=NO;
            if([SMPreferences screensaverShufflePhotos])
            {
                [SMPreferences setScreensaverShufflePhotos:NO];
            }
            else {
                [SMPreferences setScreensaverShufflePhotos:YES];
            }
            break;
        case kSMSSSUSEA:
        {
            if([SMPreferences screensaverUseAppleProvider])
            {
                [SMPreferences setScreensaverUseAppleProvider:NO];
            }
            else {
                [SMPreferences setScreensaverUseAppleProvider:YES];
            }
            break;
        }
            
			
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
	[SMPreferences setScreensaverSpinFrequency:[[sender stringValue] intValue]];
	[[self list] reload];
}
@end
