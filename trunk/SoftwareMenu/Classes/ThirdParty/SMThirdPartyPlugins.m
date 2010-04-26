//
//  ThirdPartyPlugins.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/6/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMThirdPartyPlugins.h"
@interface SMThirdPartyPlugins (Private)
-(void)_threadedFetch;

@end

@implementation SMThirdPartyPlugins
static SMThirdPartyPlugins *singleton = nil;

+ (SMThirdPartyPlugins*)singleton
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
//        [singleton setCheckImages:YES];
//        [singleton setUpdateImages:NO];
    }
    return singleton;
}
-(id)init
{
    self = [super init];
    _locking=NO;
    _updateImages=YES;
    _checkImages=YES;
    return self;
}
-(id)delegate
{
    return _delegate;
}
-(void)performThreadedPluginFetch
{
    [NSThread detachNewThreadSelector:@selector(_threadedFetch) toTarget:self withObject:nil];
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
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self singleton] retain];
}
- (id)copyWithZone:(NSZone *)zone
{
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
-(NSDictionary *)plugins
{
    NSDictionary *a = [NSDictionary dictionaryWithContentsOfFile:[SMPreferences trustedPlistPath]];
    return a;
}
/*-(NSDictionary *)fetchURL:(NSString *)urlString
{
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	NSURLResponse *response = nil;
    NSError *error;
	NSData *documentData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (error!=nil) {
        ALog(@"Fetching: %@ returned an error: %@",url,error);
        [error release];
        return [NSDictionary dictionary];
    }
    else {
        
               
        NSStringEncoding responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)[response textEncodingName]));
        NSString *documentString = [[NSString alloc] initWithData:documentData encoding:responseEncoding];
        
        NSData* plistData = [documentString dataUsingEncoding:NSUTF8StringEncoding];
        NSPropertyListFormat format;
        NSString *errorString;
        NSDictionary* plist = [NSPropertyListSerialization propertyListFromData:plistData 
                                                               mutabilityOption:NSPropertyListImmutable 
                                                                         format:&format 
                                                               errorDescription:&errorString];
        DLog( @"parsed plist is %@", plist );
        if(!plist){
            ALog(@"Converted Received Message Error: %@",errorString);
            [error release];
        }
        [documentString release];
        return plist;
        //doc=[[NSXMLDocument alloc]initWithXMLString:documentString options:NSXMLDocumentTidyXML error:nil];
        
    }
    
}*/
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
-(NSString *)loadPlugins
{
    NSFileManager *man = [NSFileManager defaultManager];

	
	
	NSMutableDictionary *TrustedDict=[[NSMutableDictionary alloc] init];

	NSArray *trustedSources =[NSArray arrayWithContentsOfURL:[[NSURL alloc] initWithString:TRUSTED_URL]];
	NSEnumerator *enumerator = [trustedSources objectEnumerator];
	[self writeToLog:@"==== startUpdate ===="];
	[self writeToLog:@"========= Adding Trusted ========="];
	[self writeToLog:[NSString stringWithFormat:@"Downloading trusted file from: %@",TRUSTED_URL,nil]];
    [self writeToLog:[NSString stringWithFormat:@"%@",trustedSources]];
	id obj;
	
	while((obj = [enumerator nextObject]) != nil) 
	{
		NSString *theTrustedURL = [obj valueForKey:@"theURL"];
		NSString *theTrustedName = [obj valueForKey:@"name"];
        
		[self writeToLog:[NSString stringWithFormat:@"Adding From List: %@",theTrustedName,nil]];
		[self writeToLog:[NSString stringWithFormat:@"With URL: %@",theTrustedURL,nil]];
		
		NSDictionary *trustedSource =[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:theTrustedURL]];
		
		if([theTrustedURL isEqualToString:@"http://nitosoft.com/version.plist"])
		{
			NSMutableDictionary *nitoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
            [nitoDict setValuesForKeysWithDictionary:trustedSource];
			[nitoDict setObject:@"nitoTV" forKey:@"name"];
			[nitoDict setObject:[nitoDict valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[nitoDict setObject:[nitoDict valueForKey:@"displayVersionTwo"] forKey:@"displayVersion"];
			[nitoDict setObject:[nitoDict valueForKey:@"versionTwo"] forKey:@"shortVersion"];
			[nitoDict setObject:@"http://nitosoft.com/nitoTVTwo.tar.gz" forKey:@"theURL"];
            //			[nitoDict setObject:[trustedSource valueForKey:@"ShortDescription"] forKey:@"ShortDescription"];
            //			[nitoDict setObject:[trustedSource valueForKey:@"developer"] forKey:@"Developer"];
            //			[nitoDict setObject:[trustedSource valueForKey:@"ReleaseDate"] forKey:@"ReleaseDate"];
            //			[nitoDict setObject:[trustedSource valueForKey:@"ImageURL"] forKey:@"ImageURL"];
            //            [nitoDict setObject:[trustedSource valueForKey:@"osMin"] forKey:@"osMin"];
            //			[nitoDict setObject:[trustedSource valueForKey:@"osMax"] forKey:@"osMax"];
            //            [nitoDict setObject:[trustedSource valueForKey:@"license"] forKey:@"license"];
            //            [nitoDict setObject:[trustedSource valueForKey:@"desc"] forKey:@"desc"];
            //NSLog(@"imageURL: %@",[nitoDict valueForKey:@"ImageURL"]);
			[TrustedDict setObject:nitoDict forKey:@"NitoTV"];
			[self writeToLog:@"nitoTV special loop"];
			
		}
		else if([theTrustedURL isEqualToString:@"http://nitosoft.com/updates.plist"])
		{
			NSMutableDictionary *couchDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
			[couchDict setObject:@"CouchSurfer" forKey:@"name"];
			[couchDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[couchDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"displayVersion"];
			[couchDict setObject:[trustedSource valueForKey:@"twoUrl"] forKey:@"theURL"];
			[TrustedDict setObject:couchDict forKey:@"CouchSurfer"];
			[self writeToLog:@"CouchSurfer Special loop (Thanks to nito for plist up to date)"];
		}
		else
		{
			[TrustedDict addEntriesFromDictionary:trustedSource];
		}
		[self writeToLog:@"\n"];
	}
    if([man fileExistsAtPath:[SMPreferences trustedPlistPath]] && [[TrustedDict allKeys] count]>1)
		[man removeFileAtPath:[SMPreferences trustedPlistPath] handler:nil];
	[TrustedDict writeToFile:[SMPreferences trustedPlistPath] atomically:YES];
//    if (_checkImages) {
//        [self getImages:TrustedDict];
//    }
	
	

	[self writeToLog:@"========= Done ========="];
    return [SMGeneralMethods checkUpdatesPath];

}
-(void)getImages:(NSDictionary *)TrustedDict
{
    NSFileManager *man = [NSFileManager defaultManager];
	[self writeToLog:@"getting Images"];
	NSEnumerator *keyEnum = [TrustedDict keyEnumerator];
	id obj2;
	NSString *ImageURL=nil;
	NSString *name=nil;
	id obj;
	while((obj2 = [keyEnum nextObject]) != nil) 
	{
        if(![man fileExistsAtPath:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]]] || _updateImages)
        {
            obj = [TrustedDict objectForKey:obj2];
            ImageURL = nil;
            //NSLog(@"1");
            name = [obj objectForKey:@"name"];
            if (name == nil)
                name = [obj objectForKey:@"Name"];
            ImageURL = [obj objectForKey:@"ImageURL"];
            //NSLog(@"name:%@, ImageURl:%@",name,ImageURL);
            if([ImageURL length] == 0)
            {
                if([name isEqualToString:@"ATVFiles"])
                {
                    ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/ATVFiles.png";
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
                    [imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
                    
                }
                else if([name isEqualToString:@"CouchSurfer"])
                {
                    ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/CouchSurfer.png";
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
                    [imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
                }
                else if([name isEqualToString:@"nitoTV"])
                {
                    ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/nitoTV.png";
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
                    [imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
                }
                
            }
            if([ImageURL length]!=0 )
            {
                [self writeToLog:ImageURL];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
                if([man fileExistsAtPath:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]]])
                {
                    [man removeFileAtPath:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] handler:nil];
                }
                [imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
                
            }
            
        }
    }
    
	
}
- (void)writeToLog:(NSString *)str
{
	NSString * thelog2 = [[[[NSString alloc] initWithContentsOfFile:[SMGeneralMethods checkUpdatesPath]] stringByAppendingString:@"\n"] stringByAppendingString:str];
	[thelog2 writeToFile:[SMGeneralMethods checkUpdatesPath] atomically:YES];
}
@end
@implementation SMThirdPartyPlugins (Private)
-(void)_threadedFetch
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    DLog(@"Current Thread: %@",[NSThread currentThread]);
    _locking=YES;
    DLog(@"Where the fetching is done");
    [self loadPlugins];
    _locking=FALSE;
    [self fetchURL:TRUSTED_URL];
    //[[BRAppManager sharedApplication]postNotificationOnMainThreadNamed:kSMPluginFetchDoneNotification object:nil];
    [pool drain];
}

@end






