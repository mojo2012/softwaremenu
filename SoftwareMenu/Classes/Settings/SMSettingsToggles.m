//
//  SMSettingsToggles.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/9/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMSettingsToggles.h"


@implementation SMSettingsToggles
-(id)init
{
    self = [super init];
    [self setListTitle:BRLocalizedString(@"Menu Items",@"Menu Items")];
    _menuNames = [[SoftwareMenuBase menuItemNames] mutableCopy];
    //[_items retain];
    _menuOptions = (NSArray *)[SoftwareMenuBase menuItemOptions];
    [_menuOptions retain];
    _items = [[NSMutableArray alloc] init];
    int i;
    for(i=0;i<[_menuNames count];i++)
    {
        BRTextMenuItemLayer *a = [[BRTextMenuItemLayer alloc] init];
        [a setTitle:[_menuNames objectAtIndex:i]];
        [_items addObject:a];
    }
    [self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
    [[self list] setDatasource:self];
    return self;
}
-(id)itemForRow:(long)row
{
    id item = [_items objectAtIndex:row];
    if([SMGeneralMethods boolForKey:[_menuOptions objectAtIndex:row]])		
    {[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] greenGem], @"BRMenuIconImageKey",nil]];}
    else										
    {[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] redGem], @"BRMenuIconImageKey",nil]];}
    return item;
}
-(void)itemSelected:(long)row
{
    [SMGeneralMethods switchBoolforKey:[_menuOptions objectAtIndex:row]];
    [[self list] reload];
}
-(void)dealloc
{
    [_menuNames release];
    [_menuOptions release];
    [super dealloc];
}
@end
