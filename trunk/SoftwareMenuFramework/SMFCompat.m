//
//  SMFCompat.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/22/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMFCompat.h"


@implementation SMFCompat
+ (BOOL)greaterThanVersion:(NSString *)version
{
    NSComparisonResult theResult = [version compare:[SMFPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
		return NO;
	} else if ( theResult == NSOrderedAscending ){
		return YES;
	} else if ( theResult == NSOrderedSame ) {
		return YES;
	}
	return NO;
}
+ (BOOL)versionEqual:(NSString *)version
{
    NSComparisonResult theResult = [version compare:[SMFPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
		return NO;
	} else if ( theResult == NSOrderedAscending ){
		return NO;
	} else if ( theResult == NSOrderedSame ) {
		return YES;
	}
	return NO;
}
+ (BOOL)twoPointThreeOrGreater
{
    return [self greaterThanVersion:@"2.3"];
}
+(BOOL)usingTwoPointThree
{
    return [self versionEqual:@"2.3"];
}
+ (BOOL)threePointZeroOrGreater
{
	return [self greaterThanVersion:@"3.0"];
}

@end
