//
//  SMFCompatibilityMethods.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/25/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	SMFFrontrowRowCompatATVVersionUnknown = 0,
	SMFFrontrowRowCompatATVVersion1 = 1,
	SMFFrontrowRowCompatATVVersionLeopardFrontrow,
	SMFFrontrowRowCompatATVVersion2,
	SMFFrontrowRowCompatATVVersion2Dot2,
	SMFFrontrowRowCompatATVVersion2Dot3,
	SMFFrontrowRowCompatATVVersion2Dot4,
	SMFFrontrowRowCompatATVVersion3,
	SMFFrontrowRowCompatATVVersion302,
} SMFFrontrowRowCompatATVVersion;

typedef enum {
	kBREventOriginatorRemote = 1,
	kBREventOriginatorGesture = 3
} BREventOriginator;

typedef enum {
	// for originator kBREventOriginatorRemote
	kBREventRemoteActionMenu = 1,
	kBREventRemoteActionMenuHold,
	kBREventRemoteActionUp,
	kBREventRemoteActionDown,
	kBREventRemoteActionPlay,
	kBREventRemoteActionLeft,
	kBREventRemoteActionRight,
    
	kBREventRemoteActionPlayHold = 20,
    
	// Gestures, for originator kBREventOriginatorGesture
	kBREventRemoteActionTap = 30,
	kBREventRemoteActionSwipeLeft,
	kBREventRemoteActionSwipeRight,
	kBREventRemoteActionSwipeUp,
	kBREventRemoteActionSwipeDown,
	
	// Custom remote actions for old remote actions
	kBREventRemoteActionHoldLeft = 0xfeed0001,
	kBREventRemoteActionHoldRight,
	kBREventRemoteActionHoldUp,
	kBREventRemoteActionHoldDown,
} BREventRemoteAction;


@interface SMFCompatibilityMethods : NSObject {

}
+ (SMFFrontrowRowCompatATVVersion)atvVersion;
+ (BOOL)usingLeopard;
+ (BOOL)usingATypeOfTakeTwo;
+ (BOOL)usingLeopardOrATypeOfTakeTwo;
+ (BOOL)usingFrontRow;
+ (BOOL)usingTakeTwo;
+ (BOOL)usingTakeTwoDotTwo;
+ (BOOL)usingTakeTwoDotThree;
+ (BOOL)usingTakeTwoDotFour;
+ (BOOL)usingTakeThree;
+ (int)remoteActionForEvent:(BREvent *)event;
/*
 *  Some Display Methods
 */
+ (BOOL)using1080i;
+ (CGSize)sizeFor1080i;
@end
