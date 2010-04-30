//
//  SMPluginSingleton.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/26/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMPluginSingleton.h"
NSString * kSMPluginOverwrites=@"http://tomcool.org/SoftwareMenu/overwrites.plist";
NSString * kSMPluginFetchDoneNotification=@"kSMPluginFetchDoneNotification";
NSString * kSMMinOverWrite=@"minOverWrite";
NSString * kSMMaxOverWrite=@"maxOverWrite";
NSString * kSMURLOverWrite=@"url";
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
    NSLog(@"singleton init");
    NSDate *date = [SMPreferences lastCheckedDate];
    if (date==nil) {
        DLog(@"never auto run before");
        [self timerRun];

    }
    else {
        double dif = [[NSDate date] timeIntervalSinceDate:date];
        double hdif=dif/(3600.f);
        if (hdif>6.f) {
            DLog(@"More than 6 hours");
            [self timerRun];
        }
        else if((6.f*3600.f-dif)<=0.0f)
        {
            DLog(@"More than 6 hours too");
            [self timerRun];
        }
        
        else{
            //double v = 6.f*3600.f-dif;
            //DLog(@"values: %ld %ld,date: %@, cur: %@",(double)3600*(double)6,v,date,[NSDate date]);
            DLog(@"Checking in : %lf seconds",(6.f*3600.f-dif));
            _checkTimer=[NSTimer scheduledTimerWithTimeInterval:(6.f*3600.f-dif)
                                             target:self 
                                           selector:@selector(timerRun) 
                                           userInfo:nil 
                                            repeats:NO]; 
        }

    }
    
    return self;
    
}
- (void)timerRun
{
    if (_checkTimer!=nil) {
        [_checkTimer invalidate];
    }
    DLog(@"performing Plugin Check: %@",[NSDate date]);
    [SMPreferences setLastCheckedDate];
    [self performThreadedPluginLoad];
    _checkTimer=[NSTimer scheduledTimerWithTimeInterval:(6.f*3600.0f)
                                     target:self 
                                   selector:@selector(timerRun) 
                                   userInfo:nil 
                                    repeats:NO]; 
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
        //[_delegate release];
        _delegate=nil;
    }
    if ([delegate respondsToSelector:@selector(textDidChange:)]) {
        if (_delegate!=nil) {
            //[_delegate release];
            _delegate=nil;
        }
        _delegate=[delegate retain];
    }
    
}
-(void)postDelegateMessage:(NSString *)message
{
    [self postDelegateMessage:message end:NO];
}
-(void)postDelegateMessage:(NSString *)message end:(BOOL)end
{
    //DLog(@"message: %@",message);
    [self writeToLog:message];
    //DLog(@"delegate: %@",_delegate);
    if ([_delegate respondsToSelector:@selector(textDidChange:)]) {
        if (end) {
            //DLog(@"Sending Message End to Delegate");
            [_delegate textDidEndEditing:message];
            //[_delegate release];
            _delegate=nil;
        }
        else {
            //DLog(@"Sending Message to Delegate");
            [_delegate textDidChange:message];
        }
        
    }
    else {
        id ctrl = [[[BRApplicationStackManager singleton]stack] peekController];
        if ([ctrl respondsToSelector:@selector(label)] && [[ctrl label] isEqualToString:@"lupdates"]) {
            [[[BRApplicationStackManager singleton]stack]popController];
        }
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
    DLog(@"URL: %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	NSURLResponse *response = nil;
    NSError *error;
	NSData *documentData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error!=nil) {
        ALog(@"error: %@",error);
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
    [self postDelegateMessage:@"Finished" end:YES];
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
        [self loadOverwrites];
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
    ALog(@"Sources Fetched from : %@",TRUSTED_URL);
    DLog(@"Bla: %@",returnObject);
    if (returnObject!=nil && [returnObject respondsToSelector:@selector(objectAtIndex:)]) 
    {
        
        [self postDelegateMessage:@"Parsing Sources"];
        int i,count = [(NSArray *)returnObject count];
        //DLog(@"Overwrites: %@",_overwrites);

        NSArray *oKeys=[_overwrites allKeys];
                //DLog(@"Keys: %@",oKeys);
        for(i=0;i<count;i++)
        {
            NSString *url = [[returnObject objectAtIndex:i] objectForKey:@"theURL"];
            if (_overwrites!=nil) {
                if ([oKeys containsObject:url]) {
                    //DLog(@"Maybe Overwriting: %@",url);
                    NSDictionary *obj=[_overwrites objectForKey:url];
                    NSArray *keys=[obj allKeys];
                    SMFFrontrowRowCompatATVVersion currentVersion=[SMFCompatibilityMethods atvVersion];
                    SMFFrontrowRowCompatATVVersion minOver=0;
                    SMFFrontrowRowCompatATVVersion maxOver=400;
                    if ([keys containsObject:kSMMinOverWrite]) {
                        minOver=(SMFFrontrowRowCompatATVVersion)[[obj objectForKey:kSMMinOverWrite]intValue];
                    }
                    if ([keys containsObject:kSMMaxOverWrite]) {
                        maxOver=(SMFFrontrowRowCompatATVVersion)[[obj objectForKey:kSMMaxOverWrite]intValue];
                    }
                    //DLog(@"min %i, current: %i, max: %i",minOver,currentVersion,maxOver);
                    if (currentVersion<=maxOver && currentVersion>=minOver) {
                        //DLog(@"Overwriting: %@",url);
                        url = [obj objectForKey:kSMURLOverWrite];
                    }
                }
            }
            NSString *name= [[returnObject objectAtIndex:i] objectForKey:@"name"];
            [self postDelegateMessage:[NSString stringWithFormat:@"Fetching: %@",url,nil]];
            id lreturnObject = [self fetchURL:url];
            if ([lreturnObject respondsToSelector:@selector(objectForKey:)]) 
            {
                if ([lreturnObject objectForKey:@"name"]!=nil) {
                    lreturnObject = [NSDictionary dictionaryWithObject:lreturnObject forKey:name];
                }
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
        //DLog(@"Expected the Array but got something else");
    }
    if (log!=nil) {
        *log=[self saveLog];
    }
    else {
        [self postDelegateMessage:@"Finished Updating" end:YES];
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
-(void)loadOverwrites
{
    id overwrites= [self fetchURL:kSMPluginOverwrites];
    NSLog(@"overwrites: %@\nurl: %@",overwrites,kSMPluginOverwrites);
    if ([overwrites respondsToSelector:@selector(objectForKey:)]) {
        if (_overwrites!=nil) {
            [_overwrites release];
            _overwrites=nil;
        }
        _overwrites=[overwrites retain];
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
        [self loadOverwrites];
        //DLog(@"Where the fetching is done");
        [self loadPluginsWithLog:nil];
        _locking=FALSE;
    }
    else {
        ALog(@"Cannot Update: Update is Locked");
    }


    [pool drain];
}

@end
