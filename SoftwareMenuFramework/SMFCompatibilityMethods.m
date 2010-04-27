//
//  SMFCompatibilityMethods.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/25/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMFCompatibilityMethods.h"
//Take 3 Remote Actions
enum {
	kBREventRemoteActionTake3TouchBegin = 29,
	kBREventRemoteActionTake3TouchMove,
	kBREventRemoteActionTake3TouchEnd,
	kBREventRemoteActionTake3SwipeLeft,
	kBREventRemoteActionTake3SwipeRight,
	kBREventRemoteActionTake3SwipeUp,
	kBREventRemoteActionTake3SwipeDown,
};

//Take 3.0.2 Remote Actions

enum {
	kBREventRemoteActionTake302TouchBegin = 30,
	kBREventRemoteActionTake302TouchMove,
	kBREventRemoteActionTake302TouchEnd,
	kBREventRemoteActionTake302SwipeLeft,
	kBREventRemoteActionTake302SwipeRight,
	kBREventRemoteActionTake302SwipeUp,
	kBREventRemoteActionTake302SwipeDown,
};

@implementation SMFCompatibilityMethods
static SMFFrontrowRowCompatATVVersion atvVersion = SMFFrontrowRowCompatATVVersionUnknown;
static BOOL usingLeopard = NO;
static BOOL usingATypeOfTakeTwo = NO;
static BOOL usingLeopardOrATypeOfTakeTwo = NO;
static BOOL usingATypeOfTakeThree = NO;

+ (void)initialize
{
	if(NSClassFromString(@"BRAdornedMenuItemLayer") == nil)
	{
		atvVersion = SMFFrontrowRowCompatATVVersionLeopardFrontrow;
		usingLeopard = YES;
		usingLeopardOrATypeOfTakeTwo = YES;
	}
	
	if(NSClassFromString(@"BRBaseAppliance") != nil)
	{
		atvVersion = SMFFrontrowRowCompatATVVersion2;
		usingLeopard = NO;
		usingATypeOfTakeTwo = YES;
	}
	
	if(NSClassFromString(@"BRVideoPlayerController") == nil)
		atvVersion = SMFFrontrowRowCompatATVVersion2Dot2;
	
	if([(Class)NSClassFromString(@"BRController") instancesRespondToSelector:@selector(wasExhumed)])
		atvVersion = SMFFrontrowRowCompatATVVersion2Dot3;
	
	if(NSClassFromString(@"BRPhotoImageProxy") != nil)
		atvVersion = SMFFrontrowRowCompatATVVersion2Dot4;
	
	if(NSClassFromString(@"BRFullscreenRenderTarget") != nil)
	{	
		atvVersion = SMFFrontrowRowCompatATVVersion3;
		usingATypeOfTakeThree = YES;
		NSDictionary *finderDict = [[NSBundle mainBundle] infoDictionary];
		NSString *bundleVersion = [finderDict objectForKey: @"CFBundleVersion"];
		//NSLog(@"appletversion: %@",  theVersion);
		
		if([bundleVersion compare:@"3.0.2" options:NSNumericSearch] != NSOrderedAscending)
			atvVersion = SMFFrontrowRowCompatATVVersion302;
	}
}
+ (SMFFrontrowRowCompatATVVersion)atvVersion
{
	return atvVersion;
}

+ (BOOL)usingLeopard
{
	return usingLeopard;
}

+ (BOOL)usingATypeOfTakeTwo
{
	return usingATypeOfTakeTwo;
}

+ (BOOL)usingLeopardOrATypeOfTakeTwo
{
	return usingLeopardOrATypeOfTakeTwo;
}

+ (BOOL)usingFrontRow
{
	return atvVersion >= SMFFrontrowRowCompatATVVersionLeopardFrontrow;
}

+ (BOOL)usingTakeTwo
{
	return atvVersion >= SMFFrontrowRowCompatATVVersion2;
}

+ (BOOL)usingTakeTwoDotTwo
{
	return atvVersion >= SMFFrontrowRowCompatATVVersion2Dot2;
}

+ (BOOL)usingTakeTwoDotThree
{
	return atvVersion >= SMFFrontrowRowCompatATVVersion2Dot3;
}

+ (BOOL)usingTakeTwoDotFour
{
	return atvVersion >= SMFFrontrowRowCompatATVVersion2Dot4;
}
+ (BOOL)usingTakeThree
{
    return usingATypeOfTakeThree;
}
+ (int)remoteActionForEvent:(BREvent *)event
{
	if(atvVersion >= SMFFrontrowRowCompatATVVersion302)
	{
		BREventRemoteAction action = [event remoteAction];
		switch (action) {
			case kBREventRemoteActionTake302TouchEnd:
			case kBREventRemoteActionTake302SwipeLeft:
			case kBREventRemoteActionTake302SwipeRight:
			case kBREventRemoteActionTake302SwipeUp:
			case kBREventRemoteActionTake302SwipeDown:
				return action - 2;
				break;
			default:
				return action;
				break;
		}
	}
	if(atvVersion >= SMFFrontrowRowCompatATVVersion3)
	{
		BREventRemoteAction action = [event remoteAction];
		switch (action) {
			case kBREventRemoteActionTake3TouchEnd:
			case kBREventRemoteActionTake3SwipeLeft:
			case kBREventRemoteActionTake3SwipeRight:
			case kBREventRemoteActionTake3SwipeUp:
			case kBREventRemoteActionTake3SwipeDown:
				return action - 1;
				break;
			default:
				return action;
				break;
		}
	}
	if(atvVersion >= SMFFrontrowRowCompatATVVersion2Dot4)
		return [event remoteAction];
    return 0;
	
}

@end
