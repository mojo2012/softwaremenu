//
//  SMFPluginAsset.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/23/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMFPluginAsset.h"
#define META_DEV_KEY        @"META_DEV_KEY"
#define META_INSTALLED_KEY  @"META_INSTALLED_KEY"
#define META_ONLINE_KEY     @"META_ONLINE_KEY"

@implementation SMFPluginAsset
-(void)setDeveloper:(NSString *)developer
{
    [_meta setObject:developer forKey:META_DEV_KEY];
}
-(NSString *)developer
{
    return [_meta objectForKey:META_DEV_KEY];
}
-(void)setInstalledVersion:(NSString *)installedVersion
{
    [_meta setObject:installedVersion forKey:META_INSTALLED_KEY];
}
-(NSString *)installedVersion
{
    return [_meta objectForKey:META_INSTALLED_KEY];
}
-(void)setOnlineVersion:(NSString *)onlineVersion
{
    [_meta setObject:onlineVersion forKey:META_ONLINE_KEY];
}
-(NSString *)onlineVersion
{
    return [_meta objectForKey:META_ONLINE_KEY];
}

-(NSDictionary *)orderedDictionary
{
    NSMutableDictionary *a=[[NSMutableDictionary alloc] init];
    if([_meta objectForKey:METADATA_TITLE]!=nil)
        [a setObject:[_meta objectForKey:METADATA_TITLE] forKey:METADATA_TITLE];
    if([_meta objectForKey:METADATA_SUMMARY]!=nil)
        [a setObject:[_meta objectForKey:METADATA_SUMMARY] forKey:METADATA_SUMMARY];
    if ([_meta objectForKey:METADATA_CUSTOM_KEYS]!=nil && [_meta objectForKey:METADATA_CUSTOM_OBJECTS]!=nil) {
        [a setObject:[_meta objectForKey:METADATA_CUSTOM_KEYS] forKey:METADATA_CUSTOM_KEYS];
        [a setObject:[_meta objectForKey:METADATA_CUSTOM_OBJECTS] forKey:METADATA_CUSTOM_OBJECTS];
        
    }
    return a;
}

@end
