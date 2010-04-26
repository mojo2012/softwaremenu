//
//  SMPluginSingleton.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/26/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMPluginSingleton.h"

NSString * kSMPluginFetchDoneNotification=@"kSMPluginFetchDoneNotification";
@interface SMPluginSingleton (Private)
-(void)_threadedLoad;

@end
@implementation SMPluginSingleton
static SMPluginSingleton *singleton = nil;

+ (SMPluginSingleton*)singleton
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self singleton] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
-(id)init
{
    self=[super init];
    _locking=NO;
    _updateImages=YES;
    _checkImages=YES;
    return self;
    
}
- (id)retain
{
    return self;
}

- (int)retainCount
{
    return 15000;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
-(void)setDelegate:(id)delegate
{
    if (delegate==nil) {
        [_delegate release];
        _delegate=nil;
    }
    if ([delegate respondsToSelector:@selector(textShouldPrint:)]) {
        if (_delegate!=nil) {
            [_delegate release];
            _delegate=nil;
        }
        _delegate=[delegate retain];
    }
    
}
-(void)postDelegateMessage:(NSString *)message
{
    DLog(@"message: %@",message);
    [self writeToLog:message];
    if ([_delegate respondsToSelector:@selector(textDidEndEditing:)]) {
        [_delegate textDidEndEditing:message];
    }
}
-(id)delegate
{
    return _delegate;
}
-(void)performThreadedPluginLoad
{
    [NSThread detachNewThreadSelector:@selector(_threadedLoad) toTarget:self withObject:nil];
}
-(id)fetchURL:(NSString *)urlString
{
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	NSURLResponse *response = nil;
    NSError *error;
	NSData *documentData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error!=nil) {
        NSLog(@"error: %@",error);
        return nil;
    }
    else {
        NSPropertyListFormat format;
        NSString *errorString;
        NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:documentData 
                                                               mutabilityOption:NSPropertyListImmutable 
                                                                         format:&format 
                                                               errorDescription:&errorString];
        DLog( @"parsed plist is %@", plist );
        if(!plist){
            ALog(@"Converted Received Message Error: %@",errorString);
            [error release];
            return nil;
        }
        return plist;
    }
    return nil;
}
-(void)writeToLog:(NSString *)message
{
    if (_log==nil) {
        _log=[[NSMutableString string] retain];
    }
    [_log appendFormat:@"%@\n",message,nil];
}
-(NSString *)saveLog
{
    if (_log!=nil) {
        [_log writeToFile:[SMGeneralMethods checkUpdatesPath] atomically:YES];
        NSString *tl=[_log copy];
        [_log release];
        _log=nil;
        return tl;
    }
    return nil;
}
-(NSString *)loadPlugins
{
    if (!_locking) {
        _locking=TRUE;
        NSString *log;
        [self loadPluginsWithLog:&log];
        _locking=FALSE;
            return log;
    }
    return nil;


}
-(NSDictionary *)loadPluginsWithLog:(NSString **)log
{

    NSMutableDictionary *sources = [[NSMutableDictionary alloc]init];
    [self postDelegateMessage:[NSString stringWithFormat:BRLocalizedString(@"Downloading Sources From: %@",@"Downloading Sources From: %@"),TRUSTED_URL,nil]];
    id returnObject = [self fetchURL:TRUSTED_URL];
    if (returnObject!=nil && [returnObject respondsToSelector:@selector(objectAtIndex:)]) 
    {
        
        [self postDelegateMessage:@"Parsing Sources"];
        int i,count = [(NSArray *)returnObject count];
        for(i=0;i<count;i++)
        {
            NSString *url = [[returnObject objectAtIndex:i] objectForKey:@"theURL"];
            [self postDelegateMessage:[NSString stringWithFormat:@"Parsing: %@",url,nil]];
            id lreturnObject = [self fetchURL:url];
            if ([lreturnObject respondsToSelector:@selector(objectForKey:)]) {
                if ([url isEqualToString:@"http://nitosoft.com/version.plist"]) 
                {
                    NSMutableDictionary *nitoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
                    [nitoDict setValuesForKeysWithDictionary:lreturnObject];
                    [nitoDict setObject:@"nitoTV" forKey:@"name"];
                    [nitoDict setObject:[nitoDict valueForKey:@"displayVersionTwo"] forKey:@"Version"];
                    [nitoDict setObject:[nitoDict valueForKey:@"displayVersionTwo"] forKey:@"displayVersion"];
                    [nitoDict setObject:[nitoDict valueForKey:@"versionTwo"] forKey:@"shortVersion"];
                    [nitoDict setObject:@"http://nitosoft.com/nitoTVTwo.tar.gz" forKey:@"theURL"];
                    [sources setObject:nitoDict forKey:@"NitoTV"];
                }
                else
                {
                    [sources addEntriesFromDictionary:lreturnObject];
                }
            }
            else {
                [self postDelegateMessage:[NSString stringWithFormat:@"Discarding: %@\n Source is wrong Format",url,nil]];
            }

        }
        BOOL success = [sources writeToFile:[SMPreferences trustedPlistPath] atomically:YES];

        if (success) 
        {
            [self postDelegateMessage:@"Sucess For Plist "];
            if (_updateImages) {
                [self postDelegateMessage:@"\nLoading Images"];
                [self getImages:sources];
            }
        }
        else {
            [self postDelegateMessage:@"Fail For Plist"];
        }

    }
    else {
        [self postDelegateMessage:@"Error, Expected an Array"];
        DLog(@"Expected the Array but got something else");
    }
    if (log!=nil) {
        *log=[self saveLog];
    }
    DLog(@"Success At Updating Plists");
    return sources;
}
-(void)getImages:(NSDictionary *)TrustedDict
{
    NSFileManager *man = [NSFileManager defaultManager];
	NSEnumerator *keyEnum = [TrustedDict keyEnumerator];
	id obj2;
	NSString *ImageURL=nil;
	NSString *name=nil;
	id obj;
	while((obj2 = [keyEnum nextObject]) != nil) 
	{
        obj = [TrustedDict objectForKey:obj2];
        ImageURL = nil;
        //NSLog(@"1");
        name = [obj objectForKey:@"name"];
        if (name == nil)
            name = [obj objectForKey:@"Name"];
        ImageURL = [obj objectForKey:@"ImageURL"];
        //NSLog(@"name:%@, ImageURl:%@",name,ImageURL);
        if([ImageURL length]!=0 )
        {
            [self postDelegateMessage:ImageURL];
            NSData *imageData = [self fetchData:ImageURL];
            if (imageData!=nil) {
                
                if([man fileExistsAtPath:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]]])
                {
                    [man removeFileAtPath:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] handler:nil];
                }
                [imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
                
            }
        }
    }
}
-(NSData *)fetchData:(NSString *)urlString
{
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	NSURLResponse *response = nil;
    NSError *error;
	NSData *documentData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error!=nil) {
        NSLog(@"error: %@",error);
        return nil;
    }
    return documentData;
}
@end
@implementation SMPluginSingleton (Private)
-(void)_threadedLoad
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    DLog(@"Current Thread: %@",[NSThread currentThread]);
    
    if (!_locking) {
        _locking=YES;
        DLog(@"Where the fetching is done");
        [self loadPluginsWithLog:nil];
        _locking=FALSE;
    }
    else {
        ALog(@"Cannot Update: Update is Locked");
    }


    [pool drain];
}

@end
