//
//  SMSSettings.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 5/8/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMSSettings.h"
#define SMSTD  @"transitionDuration"
#define SMSTS  @"transitionStyle"
#define SMSID  @"imageDuration"
#define SMSF   @"folder"
#define SMSO   @"opacity"
#define SMSR   @"randomize"
#define SMSAC  @"autoRotateTransitions"
typedef enum _SMRowType{
    transitionDuration=0,
    transitionEffect,
    imageDuration,
    randomize,
    selectFolder,
    opacity,
    autoRotate,
    
} SMRowType;
@class SMPreferences;
@implementation SMSSettings
+ (void)setInteger:(int)theInt forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt], smslideshowDomain);
	CFPreferencesAppSynchronize(smslideshowDomain);
}
+ (int)integerForKey:(NSString *)theKey
{
	Boolean temp;
	int outInt = CFPreferencesGetAppIntegerValue((CFStringRef)theKey, smslideshowDomain, &temp);
	return outInt;
	
}
+ (NSArray *)arrayForKey:(NSString *)theKey
{
    NSArray  *myArray = [(NSArray *)CFPreferencesCopyAppValue((CFStringRef)theKey, smslideshowDomain) autorelease];
    if (myArray==nil) {
        return [NSArray array];
    }
    return (NSArray *)myArray;
}
+ (void)setDictionary:(NSDictionary *)inputDict forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFDictionaryRef)inputDict, smslideshowDomain);
	CFPreferencesAppSynchronize(smslideshowDomain);
	//CFRelease(inputDict);
}
+ (NSDictionary *)dictionaryForKey:(NSString *)theKey
{
    NSDictionary  *myDictionary = [(NSDictionary *)CFPreferencesCopyAppValue((CFStringRef)theKey, smslideshowDomain) autorelease];
    if (myDictionary==nil) {
        return [NSDictionary dictionary];
    }
    return (NSDictionary *)myDictionary;
}
+(NSString *)stringForKey:(NSString *)theKey
{
    CFPreferencesAppSynchronize(smslideshowDomain);
    NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, smslideshowDomain);
    return (NSString *)myString;
}
+ (void)setString:(NSString *)inputString forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFStringRef)inputString, smslideshowDomain);
	CFPreferencesAppSynchronize(smslideshowDomain);
	//CFRelease(inputString);
}
+(NSNumber *)numberForKey:(NSString *)theKey
{
    CFPreferencesAppSynchronize(smslideshowDomain);
    NSNumber *number = (NSNumber *) CFPreferencesCopyAppValue((CFStringRef)theKey, smslideshowDomain);
    return number;
}
+(void)setNumber:(NSNumber *)number forKey:(NSString *)key
{
    CFPreferencesSetAppValue((CFStringRef)key, (CFNumberRef)number, smslideshowDomain);
	CFPreferencesAppSynchronize(smslideshowDomain);
}
+(BOOL)boolForKey:(NSString *)theKey
{
	Boolean temp;
	Boolean outBool = CFPreferencesGetAppBooleanValue((CFStringRef)theKey, smslideshowDomain, &temp);
	return outBool;
}
+ (void)setBool:(BOOL)inputBool forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithBool:inputBool], smslideshowDomain);
	CFPreferencesAppSynchronize(smslideshowDomain);
}
+(float)transitionDuration
{
    NSNumber *number = [SMSSettings numberForKey:SMSTD];
    float tf;
    if (number!=nil)
        tf=[number floatValue];
    else
        tf=3.5f;
    if (tf<0 || tf>5) {
        tf=3.5f;
    }
    return tf;
}
+(void)setTransitionDuration:(float)td
{
    if (td<0 || td>5) {
        td=3.5f;
    }
    NSNumber *number= [NSNumber numberWithFloat:td];
    [SMSSettings setNumber:number forKey:SMSTD];
}
+(NSArray *)allowedTransitions
{
    return [NSArray arrayWithObjects:@"fade",@"moveIn",@"reveal",@"push",nil];
}
+(SlideshowTransitionStyle)transitionStyle
{
    SlideshowTransitionStyle te=[SMSSettings integerForKey:SMSTS];

    return te;
}
+(void)setTransitionStyle:(SlideshowTransitionStyle)style
{
    style=(style %NumberOfSlideshowViewTransitionStyles);
    [SMSSettings setInteger:style forKey:SMSTS];
}
+(int)imageDuration
{
    int d=[SMSSettings integerForKey:SMSID];
    if (d<5) {
        d=30;
    }
    return d;
}
+(float)opacity
{
    NSNumber *number = [SMSSettings numberForKey:SMSO];
    float tf;
    if (number!=nil)
        tf=[number floatValue];
    else
        tf=0.3f;
    if (tf<0.0f || tf>1.0f) {
        tf=0.3f;
    }
    return tf;
}
+(void)setOpacity:(float)o
{
    [SMSSettings setNumber:[NSNumber numberWithFloat:o] forKey:SMSO];
}

+(void)setImageDuration:(int)d
{
    if(d>=5)
    {
        [SMSSettings setInteger:d forKey:SMSID];
    }
}
+(void)setImageFolder:(NSString *)folder
{
    BOOL isDir;
    if([[NSFileManager defaultManager]fileExistsAtPath:folder isDirectory:&isDir]&&isDir)
        [SMSSettings setString:folder forKey:SMSF];
}
+(NSString *)imageFolder
{
    NSString *folder=[SMSSettings stringForKey:SMSF];
    if (folder==nil) {
        folder=[SMPreferences photoFolderPath];
    }
    return folder;
}
+(BOOL)autoRotateTransitions
{
    return [SMSSettings boolForKey:SMSAC];
}
+(void)setAutoRotateTransitions:(BOOL)ar
{
    [SMSSettings setBool:ar forKey:SMSAC];
}
+(BOOL)randomizeOrder
{
    return [SMSSettings boolForKey:SMSR];
}
+(void)setRandomizeOrder:(BOOL)r
{
    [SMSSettings setBool:r forKey:SMSR];
}

-(NSString *)stringForTransition:(SlideshowTransitionStyle)trans
{
    NSString *name = nil;
    switch (trans) {
        case SlideshowViewFadeTransitionStyle:
            name=@"Fade";
            break;
        case SlideshowViewMoveInTransitionStyle:
            name=@"Move In";
            break;
        case SlideshowViewPushTransitionStyle:
            name=@"Push";
            break;
        case SlideshowViewRevealTransitionStyle:
            name=@"Reveal";
            break;
            
            // Core Image's standard set of transition filters
        case SlideshowViewCopyMachineTransitionStyle:
            name=@"Copy Machine";
            break;
        case SlideshowViewDisintegrateWithMaskTransitionStyle:
            name=@"Disintegrate";
            break;
        case SlideshowViewDissolveTransitionStyle:
            name=@"Dissolve";
            break;
        case SlideshowViewFlashTransitionStyle:
            name=@"Flash";
            break;
        case SlideshowViewModTransitionStyle:
            name=@"Mod";
            break;
        case SlideshowViewPageCurlTransitionStyle:
            name=@"Page Curl";
            break;
        case SlideshowViewRippleTransitionStyle:
            name=@"Ripple";
            break;
        case SlideshowViewSwipeTransitionStyle:
            name=@"Swipe";
            break;
            
        default:
            name=@"Swipe";
            break;
    }
    
    return name;
    
}
-(id)init
{
    self=[super init];
    [self setListTitle:BRLocalizedString(@"Slideshow Settings",@"Slideshow Settings")];
    
    id anItem=[BRTextMenuItemLayer menuItem];
    [anItem setTitle:BRLocalizedString(@"Transition Duration",@"Transition Duration")];
    [_items addObject:anItem];
    [_options addObject:[NSNumber numberWithInt:transitionDuration]];
    
    anItem=[BRTextMenuItemLayer menuItem];
    [anItem setTitle:BRLocalizedString(@"Transition Effect",@"Transition Effect")];
    [_items addObject:anItem];
    [_options addObject:[NSNumber numberWithInt:transitionEffect]];
    
    anItem=[BRTextMenuItemLayer menuItem];
    [anItem setTitle:BRLocalizedString(@"Auto Rotate Transitions",@"Auto Rotate Transitions")];
    [_items addObject:anItem];
    [_options addObject:[NSNumber numberWithInt:autoRotate]];
    
    anItem=[BRTextMenuItemLayer menuItem];
    [anItem setTitle:BRLocalizedString(@"Image Duration",@"Image Duration")];
    [_items addObject:anItem];
    [_options addObject:[NSNumber numberWithInt:imageDuration]];
    
    anItem=[BRTextMenuItemLayer menuItem];
    [anItem setTitle:BRLocalizedString(@"Randomize Image Order",@"Randomize Image Order")];
    [_items addObject:anItem];
    [_options addObject:[NSNumber numberWithInt:randomize]];
    
    anItem=[BRTextMenuItemLayer menuItem];
    [anItem setTitle:BRLocalizedString(@"Image Opacity",@"Image Opacity")];
    [_items addObject:anItem];
    [_options addObject:[NSNumber numberWithInt:opacity]];
    
    anItem=[BRTextMenuItemLayer menuItem];
    [anItem setTitle:BRLocalizedString(@"Select Folder",@"Select Folder")];
    [_items addObject:anItem];
    [_options addObject:[NSNumber numberWithInt:selectFolder]];
    return self;
    
}
-(id)itemForRow:(long)row
{
    if (row>=[self itemCount]) 
        return nil;
    SMRowType rowT = [[_options objectAtIndex:row] intValue];
    BRTextMenuItemLayer *item = [_items objectAtIndex:row];
    if (rowT==transitionDuration)
        [item setRightJustifiedText:[NSString stringWithFormat:@"%.1f sec",[SMSSettings transitionDuration],nil]];
    else if(rowT==transitionEffect)
        [item setRightJustifiedText:[self stringForTransition:[SMSSettings transitionStyle]]];
    else if(rowT==imageDuration)
        [item setRightJustifiedText:[NSString stringWithFormat:@"%i sec",[SMSSettings imageDuration],nil]];
    else if(rowT==selectFolder)
        [item setRightJustifiedText:[[SMSSettings imageFolder] lastPathComponent]];
    else if(rowT==randomize)
        [item setRightJustifiedText:([SMSSettings randomizeOrder]?@"YES":@"NO")];
    else if(rowT==opacity)
        [item setRightJustifiedText:[NSString stringWithFormat:@"%.1f",[SMSSettings opacity],nil]];
    else if(rowT==autoRotate)
        [item setRightJustifiedText:([SMSSettings autoRotateTransitions]?@"YES":@"NO")];
    return item;
}
-(void)itemSelected:(long)row
{
    if (row>=[self itemCount]) 
        return;
    SMRowType rowT = [[_options objectAtIndex:row] intValue];
    if (rowT==transitionDuration) 
    {
        float t = [SMSSettings transitionDuration]+0.5f;
        if (t>5.0f) {
            t=0.0f;
        }
        [SMSSettings setTransitionDuration:t];
    }
        
    else if(rowT==transitionEffect)
    {
        SlideshowTransitionStyle newStyle= (([SMSSettings transitionStyle]+1) %NumberOfSlideshowViewTransitionStyles);
        [SMSSettings setTransitionStyle:newStyle];
    }
    else if(rowT==randomize)
    {
        [SMSSettings setRandomizeOrder:![SMSSettings randomizeOrder]];
    }
    else if(rowT==imageDuration)
    {
        int t = [SMSSettings imageDuration]+10;
        if (t>60) {
            t=10;
        }
        [SMSSettings setImageDuration:t];
    }
    else if(rowT==opacity)
    {
        float t = [SMSSettings opacity]+0.1f;
        if (t>1.0f) {
            t=0.0f;
        }
        [SMSSettings setOpacity:t];
    }
    else if(rowT==selectFolder)
    {
        id a =[[SMFSimpleDirectoryChooserController alloc]initWithFolder:@"/Users/frontrow" delegate:self topFolder:@"/Users/frontrow"];
        [[self stack] pushController:a];
        [a release];
    }
    else if(rowT==autoRotate)
        [SMSSettings setAutoRotateTransitions:![SMSSettings autoRotateTransitions]];
    [[self list]reload];
}
-(void)leftActionForRow:(long)row
{
    SMRowType rowT = [[_options objectAtIndex:row] intValue];
    if(rowT==transitionEffect)
    {
        SlideshowTransitionStyle currentStyle=[SMSSettings transitionStyle];
        if (currentStyle==0) {
            currentStyle=NumberOfSlideshowViewTransitionStyles;
        }
        SlideshowTransitionStyle newStyle= ((currentStyle-1) %NumberOfSlideshowViewTransitionStyles);
        [SMSSettings setTransitionStyle:newStyle];
    }
    else if(rowT==imageDuration)
    {
        int t = [SMSSettings imageDuration]-10;
        if (t<10) {
            t=60;
        }
        [SMSSettings setImageDuration:t];
    }
    else if(rowT==transitionDuration)
    {
        float t = [SMSSettings transitionDuration]-0.5f;
        if (t<0.0f) {
            t=5.0f;
        }
        [SMSSettings setTransitionDuration:t];
    }
    else if(rowT==opacity)
    {
        float t = [SMSSettings opacity]-0.1f;
        if (t<0.0f) {
            t=1.0f;
        }
        [SMSSettings setOpacity:t];
    }
    
    [[self list]reload];
}
-(void)rightActionForRow:(long)row
{
    SMRowType rowT = [[_options objectAtIndex:row] intValue];
    if(rowT==transitionEffect)
        [self itemSelected:row];
    else if(rowT==imageDuration)
        [self itemSelected:row];
    else if(rowT==transitionDuration)
        [self itemSelected:row];
    else if(rowT==opacity)
        [self itemSelected:row];
    [[self list]reload]; 
}
-(void)dirSelected:(NSString *)dir
{
    [SMSSettings setImageFolder:dir];
    [[self list] reload];
}
@end
