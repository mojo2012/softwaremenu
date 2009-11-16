//
//  SMPseudoCompat.m
//  SoftwareMenu
//
//  Created by Thomas on 5/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMPseudoCompat.h"


@implementation SMPseudoCompat
+(BOOL)usingTakeTwoDotThree
{
	if([(Class)NSClassFromString(@"BRController") instancesRespondToSelector:@selector(wasExhumed)])	{return YES;}
	else																								{return NO; }	
}
+(NSString *)SMATVVersion
{
	 return [[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/version.plist"] valueForKey:@"CFBundleVersion"];
}
@end
