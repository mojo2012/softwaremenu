//
//  SMPluginMediaAsset.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMPluginMediaAsset.h"


@implementation SMPluginMediaAsset
-(id)initWithApplianceDictionary:(SMApplianceDictionary *)applianceDict
{
    self=[super init];
    [self setApplianceDictionary:applianceDict];
    return self;
    
}
-(void)setApplianceDictionary:(SMApplianceDictionary *)applianceDict
{
    [_applianceDict release];
    _applianceDict = [applianceDict retain];
}
-(SMApplianceDictionary *)applianceDictionary
{
    return _applianceDict;
}
-(id)summary
{
    return [_applianceDict shortDescription];
}
-(id)title
{
    if ([_applianceDict formatedReleaseDate])
        return [_applianceDict formatedReleaseDate];
    return [_applianceDict name];
}
-(id)coverArt
{
    if (!_image) {
        return [[SMThemeInfo sharedTheme] packageImage];
    }
    return _image;
}
-(NSDictionary *)orderedDictionary
{
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    NSMutableArray *objects=[[NSMutableArray alloc]init];
    if ([_applianceDict displayVersion]) {
        [keys addObject:@"OnlineVersion"];
        [objects addObject:[_applianceDict displayVersion]];
    }
    else if ([_applianceDict onlineVersionString]) {
        [keys addObject:@"OnlineVersion"];
        [objects addObject:[_applianceDict onlineVersionString]];
    }
    if ([_applianceDict installedVersion]) {
        [keys addObject:@"InstalledVersion"];
        [objects addObject:[_applianceDict installedVersion]];
    }
    if ([_applianceDict developer])
    {
        [keys addObject:@"Developer"];
        [objects addObject:[_applianceDict developer]];

    }
    NSMutableDictionary *a=[[NSMutableDictionary alloc] init];
    if([self title])
        [a setObject:[self title] forKey:METADATA_TITLE];
    if([self summary])
        [a setObject:[self summary] forKey:METADATA_SUMMARY];
//    if ([_meta objectForKey:METADATA_CUSTOM_KEYS]!=nil && [_meta objectForKey:METADATA_CUSTOM_OBJECTS]!=nil) 
    {
        [a setObject:keys forKey:METADATA_CUSTOM_KEYS];
        [a setObject:objects forKey:METADATA_CUSTOM_OBJECTS];
        
    }
    NSLog(@"info Dict: %@",a);
    return a;
}
@end
