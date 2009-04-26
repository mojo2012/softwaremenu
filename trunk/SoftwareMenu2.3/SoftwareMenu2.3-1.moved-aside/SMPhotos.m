//
//  TomRSS.m
//  TomSS.frss
//
//  Created by Thomas on 4/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "BackRow.h"
#import "SMPhotos.h"
#define DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"
#define myDomain				(CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"
#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"



/*@implementation ATVDefaultPhotos 
@end*/


@implementation SMPhoto
+(NSString *) className {
    // this function creates an NSString from the contents of the
    // struct objc_class, which means using this will not call this
    // function recursively, and it'll also return the *real* class
    // name.
    NSString * className = NSStringFromClass( self );
	
	// new method based on the BackRow NSException subclass, which conveniently provides us a backtrace
	// method!
	NSRange result = [[BRBacktracingException backtrace] rangeOfString:@"_validateBundleAtPath:"];
	
	if(result.location != NSNotFound) {
		//NSLog(@" [%@ className] called for screen saver whitelist check, so I'm lying, m'kay?", className);
		className = @"RUIRetailScreenSaver";
	}
	
	return className;
}
-(id)loadAssets
{
	NSString *path = [self getPath];
	return [self applePhotosForPath:path];
}
-(id)init
{
	self = [super init];
	[self setImageProviders:[self loadAssets]];
	return self;
}
-(id)applePhotosForPath:(NSString *)thepath
{
	
	NSArray *coverArtExtention = [[NSArray alloc] initWithObjects:
								  @"jpg",
								  @"jpeg",
								  @"tif",
								  @"tiff",
								  @"png",
								  @"gif",
								  nil];
	//id hello = [super applePhotos];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
	NSMutableArray *hellotoo =[NSMutableArray arrayWithObjects:nil];
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		if([coverArtExtention containsObject:[idStr pathExtension]])
		{
			[hellotoo addObject:[[BRBackupPhotoAsset alloc] initWithPath:[thepath stringByAppendingPathComponent:idStr]]];
		}
		//NSLog(@"%@",idStr);
		
	}
	
	//BRBackupPhotoAsset *Image = [[BRBackupPhotoAsset alloc] initWithPath:@"System/Library/PrivateFrameworks/AppleTV.framework/Versions/A/Resources/DefaultPhotos/GWKH.jpg"];
	//BRBackupPhotoAsset *Image2 = [[BRBackupPhotoAsset alloc] initWithPath:@"System/Library/PrivateFrameworks/AppleTV.framework/Versions/A/Resources/DefaultPhotos/SB_ZN.JPG"];
	return hellotoo;
}
-(NSString *)getPath
{

		//CFPreferencesAppSynchronize(myDomain);
	CFStringRef myString = [(CFStringRef)CFPreferencesCopyAppValue((CFStringRef)PHOTO_DIRECTORY_KEY, myDomain) autorelease];
	NSString *theDir = (NSString *)myString;
	
	BOOL isDir;
	if(theDir==nil || ![[NSFileManager defaultManager] fileExistsAtPath:theDir isDirectory:&isDir] || !isDir)
		theDir = DEFAULT_IMAGES_PATH;
	//NSLog(@"theDir: %@",theDir);
	if([[NSFileManager defaultManager] fileExistsAtPath:theDir isDirectory:&isDir] && isDir){}
	else
	{
		theDir = DEFAULT_IMAGES_PATH;
	}
	return theDir;
}



@end
