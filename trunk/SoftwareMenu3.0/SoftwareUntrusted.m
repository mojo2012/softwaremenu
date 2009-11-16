//
//  SoftwareUntrusted.m
//  SoftwareMenu
//
//  Created by Thomas on 11/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SoftwareUntrusted.h"


@implementation SoftwareUntrusted
//
//  SoftwareSettings.m
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SoftwareSettings.h"



@implementation SoftwareSettings
- (id) previewControlForItem: (long) item
{
	//NSLog(@"%@ %s", self, _cmd);
	NSString *resourcePath = nil;
	NSString *appPng = nil;
	NSString * theoption = [[_options objectAtIndex:item] objectAtIndex:1];
	NSLog(@"%@",theoption);
	
	resourcePath = @"syspref";
	appPng = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:@"png"];
	BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
	
	
	id sp = [BRImage imageWithPath:appPng];
	
	[obj setImage:sp];
	return (obj);
}

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
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: initId];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	NSMutableDictionary *untrusted =[[NSMutableDictionary alloc] initWithDictionary:nil];
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/untrusted.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]];
		[untrusted addEntriesFromDictionary:tempdict];
		NSLog(@"adding from temp dict");
	}
		
}



-(void)itemSelected:(long)fp8
{
	if([[[_options objectAtIndex:fp8] objectAtIndex:0] isEqualToString:@"1"])
	{
		NSMutableDictionary *hello=[NSMutableDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]];
		NSString *settingsChanged=[[_options objectAtIndex:fp8] objectAtIndex:1];
		NSLog(@"settingsChanged: %@", settingsChanged);
		NSString *settingIs= [hello valueForKey:settingsChanged];
		if([settingIs isEqualToString:@"Shown"])
		{
			[hello setValue:@"Hidden" forKey:settingsChanged];
			
			
		}
		else
		{
			[hello setValue:@"Shown" forKey:settingsChanged];
		}
		NSLog(@"new value is %@", [hello valueForKey:@"settingsChanged"]);
		[hello writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/settings.plist" atomically:YES];
		[self initWithIdentifier:@"101"];
	}
	if([[[_options objectAtIndex:fp8] objectAtIndex:1] isEqualToString:@"AddUntrusted"])
	{
		// Call for Menu to manage untrusted
		
		BRTextEntryController *textinput = [[BRTextEntryController alloc] init];
		[textinput setTitle:@"add Untrusted: Name"];
		[textinput setTextEntryCompleteDelegate:self];
		[[self stack] pushController:textinput];
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
- (void) textDidEndEditing: (id) sender
{

	[[self stack] popController];
	NSString *thetext = [sender stringValue];
	NSLog(@"thetext");
	NSMutableDictionary *untrusted = [[NSMutableDictionary alloc] initWithDictionary:nil];
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/untrusted.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/untrusted.plist" stringByExpandingTildeInPath]];
		[untrusted addEntriesFromDictionary:tempdict];
		NSLog(@"adding from temp dict");
	}
	int iv = [untrusted count] +1;
	NSLog(@"thetext: %@", thetext);
	[untrusted setValue:thetext forKey:[NSString stringWithFormat:@"%d",iv]];
	[untrusted writeToFile:[@"~/Library/Application Support/SoftwareMenu/untrusted.plist" stringByExpandingTildeInPath] atomically:YES];
	
}


//	Data source methods:

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }



@end

@end
