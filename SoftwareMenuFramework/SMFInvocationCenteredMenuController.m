//
//  SMFInvocationCenteredMenuController.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/27/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//



@implementation SMFInvocationCenteredMenuController
-(id)initWithTitles:(NSArray *)titles withInvocations:(NSArray *)invocations withTitle:(NSString *)title withDescription:(NSString *)description
{
    self=[super init];
    [self setListTitle:title];
    [self setPrimaryInfoText:description];
    int i,count=[titles count];
    BRTextMenuItemLayer *a;
    for(i=0;i<count;i++)
    {
        a=[BRTextMenuItemLayer menuItem];
        [a setTitle:[titles objectAtIndex:i]];
        [_items addObject:a];
        [_options addObject:[invocations objectAtIndex:i]];
    }
    return self;
}
-(void)itemSelected:(long)arg1
{
    if([[_options objectAtIndex:arg1] respondsToSelector:@selector(invoke)])
        [(NSInvocation *)[_options objectAtIndex:arg1]invoke];
    [[self stack]popController];
}
@end
