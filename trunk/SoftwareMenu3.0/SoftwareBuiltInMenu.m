//
//  DownloadableMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#define DEBUG_MODE false
#import "SoftwareBuiltInMenu.h"
#import "SMInstallMenu.h"
#import "SMGeneralMethods.h"


@implementation SoftwareBuiltInMenu
-(id)init{
	//NSLog(@"init");
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	return [super init];
}
- (void)dealloc
{
	[super dealloc];  
}

-(id)initWithIdentifier:(NSString *)initId
{
	NSArray * builtinfraps = [[NSArray alloc] initWithObjects:@"Movies",@"Music",@"Photos",@"Podcasts",@"YT",@"TV",nil];
	NSMutableArray * builtinfrapsnames = [[NSMutableArray alloc] initWithObjects:BRLocalizedString(@"Movies",@"Movies"),BRLocalizedString(@"Music",@"Music"),BRLocalizedString(@"Photos",@"Photos"),BRLocalizedString(@"Podcasts",@"Podcasts"),BRLocalizedString(@"Youtube",@"YouTube"),BRLocalizedString(@"TV Shows",@"TV Shows"),nil];
	int i;//
	i=[builtinfraps count];
	////NSLog("%i",i);
	
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: @"Built-in Plugins"];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	int counter;
	
	for( counter=0; counter < i ; counter++)
	{
		id item = [[BRTextMenuItemLayer alloc] init];
		
		NSString *builtinfrap = (NSString *)[builtinfraps objectAtIndex:counter];
		NSString *builtinfrapname =(NSString *)[builtinfrapsnames objectAtIndex:counter];
		[_options addObject:builtinfrap];
		//NSLog(@"%@",builtinfrap);
		[item setTitle:builtinfrapname];
		if([self checkExists:builtinfrap])
		{
			[item setRightJustifiedText:BRLocalizedString(@"Shown",@"Shown")];
		}
		else
		{
			[item setRightJustifiedText:BRLocalizedString(@"Hidden",@"Hidden")];
		}
		[_items addObject: item];
	}
	
	id list = [self list];
	[list setDatasource: self];
	return self;
}
-(BOOL)checkExists:(NSString *)thename	
{
	NSString *frapPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename];
	NSFileManager *manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:frapPath])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}
-(void)itemSelected:(long)fp8
{
	//NSLog(@"===== builtin itemselected =====");
	NSString * thename = [_options objectAtIndex:fp8];
	//NSLog(@"%@",thename);
	NSString * frapPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename];
	//NSString * bakPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns (Disabled)/%@.bak/",thename];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:frapPath])
	{
		NSLog(@"hiding");
		NSTask *helperTask = [[NSTask alloc] init];
		NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
		NSDictionary *attrs = [[NSFileManager defaultManager] fileAttributesAtPath:helperPath traverseLink:YES];
		//NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
		if (![self helperCheckPerm])
			return;
		[helperTask setLaunchPath:helperPath];
		[helperTask setArguments:[NSArray arrayWithObjects:@"-h", [thename stringByAppendingString:@".frappliance"],@"0", nil]];
		[helperTask launch];
		[helperTask waitUntilExit];
		int theTerm = [helperTask terminationStatus];
		//NSLog(@"term status: %d",theTerm);
		[self initWithIdentifier:@"101"];
		
	}
	else
	{
		NSTask *helperTask = [[NSTask alloc] init];
		NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
		NSDictionary *attrs = [[NSFileManager defaultManager] fileAttributesAtPath:helperPath traverseLink:YES];
		//NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
		if (![self helperCheckPerm])
		{
			NSLog(@"too low perms -- running");
			NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
			NSTask *task = [[NSTask alloc] init];
			NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
			[task setArguments:args];
			[task setLaunchPath:@"/bin/bash"];
			[task launch];
			[task waitUntilExit];
		}
			
		[helperTask setLaunchPath:helperPath];
		[helperTask setArguments:[NSArray arrayWithObjects:@"-s", [thename stringByAppendingString:@".frappliance"],@"0", nil]];
		[helperTask launch];
		[helperTask waitUntilExit];
		int theTerm = [helperTask terminationStatus];
		//NSLog(@"term status: %d",theTerm);
		[self initWithIdentifier:@"101"];
	}
}

-(long)defaultIndex
{
	return 0;
}
-(void)willBeBuried
{
	//NSLog(@"willBuried");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBeBuried];
}

-(void)willBePushed
{
	//NSLog(@"willBePushed");
	[super willBePushed];
}

-(void)willBePopped
{
	//NSLog(@"willBePopped");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBePopped];
}

- (BOOL)helperCheckPerm
{
	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *attrs = [man fileAttributesAtPath:helperPath traverseLink:YES];
	NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
	////NSLog(@"curPerms: %@", curPerms);
	if ([curPerms intValue] < 2541)
	{
		//NSLog(@"installHelper permissions: %@ are not sufficient, dying", curPerms);
		return (NO);
	}
	
	return (YES);
	
}


//	Data source methods:

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }



@end
