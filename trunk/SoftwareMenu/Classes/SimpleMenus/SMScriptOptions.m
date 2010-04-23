//
//  SMScriptOptions.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/23/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMScriptOptions.h"
#define ROOT_KEY        @"root"
#define WAIT_KEY        @"wait"
#define CUST_KEY        @"custom"
#define MAIN_KEY        @"mainmenu"

@interface SMScriptOptions (Private)
-(void)save;
@end

@implementation SMScriptOptions
-(NSString *)scriptName
{
    return _scriptName;
}
-(void)setScriptName:(NSString *)name
{
    if (_scriptName!=nil) {
        [_scriptName release];
        _scriptName=nil;
    }
    _scriptName=[name retain];
}
-(id)initWithScriptName:(NSString *)scriptName
{
    self=[super init];
    [self setScriptName:scriptName];
    _scriptOptions=[[[SMNewScriptsMenu scriptsOptions] objectForKey:scriptName] mutableCopy];
    if (_scriptOptions==nil) {
        _scriptOptions=[[SMNewScriptsMenu defaultScriptOptions] mutableCopy];
    }
    [_scriptOptions retain];
    [self setListTitle:scriptName];
    id item=[BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Use Custom Options:",@"Use Custom Options:")];
    [_items addObject:item];
    
    item=[BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Run As Root:",@"Run As Root:")];
    [_items addObject:item];
    
    item=[BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Wait For Completion:",@"Wait For Completion:")];
    [_items addObject:item];
    

    
    item=[BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Show on Main Menu:",@"Show on Main Menu")];
    [_items addObject:item];
    return self;
}
-(id)itemForRow:(long)row
{
    if (row>=[_items count]) {
        return nil;
    }
    BRTextMenuItemLayer *item = [_items objectAtIndex:row];
    switch (row) {
        case 0:
            [item setRightJustifiedText:([[_scriptOptions objectForKey:CUST_KEY] boolValue]?@"YES":@"NO")];
            break;
        case 1:
            [item setRightJustifiedText:([[_scriptOptions objectForKey:ROOT_KEY] boolValue]?@"YES":@"NO")];
            break;
        case 2:
            [item setRightJustifiedText:([[_scriptOptions objectForKey:WAIT_KEY] boolValue]?@"YES":@"NO")];
            break;
        case 3:
            [item setRightJustifiedText:([[_scriptOptions objectForKey:MAIN_KEY] boolValue]?@"YES":@"NO")];
            break;
        default:
            break;
    }
    return item;
}
-(void)itemSelected:(long)arg1
{
    NSArray *ar=[NSArray arrayWithObjects:CUST_KEY,ROOT_KEY,WAIT_KEY,MAIN_KEY,nil];
    [_scriptOptions setObject:[NSNumber numberWithBool:![[_scriptOptions objectForKey:[ar objectAtIndex:arg1]] boolValue]] forKey:[ar objectAtIndex:arg1]];
    [[self list]reload];
}
-(void)wasPopped
{
    NSLog(@"control was popped");
    NSLog(@"options: %@",_scriptOptions);
    [self save];
    [super wasPopped];
}

@end
@implementation SMScriptOptions (Private)
-(void)save
{
    NSMutableDictionary *opts = [[SMNewScriptsMenu scriptsOptions] mutableCopy];
    
    if (_scriptOptions!=nil) {
        [opts setObject:_scriptOptions forKey:_scriptName];
        [opts writeToFile:[SMNewScriptsMenu scriptsPlistPath] atomically:YES];
    }
}
@end
