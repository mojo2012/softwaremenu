//
//  SMMainMenuControl.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

@implementation BRListControl (SMExtensions)

-(BOOL)widgetHidden
{
    return _widgetHidden;
}
-(void)setWidgetHidden:(BOOL)hide
{
    _widgetHidden=hide;
}

@end


@implementation SMMainMenuControl

-(BOOL)_previewColumnAtIndex:(long)arg1
{
    if ([SMPreferences mainMenuBlockPreview]) {
        return NO;
    }
    return [super _previewColumnAtIndex:arg1];
    
}

-(void)_reload
{
    [super _reload];

    CGRect a;
    a.size=[BRWindow maxBounds];
    NSString *path=[SMPreferences selectedExtension];
    if(![path isEqualToString:@"None"] && [[NSFileManager defaultManager]fileExistsAtPath:path] &&[SMPreferences mainMenuLoadPlugins])
    {
        /*
         *  Load the Plugin
         */
        [_controlBundle release];
        _controlBundle=[[NSBundle bundleWithPath:path] retain];
        [_controlBundle load];
        id<SMMextProtocol> pc=[[[_controlBundle principalClass] alloc]init];
        DLog(@"pc: %@",pc);
        /*
         *  Insert the new background control near the bottom of the stack
         */
        DLog(@"bc: %@",[pc backgroundControl]);
        [self insertControl:[pc backgroundControl] atIndex:1];
        
    }

    //Overwrite the AppleTV Logo (allways done
    [_logo setImage:[[SMThemeInfo sharedTheme]softwareMenuImageTiny]];
    
    /*
     *  Remove Gradient
     */
    if (![SMPreferences mainMenuKeepGradient]) {
        DLog(@"Removing _topGradient: %@",_topGradient);
        [_topGradient removeFromParent];
    }

    if (![SMPreferences mainMenuEdgeFade]) {
        DLog(@"Removing EdgeFade");
        [[[[[self controls]objectAtIndex:1]controls]objectAtIndex:0]setEdgeFadePercentage:0.0f];
    }
    DLog(@"Controls: %@",[self controls]);

    
}
-(BOOL)topGradientIsThere
{
    if ([[self controls] containsObject:_topGradient]) 
    {
        DLog(@"TopGradient is Present");
        return YES;
    }
    DLog(@"TopGradient is Not Present");
    return NO;
}

-(void)hideTopGradient
{
    if ([self topGradientIsThere]) 
    {
        DLog(@"Removing Top Gradient");
        [_topGradient removeFromParent];
    }
}
-(void)showTopGradient
{
    if (![self topGradientIsThere]) {
        DLog(@"Adding Top Gradient");
        [self insertControl:_topGradient atIndex:2];
    }
}


//-(BOOL)brEventAction:(id)event;
//{
//    if([self parent]!=[[[self parent] stack] peekController])
//        return NO;
//    if ([event remoteAction]==kBREventRemoteActionMenu) {
//        id<SMMextProtocol> pc=[[[_controlBundle principalClass] alloc] init];
//        id controller=[pc controller];
//        if(controller!=nil)
//            [[[BRApplicationStackManager singleton]stack]pushController:controller];
//        [controller release];
//        return YES;
//    }
//    return [super brEventAction:event];
//    
//}
@end
