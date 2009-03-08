//
//  DownloadableMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#define DEBUG_MODE false
#import "DownloadableMenu.h"
#import "SoftwareScriptsMenu.h"


@implementation SoftwareScriptsMenu
-(id)init{
	NSLog(@"init");
	
	return [super init];
}
- (void)dealloc
{
	[super dealloc];  
}

-(id)initWithIdentifier:(NSString *)initId
{
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: @"Downloadable Plugins"];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	
	NSArray *loginItemDict = [NSArray arrayWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info.plist"]];
	NSEnumerator *enumerator = [loginItemDict objectEnumerator];
	
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		
		
		NSLog(@"1");
		NSString *thename = [obj valueForKey:@"name"];
		NSString *onlineVersion = [obj valueForKey:@"version"];
		NSLog(@"%@", onlineVersion);
		NSString *frapPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename];
		NSFileManager *manager = [NSFileManager defaultManager];
		id item = [[BRTextMenuItemLayer alloc] init];
		NSLog(@"2");
		
		
		if ([manager fileExistsAtPath:frapPath])
		{
			NSLog(@"%@.frappliance exists",thename);
			NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
			NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
			NSString * current_version =[[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
			if ([current_version isEqualToString:onlineVersion])
			{
				[item setRightJustifiedText:@"Up to Date"];
				NSLog(@"Up to Date");
			}
			else
			{
				[item setRightJustifiedText:onlineVersion];
				NSLog(@"Not up to date, current is %@",onlineVersion);
			}
		}
		else
		{
			[item setRightJustifiedText:@"Not Installed"];
			NSLog(@"Not Installed");
		}
		
		
		//Adding option for Info
		[_options addObject:thename];
		[item setTitle:thename];
		[_items addObject: item];
	}
	id item2 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:@"hello"];
	[item2 setTitle:@"hello"];
	[_items addObject: item2];
	id list = [self list];
	[list setDatasource: self];
	return self;
}
-(void)itemSelected:(long)fp8
{
	id newController = nil;
	NSString * thename = [_options objectAtIndex:fp8];
	NSLog(@"%@",thename);
	NSLog(@"selected something");
	NSArray *loginItemDict = [NSArray arrayWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Desktop/Info.plist"]];
	NSEnumerator *enumerator = [loginItemDict objectEnumerator];
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		if ([thename isEqualToString:[obj valueForKey:@"name"]])
		{
			NSLog(@"right name: %@", thename);
			NSString * theURL = [obj valueForKey:@"theURL"];
			NSString * theversion = [obj valueForKey:@"Version"];
			
			newController = [[SoftwareMenu alloc] init];
			[newController initWithIdentifier:@"frap-soft" withName:thename withURLStr:theURL withVers:theversion];
			[[self stack] pushController: newController];
		}
	}
}

-(long)defaultIndex
{
	return 0;
}
-(void)willBeBuried
{
	NSLog(@"willBuried");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBeBuried];
}

-(void)willBePushed
{
	NSLog(@"willBePushed");
	[super willBePushed];
}

-(void)willBePopped
{
	NSLog(@"willBePopped");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBePopped];
}


//	Data source methods:

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }



@end
