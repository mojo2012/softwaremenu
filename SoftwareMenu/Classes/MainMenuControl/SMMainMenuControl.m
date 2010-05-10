//
//  SMMainMenuControl.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//


#import <QuartzCore/CATransaction.h>
#import <QuartzCore/CABasicAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>

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
@implementation BRApplianceColumnControl (SM)
-(void)test
{
    NSLog(@"appliance: %@",_appliance);
    NSLog(@"label: %@",_applianceLabel);
    NSLog(@"preview: %@",_preview);
}
-(id)appliance
{
    return _appliance;
}
@end


@implementation SMMainMenuControl

//-(id)actionForKey:(id)arg1
//{
//    DLog(@"Action FOr Key: %@",arg1);
//    return [super actionForKey:arg1];
//}
//-(id)actionForLayer:(id)arg1 forKey:(id)arg2
//{
//    id a = [super actionForLayer:arg1 forKey:arg2];
//    DLog(@"Action ForLayer:%@ ForKey:%@, return: %@",arg1,arg2,a);
//    
//    return a;
//}
-(BOOL)_previewColumnAtIndex:(long)arg1
{
   // DLog(@"actionse: %@",[self actions]);

    if ([SMPreferences mainMenuBlockPreview]) {
        return NO;
    }
    return [super _previewColumnAtIndex:arg1];
}
/*-(void)_previewTimerFired:(id)arg1
{
    NSLog(@"_columns: %@",_columns);
    int i,goodColumn=-1;
    for(i=0;i<[_columns count];i++)
    {
        //[(BRApplianceColumnControl *)[_columns objectAtIndex:i] appliance];
        if ([[(BRApplianceColumnControl *)[_columns objectAtIndex:i] appliance] isKindOfClass:[SoftwareMenuBase class]]) 
        {
            goodColumn=i;
        }
    }
    if (goodColumn!=-1) {
        NSLog(@"goodColumns: %i",goodColumn);
        [super _previewColumnAtIndex:goodColumn];
    }
    [super _previewTimerFired:arg1];
}*/
-(BRControl *)backgroundControl
{
    return _ctrl;
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
        //DLog(@"pc: %@",pc);
        /*
         *  Insert the new background control near the bottom of the stack
         */
        if (_ctrl!=nil) {
            [_ctrl release];
            _ctrl=nil;
        }
        _ctrl = [[pc backgroundControl] retain];
        //DLog(@"bc: %@",[pc backgroundControl]);
        [self insertControl:_ctrl atIndex:1];
        
    }
    NSString *path2=[[[SMPreferences selectedExtension] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"SMSlideshow.mext"];
    if(![path isEqualToString:path2] && [SMPreferences mainMenuBGImages] && [[NSFileManager defaultManager]fileExistsAtPath:path2] &&[SMPreferences mainMenuLoadPlugins])
    {
        /*
         *  Load the Plugin
         */
        [_controlBundle release];
        _controlBundle=[[NSBundle bundleWithPath:path2] retain];
        [_controlBundle load];
        id<SMMextProtocol> pc=[[[_controlBundle principalClass] alloc]init];
        //DLog(@"pc2: %@",pc);
        /*
         *  Insert the new background control near the bottom of the stack
         */
        if (_bg!=nil) {
            [_bg release];
            _bg=nil;
        }
        _bg = [[pc backgroundControl] retain];
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(animateOpacity:) userInfo:_bg repeats:NO];
        [self insertControl:_bg atIndex:1];
        
        
    }
    if(![path isEqualToString:@"None"] && [[NSFileManager defaultManager]fileExistsAtPath:path] &&[SMPreferences mainMenuLoadPlugins])
    {
        /*
         *  Load the Plugin
         */
        [_controlBundle release];
        _controlBundle=[[NSBundle bundleWithPath:path] retain];
        [_controlBundle load];
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
            [[[_categoryList controls]objectAtIndex:0]setEdgeFadePercentage:0.0f];
        //[_categoryList setSelectionLozengeStyle:3];


        
    }
     
    //DLog(@"Controls: %@",[self controls]);
   // DLog(@"actions: %@",[[self layer] animationKeys]);

    
}
-(void)animateOpacity:(BRControl *)obj
{
    DLog(@"animating: %@",_bg);
    if (_bg!=nil && FALSE) {
        
//        CALayer *theLayer = [_bg layer];
//        [CATransaction setValue:[NSNumber numberWithFloat:10.0f]
//                         forKey:kCATransactionAnimationDuration];
//        //[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//        [CATransaction setAnimationDuration:10.0f];
//        [CATransaction begin];
//        DLog(@"Adding Animation %lf",[CATransaction animationDuration]);
//
////theLayer.zPosition=200.0;
//        theLayer.opacity=0.0;
//        [CATransaction commit];
        CABasicAnimation *theAnimation;
        
        
        
        theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
        
        theAnimation.duration=3.5;
        
        theAnimation.repeatCount=1;
        
        theAnimation.autoreverses=NO;
        
        theAnimation.fromValue=[NSNumber numberWithFloat:[_bg opacity]];
        
        theAnimation.toValue=[NSNumber numberWithFloat:0.0];
        theAnimation.removedOnCompletion=NO;
        [_bg addAnimation:theAnimation forKey:@"animateOpacity"];
        [_bg setOpacity:0.0f];
//        DLog(@"removed: %d",[theAnimation removedOnCompletion]);
        
    }
    DLog(@"animating opacity for: %@ %@",obj,_bg);
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


-(BOOL)brEventAction:(id)event;
{
    if([self parent]!=[[[self parent] stack] peekController])
        return NO;
    if ([event remoteAction]==kBREventRemoteActionMenu) {
        id<SMMextProtocol> pc=[[[_controlBundle principalClass] alloc] init];
        id controller=[pc controller];
        if(controller!=nil)
            [[[BRApplicationStackManager singleton]stack]pushController:controller];
        [controller release];
        return YES;
    }
    return [super brEventAction:event];
    
}
@end
