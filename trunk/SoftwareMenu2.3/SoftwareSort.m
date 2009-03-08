//
//  SoftwareSort.m
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SoftwareSort.h"


@implementation SoftwareSort
_names = [[NSMutableArray alloc] init];
_locations = [[NSMutableArray alloc] init];
_locationDicts = [[NSMutableArray alloc] init];

_listState = listState;

NSString *theDest = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/nito"];
NSString *rssFile = [theDest stringByAppendingPathComponent:@"rss.plist"];
if(![[NSFileManager defaultManager] fileExistsAtPath:rssFile])
rssFile = [[NSBundle bundleForClass:[ntvRssBrowser class]] pathForResource:@"rss" ofType:@"plist"];
NSDictionary *fullDict = [NSDictionary dictionaryWithContentsOfFile:rssFile];

NSDictionary *feedDict = [fullDict valueForKey:@"Feeds"];
//NSLog(@"feeds: %@", feedDict);
int feedCount = [[feedDict allKeys] count];
int i;
NSString *currentName = nil;
id currentItem = nil;
NSString *currentKey = nil;
NSString *currentLocale = nil;
NSArray *sortedArray;
NSSortDescriptor *nameDescriptor =

[[[NSSortDescriptor alloc] initWithKey:@"name"
  
							 ascending:YES
  
							  selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];





NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];





//NSLog(@"sortedArray: %@", sortedArray);


int k;



for (i = 0; i < feedCount; i++)
{
	NSDictionary *dict;
	
	currentKey = [[feedDict allKeys] objectAtIndex:i];
	currentItem = [feedDict valueForKey:currentKey];
	//NSLog(@"currentItem: %@", currentItem);
	currentName = [currentItem valueForKey:@"name"];
	currentLocale = [currentItem valueForKey:@"location"];
	dict = [NSDictionary dictionaryWithObjectsAndKeys:currentName, @"name", currentLocale, @"location", nil];
	[_locationDicts addObject:dict];
	
	
}

sortedArray = [_locationDicts sortedArrayUsingDescriptors:descriptors];
for (k = 0; k < [sortedArray count]; k++)
{
	currentItem = [sortedArray objectAtIndex:k];
	//NSLog(@"currentItem: %@", currentItem);
	currentName = [currentItem valueForKey:@"name"];
	currentLocale = [currentItem valueForKey:@"location"];
	[_names addObject:currentName];
	[_locations addObject:currentLocale];
}
@end
