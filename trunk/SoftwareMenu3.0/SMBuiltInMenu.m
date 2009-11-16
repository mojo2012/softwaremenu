//
//  SMBuiltInMenu.m
//  SoftwareMenu
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 Thomas Cool. All rights reserved.
//

#import "SMBuiltInMenu.h"



@implementation SMBuiltInMenu
-(id)previewControlForItem:(long)row
{
	if(row >= [_items count])
		return nil;
	SMMedia *meta = [[SMMedia alloc] init];
	[meta setDefaultImage];
	[meta setTitle:[[_items objectAtIndex:row] title]];
	[meta setDescription:@"Pressing \"Play\" Button toggles between showing and hiding the menu item. Requires a restart to be taken into effect"];
	SMMediaPreview *preview = [[SMMediaPreview alloc] init];
	[preview setAsset:meta];
	[preview setShowsMetadataImmediately:YES];
	return [preview autorelease];
}
-(void)dealloc
{
    id a = [[[BRApplicationStackManager singleton] stack] rootController];
    if([a respondsToSelector:@selector(reloadMainMenu)])
    {
        [a reloadMainMenu];
        NSLog(@"reloading MM");
    }
    [super dealloc];
}
+(NSArray *)frapArrays
{
    NSArray *builtinfraps;
    if ([SMPreferences threePointZeroOrGreater])
    {
        builtinfraps = [[NSArray alloc] initWithObjects:
                        @"Movies",
                        @"Music",
                        @"Photos",
                        @"Podcasts",
                        @"Internet"
                        ,@"TV"
                        ,nil];
    }
    else 
    {
        builtinfraps = [[NSArray alloc] initWithObjects:
                        @"Movies",
                        @"Music",
                        @"Photos",
                        @"Podcasts",
                        @"YT"
                        ,@"TV"
                        ,nil];
    }
    return [builtinfraps autorelease];

}
+(NSArray *)namesArrays
{
    NSArray *builtinfrapsnames;
    if ([SMPreferences threePointZeroOrGreater])
    {
        builtinfrapsnames = [[NSArray alloc] initWithObjects:
                             BRLocalizedString(@"Movies",@"Movies"),
                             BRLocalizedString(@"Music",@"Music"),
                             BRLocalizedString(@"Photos",@"Photos"),
                             BRLocalizedString(@"Podcasts",@"Podcasts"),
                             BRLocalizedString(@"Internet",@"Internet"),
                             BRLocalizedString(@"TV Shows",@"TV Shows"),
                             nil];
    }
    else 
    {
        builtinfrapsnames = [[NSArray alloc] initWithObjects:
                             BRLocalizedString(@"Movies",@"Movies"),
                             BRLocalizedString(@"Music",@"Music"),
                             BRLocalizedString(@"Photos",@"Photos"),
                             BRLocalizedString(@"Podcasts",@"Podcasts"),
                             BRLocalizedString(@"Youtube",@"YouTube"),
                             BRLocalizedString(@"TV Shows",@"TV Shows"),
                             nil];
    }
    return [builtinfrapsnames autorelease];
    
}
-(id)init{
	self = [super init];
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	NSArray * builtinfraps = [SMBuiltInMenu frapArrays];
	NSArray * builtinfrapsnames = [SMBuiltInMenu namesArrays];
	
	int counter, i=[builtinfraps count];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: @"Built-in Plugins"];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	
	for( counter=0; counter < i ; counter++)
	{
		id item = [[BRTextMenuItemLayer alloc] init];
		[_options addObject:[builtinfraps objectAtIndex:counter]];
		[item setTitle:[builtinfrapsnames objectAtIndex:counter]];
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
	if ([manager fileExistsAtPath:frapPath])		{return YES;}
	else											{return NO;}
}

-(void)itemSelected:(long)row
{
	NSString * thename = [_options objectAtIndex:row];
	NSString * frapPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename];
	NSFileManager *manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:frapPath])	
		{[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-h", [thename stringByAppendingString:@".frappliance"],@"0", nil]];	[[self list] reload];}
	else	
		{[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-s", [thename stringByAppendingString:@".frappliance"],@"0", nil]];	[[self list] reload];}
}

- (id)itemForRow:(long)row					
{ 
	BRTextMenuItemLayer *item = [_items objectAtIndex:row];
	if([self checkExists:[_options objectAtIndex:row]])		
	{
		[item setRightJustifiedText:@"Shown"];
		[item setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] greenGem], @"BRMenuIconImageKey",nil]];
	}
	else													
	{
		[item setRightJustifiedText:@"Hidden"];
		[item setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] redGem], @"BRMenuIconImageKey",nil]];

	}

return item; 
}




@end
