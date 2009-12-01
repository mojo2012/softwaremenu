//
//  SMController.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/30/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//




@implementation SMController
- (void) disableScreenSaver{
    //store screen saver state and disable it
    //!!BRSettingsFacade setScreenSaverEnabled does change the plist, but does _not_ seem to work
    m_screen_saver_timeout = [[BRSettingsFacade singleton] screenSaverTimeout];
    [[BRSettingsFacade singleton] setScreenSaverTimeout:-1];
    [[BRSettingsFacade singleton] flushDiskChanges];
}
- (void) enableScreenSaver{
    //reset screen saver to user settings
    //NSLog(@"timeout: %@",[NSNumber numberWithInt:m_screen_saver_timeout]);
    [[BRSettingsFacade singleton] setScreenSaverTimeout: m_screen_saver_timeout];
    [[BRSettingsFacade singleton] flushDiskChanges];
}
-(CGRect)getMasterFrame
{
    CGRect master ;
    if ([[SMGeneralMethods sharedInstance] usingTakeTwoDotThree]){
        master  = [[self parent] frame];
    } else {
        master = [self frame];
    }
    if ([self is1080i])
        master.size=[self sizeFor1080i];
    return master;
}

- (BOOL)is1080i
{
	NSString *displayUIString = [BRDisplayManager currentDisplayModeUIString];
	NSArray *displayCom = [displayUIString componentsSeparatedByString:@" "];
	NSString *shortString = [displayCom objectAtIndex:0];
	if ([shortString isEqualToString:@"1080i"])
		return YES;
	else
		return NO;
}

- (CGSize)sizeFor1080i
{
	
	CGSize currentSize;
	currentSize.width = 1280.0f;
	currentSize.height = 720.0f;
	
	
	return currentSize;
}
@end
