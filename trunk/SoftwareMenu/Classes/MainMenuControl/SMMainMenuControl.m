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
//-(void)_previewUpdated:(id)arg1
//{
//    [super _previewUpdated:arg1];
//}
//-(void)_previewTimerFired:(id)arg1
//{
//    [super _previewTimerFired:arg1];
//}
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
//    BOOL parade=TRUE;
//    BOOL still=FALSE;
//    BOOL player=FALSE;
    CGRect a;
    a.size=[BRWindow maxBounds];
    NSString *path=[SMPreferences selectedExtension];
    if(![path isEqualToString:@"None"] && [[NSFileManager defaultManager]fileExistsAtPath:path] &&[SMPreferences mainMenuLoadPlugins])
    {
        [_controlBundle release];
        _controlBundle=[[NSBundle bundleWithPath:path] retain];
        [_controlBundle load];
        id<SMMextProtocol> pc=[[[_controlBundle principalClass] alloc]init];
        [self insertControl:[pc backgroundControl] atIndex:1];
        //[[[BRApplicationStackManager singleton] stack] pushController:[BRController controllerWithContentControl:[pc backgroundControl]]];
        
    }

    
    
    //changing Logo
//    id image=[[BRImageControl alloc] init];
//    a=[self frame];
//    a.origin.x=a.origin.x+a.size.width*0.12;
//    a.origin.y=a.origin.y+[BRWindow maxBounds].height*0.5;
//    a.size.width=a.size.width*0.13;
//    a.size.height=a.size.height*0.22;
//    [image setImage:[[SMThemeInfo sharedTheme] softwareMenuImageTiny]];
//    [image setFrame:a];
//    [image setAutomaticDownsample:YES];
//
//    [_logo removeFromParent];
//    [_logo release];
    [_logo setImage:[[SMThemeInfo sharedTheme]softwareMenuImageTiny]];
//    [self insertControl:_logo atIndex:6];
    [_topGradient removeFromParent];
    //[_barGlow removeFromParent];
    
//    [[[self controls] objectAtIndex:0] removeFromParent];
//    [[[self controls] objectAtIndex:6] removeFromParent];
    
//    CGRect  frame=[[[self controls] objectAtIndex:4]frame];
//    NSLog(@"frame of obj: %@, %lf, %lf",[[self controls] objectAtIndex:4],frame.size.width,frame.size.height);
    //NSLog(@"controls in activated2: %@",[self controls]);
    //NSLog(@"list controls widgetHidden: %@",([[[self controls] objectAtIndex:1] widgetHidden]?@"YES":@"NO"));
    //[[[self controls] objectAtIndex:1]setWidgetHidden:YES];
//    [[[self controls]objectAtIndex:1]setBottomMargin:0.0f];
//    [[[self controls]objectAtIndex:1]setTopMargin:0.0f];
    NSLog(@"edge fade: %lf",[[[[[self controls]objectAtIndex:1]controls]objectAtIndex:0]edgeFadePercentage]);
    if (![SMPreferences mainMenuEdgeFade]) {
        [[[[[self controls]objectAtIndex:1]controls]objectAtIndex:0]setEdgeFadePercentage:0.0f];
    }
    NSLog(@"edge fade: %lf",[[[[[self controls]objectAtIndex:1]controls]objectAtIndex:0]edgeFadePercentage]);

    
}
//-(void)_reload
//{
//    [super _reload];
//}
-(BOOL)brEventAction:(id)event;
{
    if([self parent]!=[[[self parent] stack] peekController])
        return NO;
    if ([event remoteAction]==kBREventRemoteActionMenu) {
//        [[[BRApplicationStackManager singleton]stack]pushController:[[SMMainMenuPU alloc]init]];
        id<SMMextProtocol> pc=[[[_controlBundle principalClass] alloc] init];
        
        id controller=[pc controller];
        //[controller addControl:_logo];
        if(controller!=nil)
            [[[BRApplicationStackManager singleton]stack]pushController:controller];
        [controller release];
        return YES;
    }
    return [super brEventAction:event];
    
}
@end
