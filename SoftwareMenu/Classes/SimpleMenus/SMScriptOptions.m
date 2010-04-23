//
//  SMScriptOptions.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/23/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMScriptOptions.h"


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
    _scriptOptions=[SMNewScriptsMenu scriptsOptions];
    [self setListTitle:scriptName];
    id item=[BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Run As Root:",@"Run As Root")];
    [_items addObject:item];
    return self;
}
@end
