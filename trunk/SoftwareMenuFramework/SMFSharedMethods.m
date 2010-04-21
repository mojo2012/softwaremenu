//
//  SMFSharedMethods.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/3/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//


#import "AGProcess.h"

@implementation SMFSharedMethods
+ (BOOL)OSGreaterThan:(NSString *)value
{
	NSComparisonResult theResult = [value compare:[SMFPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
		return NO;
	} else if ( theResult == NSOrderedAscending ){
		return YES;
	} else if ( theResult == NSOrderedSame ) {
        
		return YES;
	}
	return NO;
}
+ (BOOL)OSLessThan:(NSString *)value
{
    NSComparisonResult theResult = [value compare:[SMFPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
        NSLog(@"descending");
		return YES;
	} else if ( theResult == NSOrderedAscending ){
        NSLog(@"ascending");
		return NO;
	} else if ( theResult == NSOrderedSame ) {
        NSLog(@"same");
		return YES;
	}
	return NO;
}
+(NSString *)getImagePath:(NSString *)Name
{
	NSFileManager *man =[NSFileManager defaultManager];
	NSString *filepath = nil;
	NSSet *imageExtensions = [SMFThemeInfo coverArtExtensions];
	NSEnumerator *objEnum = [imageExtensions objectEnumerator];
	id obj;
	while((obj = [objEnum nextObject]) != nil) 
	{
		filepath=[[SMFPreferences ImagesPath] stringByAppendingPathComponent:[Name stringByAppendingPathExtension:obj]];
        //NSLog(@"filepath: %@",filepath);
		if([man fileExistsAtPath:filepath])
		{
			return (filepath);
		}
	}
	return filepath;
}
+(void)terminateFinder
{
		AGProcess *finder = [AGProcess processForCommand:@"Finder"];
		[finder terminate];
}
@end
