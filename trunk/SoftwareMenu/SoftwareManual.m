//
//  DownloadableMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#define DEBUG_MODE false
#import "SoftwareManual.h"

//#import	"SoftwareManualInfo.h"


@implementation SoftwareManual
-(id)init{
	//NSLog(@"init");
	
	return [super init];
}
- (void)dealloc
{
	[super dealloc];  
}

-(id)initWithIdentifier:(NSString *)initId
{
	if(![[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted" stringByExpandingTildeInPath]])
		[[NSFileManager defaultManager] createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted" stringByExpandingTildeInPath] attributes:nil];
	//NSLog(@"manual");
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: @"Manage Untrusted Sources"];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	//int counter;
	id item1 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:[[NSArray alloc] initWithObjects:@"Add",nil]];
	[item1 setTitle:@"Add Untrusted"];
	[_items addObject:item1];
	
	NSMutableDictionary *untrusted = [[NSMutableDictionary alloc] initWithDictionary:nil];
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath]];
		[untrusted addEntriesFromDictionary:tempdict];
		//NSLog(@"adding from temp dict untrusted");
	}
	NSEnumerator *enumerator = [untrusted objectEnumerator];
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		id item7 = [[BRTwoLineTextMenuItemLayer alloc] init];
		
		//id item2= [[BRTextMenuItemLayer alloc] init];
		//NSLog(@"%@",obj);
		NSString *thename = [obj valueForKey:@"name"];
		NSString *theURL =[obj valueForKey:@"theURL"];
		//NSLog(@"name: %@",thename);
		[_options addObject:[[NSArray alloc] initWithObjects:@"1",thename,theURL,nil]];
		//NSLog(@"1");
		//[item2 setTitle:thename];
		//[item2 setRightJustifiedText:theURL];
		[item7 setTitle:thename];
		[item7 setSubtitle:theURL];
		//NSLog(@"2");
		[_items addObject:item7];
	}
	
	id list = [self list];
	[list setDatasource: self];
	[list addDividerAtIndex:1 withLabel:@"Pressing Play on a Source Removes it"];
	
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
	NSArray *optionSelected=[_options objectAtIndex:fp8];
	//NSLog(@"optionSelected: %@",optionSelected);
	if ([[optionSelected objectAtIndex:0] isEqualToString:@"Add"])
	{
		// Call for Menu to manage untrusted
		CFPreferencesSetAppValue(CFSTR("status"), (CFStringRef)[NSString stringWithString:@"name"],kCFPreferencesCurrentApplication);
        
        BRTextEntryController *textinput = [[BRTextEntryController alloc] init];
        [textinput setTitle:@"add Untrusted: Name"];
        if([SMPreferences threePointZeroOrGreater])
            [textinput setTextFieldDelegate:self];
        else
            [textinput setTextEntryCompleteDelegate:self];
        [[self stack] pushController:textinput];
		
	}
	else if([[optionSelected objectAtIndex:0] isEqualToString:@"1"])
	{
		//NSLog(@"Removing");
		NSMutableDictionary *untrusted = [[NSMutableDictionary alloc] initWithDictionary:nil];
		if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath]])
		{
			NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath]];
			[untrusted addEntriesFromDictionary:tempdict];
			//NSLog(@"adding from temp dict untrusted");
		}
		[untrusted removeObjectForKey:[optionSelected objectAtIndex:1]];
		[untrusted writeToFile:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath] atomically:YES];
		[self initWithIdentifier:@"101"];
		/*id newController = nil;
		newController = [[SoftwareManualInfo alloc] init];
		[newController initWithIdentifier:[optionSelected objectAtIndex:1]];
		[[self stack] pushController:newController];	*/	
	}
}

-(long)defaultIndex
{
	return 0;
}
/*-(void)willBeBuried
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
}*/

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
- (void) textDidEndEditing: (id) sender
{
	[[self stack] popController];
	NSString *thetext = [sender stringValue];
	////NSLog(@"thetext");
	
	NSString *thestatus= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"status", kCFPreferencesCurrentApplication));
	
	if([thestatus isEqualToString:@"name"])
	{
		NSMutableDictionary *untrusted = [[NSMutableDictionary alloc] initWithDictionary:nil];
		if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath]])
		{
			NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath]];
			[untrusted addEntriesFromDictionary:tempdict];
			//NSLog(@"adding from temp dict");
		}
		if([[[untrusted objectForKey:thetext] objectForKey:name] isEqualToString:thetext])
		{
			[self initWithIdentifier:@"101"];
		}
		else
		{
			CFPreferencesSetAppValue(CFSTR("unName"), (CFStringRef)[NSString stringWithString:thetext],kCFPreferencesCurrentApplication);
			CFPreferencesSetAppValue(CFSTR("status"), (CFStringRef)[NSString stringWithString:@"URL"],kCFPreferencesCurrentApplication);
			BRTextEntryController *textinput = [[BRTextEntryController alloc] init];
			[textinput setTitle:@"add Untrusted: URL"];
            if([SMPreferences threePointZeroOrGreater])
                [textinput setTextFieldDelegate:self];
            else
                [textinput setTextEntryCompleteDelegate:self];
			[[self stack] pushController:textinput];
		}
		//NSLog(@"thetext: %@", thetext);
		//[untrusted setValue:thetext forKey:[NSString stringWithFormat:@"%d",iv]];
		//[untrusted writeToFile:[@"~/Library/Application Support/SoftwareMenu/untrusted.plist" stringByExpandingTildeInPath] atomically:YES];
	}
	else
	{
		NSMutableDictionary *untrusted = [[NSMutableDictionary alloc] initWithDictionary:nil];
		if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath]])
		{
			NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath]];
			[untrusted addEntriesFromDictionary:tempdict];
			//NSLog(@"adding from temp dict");
		}
		
		NSString *unName= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"unName", kCFPreferencesCurrentApplication));
		NSMutableDictionary *thedict =[NSMutableDictionary dictionaryWithObjectsAndKeys:unName,@"name",thetext,@"theURL",nil];
		[untrusted setValue:thedict forKey:unName];
		[untrusted writeToFile:[@"~/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist" stringByExpandingTildeInPath] atomically:YES];
		[self initWithIdentifier:@"101"];
	}
}
- (void) textDidChange: (id) sender
{
	//Do Nothing Now
}


//	Data source methods:

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }



@end
