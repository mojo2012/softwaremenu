//
//  SMWeatherController.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/16/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMWeatherController.h"

NSString *kWeatherDefaultKey=@"kWeatherDefaultKey";
NSString *kWeatherWatchKey=@"kWeatherWatchKey";
NSString *kWeatherUSUnitsKey=@"kWeatherUSUnitsKey";
NSString *kWeatherTimeZoneKey=@"kWeatherTimeZoneKey";
NSString *kWeatherRemoveKey=@"kWeatherRemoveKey";
NSString *kWeatherCityKey=@"city";

@implementation SMWeatherController


+ (void)setInteger:(int)theInt forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt], smweatherDomain);
	CFPreferencesAppSynchronize(smweatherDomain);
}
+ (int)integerForKey:(NSString *)theKey
{
	Boolean temp;
	
	int outInt = CFPreferencesGetAppIntegerValue((CFStringRef)theKey, smweatherDomain, &temp);
	return outInt;
	
}
+ (NSArray *)arrayForKey:(NSString *)theKey
{
    NSArray  *myArray = [(NSArray *)CFPreferencesCopyAppValue((CFStringRef)theKey, smweatherDomain) autorelease];
    if (myArray==nil) {
        return [NSArray array];
    }
    return (NSArray *)myArray;
}
+ (void)setDictionary:(NSDictionary *)inputDict forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFDictionaryRef)inputDict, smweatherDomain);
	CFPreferencesAppSynchronize(smweatherDomain);
	//CFRelease(inputDict);
}
+ (NSDictionary *)dictionaryForKey:(NSString *)theKey
{
    NSDictionary  *myDictionary = [(NSDictionary *)CFPreferencesCopyAppValue((CFStringRef)theKey, smweatherDomain) autorelease];
    if (myDictionary==nil) {
        return [NSDictionary dictionary];
    }
    return (NSDictionary *)myDictionary;
}
+(NSString *)stringForKey:(NSString *)theKey
{
    CFPreferencesAppSynchronize(smweatherDomain);
    NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, smweatherDomain);
    return (NSString *)myString;
}
+(BOOL)boolForKey:(NSString *)theKey
{
	Boolean temp;
	Boolean outBool = CFPreferencesGetAppBooleanValue((CFStringRef)theKey, smweatherDomain, &temp);
	return outBool;
}
+ (void)setBool:(BOOL)inputBool forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithBool:inputBool], smweatherDomain);
	CFPreferencesAppSynchronize(smweatherDomain);
}
+(NSDictionary *)Locations
{
    return [SMWeatherController dictionaryForKey:@"Locations"];
}
+(void)setLocations:(NSDictionary *)locations
{
    [SMWeatherController setDictionary:locations forKey:@"Locations"];
}
+(int)yWeatherCode
{
    int location=[SMWeatherController integerForKey:@"Location"];
    if (location==nil) {
        location=615702;
    }
    return location;
}
+(NSString *)tzForCode:(int)code
{
    NSDictionary *locs = [[SMWeatherController Locations] objectForKey:[NSString stringWithFormat:@"%i",code,nil]];
    if ([[locs allKeys] containsObject:kWeatherTimeZoneKey]) {
        DLog(@"Time Zone for code: %i is: %@",code,[locs objectForKey:kWeatherTimeZoneKey]);
        return [locs objectForKey:kWeatherTimeZoneKey]; 
    }
    return nil;
}
+(void)setYWeatherCode:(int)code
{
    [SMWeatherController setInteger:code forKey:@"Location"];
}
+(void)setDefaultYWeatherCode
{
    [SMWeatherController setInteger:615702 forKey:@"Location"];
}
+(int)refreshMinutes
{
    int time=[SMWeatherController integerForKey:@"Time"];
    if (time==nil) {
        time=60;
    }
    return time;
}
+(void)setRefreshMinutes:(int)min
{
    [SMWeatherController setInteger:min forKey:@"Time"];
}
+(BOOL)USUnitsForCode:(int)code
{
    NSString *scode = [NSString stringWithFormat:@"%i",code,nil];
    NSDictionary *obj=[[SMWeatherController Locations] objectForKey:scode];
    DLog(@"object: %@",obj);
    DLog(@"%@, %@, %@",
         [NSNumber numberWithBool:[[obj allKeys] containsObject:kWeatherDefaultKey]],
         [NSNumber numberWithBool:![[obj objectForKey:kWeatherDefaultKey] boolValue]],
         [NSNumber numberWithBool:[[obj allKeys] containsObject:kWeatherUSUnitsKey]]);
    if (obj==nil) 
        return NO;
    if ([[obj allKeys] containsObject:kWeatherDefaultKey] && 
        ![[obj objectForKey:kWeatherDefaultKey] boolValue] && 
        [[obj allKeys] containsObject:kWeatherUSUnitsKey]) 
    {
        DLog(@"Use Custom Units for code: %i",code);
        return [[obj objectForKey:kWeatherUSUnitsKey]boolValue];
    }
    else {
        return [SMWeatherController USUnits];
    }

}
+(BOOL)USUnits
{
    return [SMWeatherController boolForKey:@"USUnits"];
}
+(void)setUSUnits:(BOOL)units
{
    [SMWeatherController setBool:units forKey:@"USUnits"];
}
- (void)save
{
    NSString *scode = [NSString stringWithFormat:@"%i",_code,nil];
    NSMutableDictionary *locations = [[SMWeatherController Locations]mutableCopy];
    [locations setObject:_location forKey:scode];
    [SMWeatherController setLocations:locations];
}
- (id)initWithCode:(int)code
{
    self=[super init];
    NSString *scode = [NSString stringWithFormat:@"%i",code,nil];
    _location = [[[SMWeatherController Locations] objectForKey:scode] mutableCopy];
    
    if (_location == nil) {
        ALog(@"No Information Found for code: %i",code);
        return nil;
    }
    [_location retain];
    _code = code;
    NSString *title = [_location objectForKey:kWeatherCityKey]; 
    [self setListTitle:title];
    NSArray *keys = [_location allKeys];
    /*
     *  Setting Defaults
     */
    if (![keys containsObject:kWeatherTimeZoneKey]) {
        [_location setObject:@"Europe/Paris" forKey:kWeatherTimeZoneKey];
    }
    if (![keys containsObject:kWeatherUSUnitsKey]) {
        [_location setObject:[NSNumber numberWithBool:NO] forKey:kWeatherUSUnitsKey];
    }
    if (![keys containsObject:kWeatherDefaultKey]) {
        [_location setObject:[NSNumber numberWithBool:YES] forKey:kWeatherDefaultKey];
    }
    if (![keys containsObject:kWeatherWatchKey]) {
        [_location setObject:[NSNumber numberWithBool:NO] forKey:kWeatherWatchKey];
    }
    /*
     *  Saving
     */
    [self save];
    /*
     *  Setting UI
     */
    BRTextMenuItemLayer * item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Default Settings",@"Default Settings")];
    [_items addObject:item];
    [_options addObject:kWeatherDefaultKey];
    
    item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Units",@"Units")];
    [_items addObject:item];
    [_options addObject:kWeatherUSUnitsKey];
    
    item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Time Mode",@"Time Mode")];
    [_items addObject:item];
    [_options addObject:kWeatherWatchKey];
    
    item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"Time Zone",@"Time Zone")];
    [_items addObject:item];
    [_options addObject:kWeatherTimeZoneKey];
    
    item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"Remove",@"Remove")];
    [_items addObject:item];
    [_options addObject:kWeatherRemoveKey];
    
    [[self list] setDatasource:self];
    return self;
}


-(void)controlWasActivated
{
    if([self respondsToSelector:@selector(everyLoad)])
        [self everyLoad];
    [super controlWasActivated];
}
-(id)itemForRow:(long)row
{
    
    if (row<[_items count]) {
        BRTextMenuItemLayer *item = [_items objectAtIndex:row];
        NSString *option=[_options  objectAtIndex:row];
        if (option     == kWeatherTimeZoneKey) {
            [item setRightJustifiedText:[_location objectForKey:kWeatherTimeZoneKey]];
        }
        else if(option == kWeatherDefaultKey)
        {
            [item setRightJustifiedText:([[_location objectForKey:kWeatherDefaultKey] boolValue]?@"YES":@"NO")];
        }
        else if(option == kWeatherUSUnitsKey)
        {
            [item setRightJustifiedText:([[_location objectForKey:kWeatherUSUnitsKey] boolValue]?@"Fahrenheit":@"Celsius")];
        }
        else if(option == kWeatherWatchKey)
        {
            [item setRightJustifiedText:([[_location objectForKey:kWeatherWatchKey] boolValue]?@"Watch Mode":@"Loaded Mode")];
        }
        else {
            //DLog(@"%@\n%@\n%@\n%@\n%@",kWeatherTimeZoneKey,kWeatherDefaultKey,kWeatherUSUnitsKey,kWeatherWatchKey,kWeatherRemoveKey);
            //DLog(@"current option: %@",option);
        }
        return item;
    }
    return nil;
}
-(void)itemSelected:(long)row
{
    if (row>=[_items count])
        return;
    NSString *option=[_options  objectAtIndex:row];
    if (option == kWeatherDefaultKey) {
        [_location setObject:[NSNumber numberWithBool:![[_location objectForKey:kWeatherDefaultKey]boolValue]] forKey:kWeatherDefaultKey];
        [self save];
    }
    else if(option == kWeatherUSUnitsKey)
    {
        [_location setObject:[NSNumber numberWithBool:![[_location objectForKey:kWeatherUSUnitsKey]boolValue]] forKey:kWeatherUSUnitsKey];
        [self save];
    }
    else if(option == kWeatherWatchKey)
    {
        [_location setObject:[NSNumber numberWithBool:![[_location objectForKey:kWeatherWatchKey]boolValue]] forKey:kWeatherWatchKey];
        [self save];
    }
    else if(option == kWeatherWatchKey)
    {
        [_location setObject:[NSNumber numberWithBool:![[_location objectForKey:kWeatherWatchKey]boolValue]] forKey:kWeatherWatchKey];
        [self save];
    }
    else if(option == kWeatherTimeZoneKey)
    {
        NSArray *timeZones=[NSTimeZone knownTimeZoneNames];
        NSMutableArray *invocations=[[NSMutableArray alloc] init];
        int i,count=[timeZones count];
        for(i=0;i<count;i++)
        {
            id anInvocation = [SMFInvocationCenteredMenuController invocationsForObject:self
                                                                        withSelectorVal:@"setTimeZone:forCode:"
                                                                          withArguments:[NSArray arrayWithObjects:[timeZones objectAtIndex:i],[NSNumber numberWithInt:_code],nil]];
            [invocations addObject:anInvocation];
        }
        id a =[[SMFInvocationCenteredMenuController alloc]initWithTitles:timeZones
                                                         withInvocations:invocations 
                                                               withTitle:[NSString stringWithFormat:@"Select Time Zone for: %@",[_location objectForKey:kWeatherCityKey],nil] 
                                                         withDescription:@"Please select a time zone"];
        [[self stack]pushController:a];
        [a release];
    }
    else if(option == kWeatherRemoveKey)
    {
        NSArray *titles=[NSArray arrayWithObjects:
                         BRLocalizedString(@"Remove",@"Remove"),
                         BRLocalizedString(@"Do Not Remove",@"Do Not Remove"),
                         nil];
        id anInvocation = [SMFInvocationCenteredMenuController invocationsForObject:self
                                                                    withSelectorVal:@"remove:"
                                                                      withArguments:[NSArray arrayWithObject:[NSNumber numberWithInt:_code]]];
        NSArray *invocations = [NSMutableArray arrayWithObjects:anInvocation,@"b",nil];
        id a= [[SMFInvocationCenteredMenuController alloc] initWithTitles:titles
                                                          withInvocations:invocations
                                                                withTitle:[NSString stringWithFormat:@"Remove %@?",[_location objectForKey:kWeatherCityKey],nil]
                                                          withDescription:BRLocalizedString(@"This will permanently remove the selected city",@"This will permanently remove the selected city")];
        
        [[self stack] pushController:a];
        [a release];  
    }
    
    
    [[self list]reload];
}
-(void)setTimeZone:(NSString *)tz forCode:(NSNumber *)code
{
    if (_location!=nil) {
        [_location setObject:tz forKey:kWeatherTimeZoneKey];
        [self save];
        [[self list]reload];
    }
}
-(void)remove:(NSNumber *)code
{
    NSMutableDictionary *locations = [[SMWeatherController Locations] mutableCopy];
    [locations removeObjectForKey:[code stringValue]];
    [SMWeatherController setLocations:locations];
    if ([SMWeatherController yWeatherCode]==[code intValue]) {
        NSArray *keys = [locations allKeys];
        if ([keys count]==0) {
            [SMWeatherController setDefaultYWeatherCode];
        }
        else {
            [SMWeatherController setYWeatherCode:[[keys objectAtIndex:0] intValue]];
        }
    }
    [[self stack]popController];
}
-(void)dealloc
{
    [_location release];
    [super dealloc];
}
@end
