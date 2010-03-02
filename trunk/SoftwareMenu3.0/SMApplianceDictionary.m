//
//  SMApplianceDictionary.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/22/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMApplianceDictionary.h"


@implementation SMApplianceDictionary
-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    _information = [dict mutableCopy];
    [_information retain];
    _keys = [_information allKeys];
    [_keys retain];
    _trusted = NO;
    return self;
}
-(void)setObject:(id)obj forKey:(NSString *)key
{
    [_information setObject:obj forKey:key];
    [_keys release];
    _keys = [_information allKeys];
    [_keys retain];
}
-(id)objectForKey:(NSString *)key
{
    return [_information objectForKey:key];
}
-(void)setDict:(NSDictionary *)dict
{
    [_information release];
    _information = [dict mutableCopy];
    [_information retain];
    [_keys release];
    _keys = [_information allKeys];
    [_keys retain];
}
-(void)setIsTrusted:(BOOL)trusted
{
    _trusted=trusted;
}
-(BOOL)isTrusted
{
    return _trusted;
}
-(NSString *)name
{
    if([_keys containsObject:@"Name"])
        return [_information objectForKey:@"Name"];
    if([_keys containsObject:@"name"])
        return [_information objectForKey:@"name"];
    return nil;
}
-(NSArray *)getKeys
{
    return [_information allKeys];
}
-(NSString *)licenseURL
{
    if([_keys containsObject:@"thelicense"])
        return [_information objectForKey:@"thelicense"];
    else if([_keys containsObject:@"license"])
        return [_information objectForKey:@"license"];
    else
        return nil;
}
-(NSString *)onlineVersionString
{
    return [_information objectForKey:@"Version"];
}

-(NSString *)displayVersion
{
    if([_keys containsObject:@"displayVersion"])
        return [_information objectForKey:@"displayVersion"];
    else if ([_keys containsObject:@"DisplayVersion"])
        return [_information objectForKey:@"DisplayVersion"];
    else 
        return nil;
}
-(NSString *)informationURL
{
    NSString *thedescription = [_information valueForKey:@"theDesc"];
    if(thedescription == nil)
    {
        thedescription = [_information valueForKey:@"Desc"];
        if(thedescription == nil)
        {
            thedescription = [_information valueForKey:@"desc"];
            if(thedescription == nil)
            {
                return nil;
            }
        }
    }
    return thedescription;
}
-(NSString *)description
{
    NSString *thedescription = [_information valueForKey:@"theDesc"];
    if(thedescription == nil)
    {
        thedescription = [_information valueForKey:@"Desc"];
        if(thedescription == nil)
        {
            thedescription = [_information valueForKey:@"desc"];
            if(thedescription == nil)
            {
                return nil;
            }
        }
    }
    return thedescription;
}
-(NSString *)shortDescription
{
    return [_information valueForKey:@"ShortDescription"];
}
-(NSDate *)releaseDate
{
    return [_information objectForKey:@"ReleaseDate"];
}
-(NSString *)formatedReleaseDate
{
    NSDate *date = [self releaseDate];
    if (date==nil)
        return nil;
    NSString *fdate = [date descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:nil];
    return fdate;
}
-(NSString *)archiveURL
{
    if([_keys containsObject:@"URL"])
        return [_information objectForKey:@"URL"];
    else if([_keys containsObject:@"theURL"])
        return [_information objectForKey:@"theURL"];
    else
        return nil;
}
-(NSString *)developer
{
    return [_information objectForKey:@"Developer"];
}
-(NSString *)osMin
{
    if([_keys containsObject:@"osMin"])
        return [_information objectForKey:@"osMin"];
    return nil;
}

-(NSString *)osMax
{
//    if([_keys containsObject:@"osMax"])
//        return [_information objectForKey:@"osMax"];
    return nil;
}
-(BOOL)strictUpperLimit
{
    return [SMPreferences strictApplianceUpperInstallLimit];
}
-(BOOL)strictLowerLimit
{
    return YES;
    //return [SMPreferences strictApplianceLowerInstallLimit];
}
-(BOOL)hasImage
{
    if ([SMGeneralMethods getImagePath:[self name]]!=nil)
        return YES;
    return NO;
}
-(id)imageAsset
{
    NSString *path=[SMGeneralMethods getImagePath:[self name]];
    if(path==nil)
        return nil;
    else
    {
        BRPhotoMediaAsset * asset = [[BRPhotoMediaAsset alloc] init];
        [asset setFullURL:path];
        [asset setThumbURL:path];
        [asset setCoverArtURL:path];
        [asset setIsLocal:YES];
        return [asset autorelease];;
    }
    return nil;
}
-(BOOL)installOnCurrentOS
{
    BOOL greater =YES;
    BOOL lesser  = NO;
    if([self osMin]==nil)
        greater = YES;
    else if([self strictLowerLimit])
        greater = [SMGeneralMethods OSGreaterThan:[self osMin]];
    else
        greater = YES;
    
    if([self osMax]==nil)
        lesser = YES;
    else if([self strictUpperLimit])
        lesser = [SMGeneralMethods OSLessThan:[self osMax]];
    else
        lesser = YES;
    if(lesser && greater)
        return YES;
    return NO;
}
-(BOOL)isValid
{
    if([self name]!=nil && [self archiveURL]!=nil && [self onlineVersionString]!=nil)
        return YES;
    return NO;
}
-(BOOL)isInstalled
{
   	NSString *frapPath= [FRAP_PATH stringByAppendingPathComponent:[[self name] stringByAppendingPathExtension:@"frappliance"]];
    NSString *infoPlistPath = [frapPath stringByAppendingPathComponent:@"Contents/Info.plist"];
	if([[NSFileManager defaultManager] fileExistsAtPath:frapPath] && [[NSFileManager defaultManager] fileExistsAtPath:infoPlistPath])
        return (YES);
	return(NO); 
}
-(BOOL)isBackedUp
{
    NSString *bakPath = [BAK_PATH stringByAppendingPathComponent:[[self name] stringByAppendingPathExtension:@"bak"]];
    NSString *infoPlistPath = [bakPath stringByAppendingPathComponent:@"Contents/Info.plist"];
	if([[NSFileManager defaultManager] fileExistsAtPath:bakPath] && [[NSFileManager defaultManager] fileExistsAtPath:infoPlistPath])
        return (YES);
	return(NO);
}
-(BOOL)installedIsUpToDate
{
    if([self isInstalled])
    {
        NSString *frapPath= [FRAP_PATH stringByAppendingPathComponent:[[self name] stringByAppendingPathExtension:@"frappliance"]];
        NSDictionary *infoDict = [SMPreferences dictionaryForBundlePath:frapPath];
        if(![[self name] isEqualToString:@"nitoTV"])
        {
            if([(NSString *)[infoDict valueForKey:@"CFBundleVersion"] compare:[self onlineVersionString]]!=NSOrderedAscending)
                return (YES);
        }
        else if([[infoDict valueForKey:@"CFBundleShortVersionString"] compare:[_information valueForKey:@"shortVersion"]]!=NSOrderedAscending)
            return (YES);
        return (NO);
    }
    return NO;

}
-(BOOL)backupIsUpToDate
{
    if([self isBackedUp])
    {
        NSString *bakPath = [BAK_PATH stringByAppendingPathComponent:[[self name] stringByAppendingPathExtension:@"bak"]];
        NSDictionary *infoDict = [SMPreferences dictionaryForBundlePath:bakPath];
        if(![[self name] isEqualToString:@"nitoTV"])
        {
            if([(NSString *)[infoDict objectForKey:@"CFBundleVersion"] compare:[self onlineVersionString]]!=NSOrderedAscending)
                return (YES);
        }
        else if([[infoDict valueForKey:@"CFBundleShortVersionString"] compare:[_information valueForKey:@"shortVersion"]]!=NSOrderedAscending)
            return (YES);
        return (NO);
    }
    return NO;
}
-(NSString *)backupVersion
{
	NSString *bakPath = [BAK_PATH stringByAppendingPathComponent:[[self name] stringByAppendingPathExtension:@"bak"]];
	NSDictionary * info =[SMPreferences dictionaryForBundlePath:bakPath];
	if([[info allKeys] containsObject:@"CFBundleShortVersionString"] && ![[self name] isEqualToString:@"nitoTV"])
		return [info objectForKey:@"CFBundleShortVersionString"];
	else
		return [info objectForKey:@"CFBundleVersion"];
	
}
-(NSString *)installedVersion
{
    NSString *frapPath= [FRAP_PATH stringByAppendingPathComponent:[[self name] stringByAppendingPathExtension:@"frappliance"]];
	NSDictionary * info =[SMPreferences dictionaryForBundlePath:frapPath];
	if([[info allKeys] containsObject:@"CFBundleShortVersionString"] && ![[self name] isEqualToString:@"nitoTV"])
		return [info objectForKey:@"CFBundleShortVersionString"];
	else
		return [info objectForKey:@"CFBundleVersion"];
}
-(NSString *)displayName
{
    if([_keys containsObject:@"displayName"])
        return [_information objectForKey:@"displayName"];
    else
        return [self name];
}
-(BOOL)allowedToRemove
{
    if([[self name] isEqualToString:@"SoftwareMenu"])
        return NO;
    return YES;
}
-(BOOL)installOnOS:(NSString *)OS
{
    return YES;
}
-(NSString *)updateText
{
    return @"";
}
-(NSString *)version
{
    return [self onlineVersionString];
}
@end
