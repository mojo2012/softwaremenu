//
//  SMTweaks.m
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMTweaks.h"
#import "SMGeneralMethods.h"


@implementation SMTweaks
-(void)getDict;
{
	_infoDict=[NSMutableDictionary dictionaryWithContentsOfURL:[BASE_URL stringByAppendingString:@"tweaks.plist"]];
	[_infoDict retain];
}
-(id)initCustom
{
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: @"Settings"];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	NSArray * settingNames = [[NSArray alloc] initWithObjects:@"Perian",@"RemoveSapphireMetaData",@"toggleRW",nil];
	NSArray * settingDisplays = [[NSArray alloc] initWithObjects:@"Install Perian",@"Fix Sapphire", @"Toggle disk Read/Write",nil];
	NSArray * settingType = [[NSArray alloc] initWithObjects:@"Download",@"Fix",@"Fix",nil];
	
	int i,counter;
	i=[settingNames count]-1;
	for(counter=0;counter<i;counter++)
	{
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc] init];
		[item setTitle:[settingDisplays objectAtIndex:counter]];
		[_options addObjects:@"settingType",@"settingNames",nil];
		[_items addObject:item];
		
		
	}
	
		
}
		
@end
