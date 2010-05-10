//
//  NSMutableArray-SMFExtensions.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 5/8/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "NSArray-SMFExtensions.h"



@implementation NSArray (SMFExtensions)
- (NSArray *) shuffled
{
	// create temporary autoreleased mutable array
	NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self count]];
    int i, count=[self count];
	for (i=0;i<count;i++)
	{
        id anObject=[self objectAtIndex:i];
		int randomPos = arc4random()%([tmpArray count]+1);
		[tmpArray insertObject:anObject atIndex:randomPos];
	}
    
	return [NSArray arrayWithArray:tmpArray];  // non-mutable autoreleased copy
}

@end
