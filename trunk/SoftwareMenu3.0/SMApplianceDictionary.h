//
//  SMApplianceDictionary.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/22/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//



@interface SMApplianceDictionary : NSObject{
    NSMutableDictionary * _information;
    NSArray             * _keys;
    BOOL                  _trusted;
}
-(NSArray *)getKeys;
-(id)initWithDictionary:(NSDictionary *)dict;
-(void)setObject:(id)obj forKey:(NSString *)key;
-(id)objectForKey:(NSString *)key;
-(void)setDict:(NSDictionary *)dict;
-(void)setIsTrusted:(BOOL)trusted;
-(BOOL)isTrusted;
-(NSString *)name;
-(NSString *)version;
-(NSString *)onlineVersionString;
-(NSString *)licenseURL;
-(NSString *)informationURL;
-(NSString *)archiveURL;
-(NSString *)developer;
-(NSDate *)  releaseDate;
-(NSString *)formatedReleaseDate;
-(NSString *)shortDescription;
-(NSString *)updateText;
-(BOOL)installOnCurrentOS;
-(BOOL)installOnOS:(NSString *)OS;
-(BOOL)isValid;
-(BOOL)isInstalled;
-(BOOL)isBackedUp;
-(BOOL)installedIsUpToDate;
-(BOOL)backupIsUpToDate;
-(BOOL)allowedToRemove;
-(BOOL)hasImage;
-(id)imageAsset;
-(NSString *)backupVersion;
-(NSString *)installedVersion;
-(NSString *)displayName;
-(NSString *)displayVersion;

@end
