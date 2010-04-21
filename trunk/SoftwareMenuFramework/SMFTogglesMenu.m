//
//  SMFSettingsToggles.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 11/9/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//



@implementation SMFTogglesMenu
-(id)initWithNames:(NSArray *)names withKeys:(NSArray*)keys
{
    self = [super init];
    [self setListTitle:BRLocalizedString(@"Menu Items",@"Menu Items")];
    _menuNames = [names copy];
    //[_items retain];
    _menuOptions = [keys copy];
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
    if([SMFPreferences boolForKey:[_menuOptions objectAtIndex:row]])		
    {[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMFThemeInfo sharedTheme] greenGem], @"BRMenuIconImageKey",nil]];}
    else										
    {[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMFThemeInfo sharedTheme] redGem], @"BRMenuIconImageKey",nil]];}
    return item;
}
-(void)itemSelected:(long)row
{
    [SMFPreferences switchBoolforKey:[_menuOptions objectAtIndex:row]];
    [[self list] reload];
}
-(void)dealloc
{
    [_menuNames release];
    [_menuOptions release];
    [super dealloc];
}
@end
