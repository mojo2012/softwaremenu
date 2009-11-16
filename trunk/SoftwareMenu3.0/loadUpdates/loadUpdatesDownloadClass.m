//
//  loadUpdatesDownloadClass.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/7/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "loadUpdatesDownloadClass.h"
#import <sys/param.h>
#import <sys/mount.h>
#import <stdio.h>

@implementation loadUpdatesDownloadClass
-(id)init
{
    self=[super init];
    _downloadPath = [SMPreferences trustedPlistPath];
    [_downloadPath retain];
    _downloadURL  = [SMPreferences trustedPlistURL];
    [_downloadURL retain];
    _man = [NSFileManager defaultManager];
    [_man retain];
    return self;
}
-(void)dealloc
{
    [_man release];
    [_downloadPath release];
    [_downloadURL release];
    [super dealloc];
}
-(void)setPath:(NSString *)path
{
    [_downloadPath release];
    _downloadPath = path;
    [_downloadPath retain];
}
-(void)setURL:(NSString *)url
{
    [_downloadURL release];
    _downloadURL = url;
    [_downloadURL retain];
    [super dealloc];
}

-(int)checkPathForPath:(NSString *)pathFile
{
    //NSString *pathFile =[_downloadPath stringByDeletingLastPathComponent];
    BOOL isDir;
    BOOL success=NO;
    if(![[NSFileManager defaultManager] fileExistsAtPath:pathFile isDirectory:&isDir] || !isDir)
    {
        success = [[NSFileManager defaultManager] constructPath:pathFile];
    }
    if (!success)
        return 1;
    return 0;
}
-(int)downloadUpdates
{
    int i = [self checkPathForPath:[_downloadPath stringByDeletingLastPathComponent]];
//    if (i!=0)
//        return i;
//    if (i!=0) 
//        return i;
    NSLog(@"i: %i",i);
    
    if([_man fileExistsAtPath:[_downloadPath stringByExpandingTildeInPath]])
        [_man removeFileAtPath:[_downloadPath stringByExpandingTildeInPath] handler:nil];
    
    
    
    NSMutableDictionary *TrustedDict=[[NSMutableDictionary alloc] init];
    
    NSArray *trustedSources =[NSArray arrayWithContentsOfURL:[[NSURL alloc] initWithString:_downloadURL]];
    NSEnumerator *enumerator = [trustedSources objectEnumerator];
    
    id obj;
    
    while((obj = [enumerator nextObject]) != nil) 
    {
        NSString *theTrustedURL = [obj valueForKey:@"theURL"];
        //NSString *theTrustedName = [obj valueForKey:@"name"];
                
        NSDictionary *trustedSource =[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:theTrustedURL]];
        
        if([theTrustedURL isEqualToString:@"http://nitosoft.com/version.plist"])
        {
            NSMutableDictionary *nitoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
            [nitoDict setObject:@"nitoTV" forKey:@"name"];
            [nitoDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"Version"];
            [nitoDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"displayVersion"];
            [nitoDict setObject:[trustedSource valueForKey:@"versionTwo"] forKey:@"shortVersion"];
            [nitoDict setObject:@"http://nitosoft.com/nitoTVTwo.tar.gz" forKey:@"theURL"];
            [nitoDict setObject:[trustedSource valueForKey:@"ShortDescription"] forKey:@"ShortDescription"];
            [nitoDict setObject:[trustedSource valueForKey:@"developer"] forKey:@"Developer"];
            [nitoDict setObject:[trustedSource valueForKey:@"ReleaseDate"] forKey:@"ReleaseDate"];
            [nitoDict setObject:[trustedSource valueForKey:@"ImageURL"] forKey:@"ImageURL"];
            [TrustedDict setObject:nitoDict forKey:@"NitoTV"];
            
        }
        else if([theTrustedURL isEqualToString:@"http://nitosoft.com/updates.plist"])
        {
            NSMutableDictionary *couchDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
            [couchDict setObject:@"CouchSurfer" forKey:@"name"];
            [couchDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"Version"];
            [couchDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"displayVersion"];
            [couchDict setObject:[trustedSource valueForKey:@"twoUrl"] forKey:@"theURL"];
            [TrustedDict setObject:couchDict forKey:@"CouchSurfer"];
        }
        else
        {
            [TrustedDict addEntriesFromDictionary:trustedSource];
        }
    }
    [TrustedDict writeToFile:_downloadPath atomically:YES];
    NSLog(@"trustedDictPath: %@",_downloadPath);
    [self getImages:TrustedDict];
    return 0;
}
-(int)checkForUpdates
{
    NSDictionary *a = [NSDictionary dictionaryWithContentsOfFile:_downloadPath];
    [SMPreferences setBool:NO forKey:UPDATES_AVAILABLE];
    NSString *basePath = @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/";
    NSArray *b = [a allKeys];
    int i;
    for(i=0;i<[b count];i++)
    {
        NSDictionary *dict = [a objectForKey:[b objectAtIndex:i]];
        NSString *a = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.frappliance",[dict objectForKey:@"name"],nil]];
        NSString *current_version;
        if([[NSFileManager defaultManager] fileExistsAtPath:a])
        {
            NSLog(@"%@ is installed",[dict objectForKey:@"name"]);
            //NSLog([a stringByAppendingPathComponent:@"Contents/Info.plist"]);
            NSDictionary *baseInfo = [NSDictionary dictionaryWithContentsOfFile:[a stringByAppendingPathComponent:@"Contents/Info.plist"]];
            NSString *onlineVersion = [dict valueForKey:@"Version"];
            current_version =[NSString stringWithString:[baseInfo objectForKey:@"CFBundleVersion"]];
            NSString *installed_version = [baseInfo objectForKey:@"CFBundleShortVersionString"];
            if(installed_version == nil)
                installed_version = current_version;
            
            if([[dict objectForKey:@"name"] isEqualToString:@"nitoTV"])
            {
                
                current_version = [baseInfo objectForKey:@"CFBundleShortVersionString"];
                onlineVersion = [dict valueForKey:@"shortVersion"];
                installed_version = [baseInfo objectForKey:@"CFBundleVersion"];
            }
            if([current_version compare:onlineVersion]==NSOrderedSame)				{NSLog(@"%@ is Up to Date",[dict objectForKey:@"name"]);}
            else if ([current_version compare:onlineVersion]==NSOrderedAscending)	
            {
                NSLog(@"%@ is not Up to Date",[dict objectForKey:@"name"]);
                [SMPreferences setBool:YES forKey:UPDATES_AVAILABLE];
            }
            else																	{NSLog(@"ahead of the curve for %@",[dict objectForKey:@"name"]);}
                                           
        }
    }
    return 0;
    
}

-(void)getImages:(NSDictionary *)TrustedDict
{
    NSString *imageFolder = [SMPreferences ImagesPath];
    [_man constructPath:imageFolder];
    NSLog(@"ImagesFolder: %@",imageFolder);
	NSEnumerator *keyEnum = [TrustedDict keyEnumerator];
	id obj2;
	NSString *ImageURL=nil;
	NSString *name=nil;
	id obj;
	while((obj2 = [keyEnum nextObject]) != nil) 
	{
		obj = [TrustedDict objectForKey:obj2];
		ImageURL = nil;
		name = [obj objectForKey:@"name"];
		if (name == nil)
			name = [obj objectForKey:@"Name"];
		ImageURL = [obj objectForKey:@"ImageURL"];

		if([ImageURL length] == 0)
		{
			if([name isEqualToString:@"ATVFiles"])
			{
				ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/ATVFiles.png";
				NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
				[imageData writeToFile:[imageFolder stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
				
			}
			else if([name isEqualToString:@"CouchSurfer"])
			{
				ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/CouchSurfer.png";
				NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
				[imageData writeToFile:[imageFolder stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
			}
			else if([name isEqualToString:@"nitoTV"])
			{
				ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/nitoTV.png";
				NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
				[imageData writeToFile:[imageFolder stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
			}
			
		}
		else 
		{
			NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
			if([_man fileExistsAtPath:[imageFolder stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]]])
			{
				[_man removeFileAtPath:[imageFolder stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] handler:nil];
			}
			[imageData writeToFile:[imageFolder stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
			NSLog(@"Saving at: %@",[imageFolder stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]]);
		}
	}
}

@end
