//
//  SMSSettings.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 5/8/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMSSettings.h"
#define SMSTD  @"transitionDuration"
#define SMSTE  @"transitionEffect"
#define SMSID  @"imageDuration"
#define SMSF   @"folder"
#define SMSO   @"opacity"
#define SMSR   @"randomize"
typedef enum _SMRowType{
    transitionDuration=0,
    transitionEffect,
    imageDuration,
    randomize,
    selectFolder,
    opacity,
    
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
+(NSString *)transitionEffect
{
    NSArray *allowedTransitions=[SMSSettings allowedTransitions];
    NSString *te=[SMSSettings stringForKey:SMSTE];
    if (te==nil || ![allowedTransitions containsObject:te]) {
        te=@"fade";
    }
    return te;
}
+(void)setTransitionEffect:(NSString *)effect
{
    NSArray *allowedTransitions=[SMSSettings allowedTransitions];
    if ([allowedTransitions containsObject:effect]) {
        [SMSSettings setString:effect forKey:SMSTE];
    }
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
    [SMSSettings setNumber:[NSNumber numberWithInt:o] forKey:SMSO];
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
+(BOOL)randomizeOrder
{
    return [SMSSettings boolForKey:SMSR];
}
+(void)setRandomizeOrder:(BOOL)r
{
    [SMSSettings setBool:r forKey:SMSR];
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
        [item setRightJustifiedText:[SMSSettings transitionEffect]];
    else if(rowT==imageDuration)
        [item setRightJustifiedText:[NSString stringWithFormat:@"%i sec",[SMSSettings imageDuration],nil]];
    else if(rowT==selectFolder)
        [item setRightJustifiedText:[[SMSSettings imageFolder] lastPathComponent]];
    else if(rowT==randomize)
        [item setRightJustifiedText:([SMSSettings randomizeOrder]?@"YES":@"NO")];
    else if(rowT==opacity)
        [item setRightJustifiedText:[NSString stringWithFormat:@"%.1f",[SMSSettings opacity],nil]];
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
        NSString *effect = [SMSSettings transitionEffect];
        NSArray *allowedTransitions = [SMSSettings allowedTransitions];
        int newI=0;
        if ([allowedTransitions containsObject:effect]) {
            int i = [allowedTransitions indexOfObject:effect];
            newI=i+1;
            if (newI==[allowedTransitions count]) {
                newI=0;
            }
        }
        [SMSSettings setTransitionEffect:[allowedTransitions objectAtIndex:newI]];
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
    [[self list]reload];
}
-(void)dirSelected:(NSString *)dir
{
    [SMSSettings setImageFolder:dir];
    [[self list] reload];
}
@end
