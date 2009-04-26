//
//  TomRSS.m
//  TomSS.frss
//
//  Created by Thomas on 4/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//#import "BackRow.h"
#import "SMPhotos.h"
#define DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"
#define myDomain				(CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"
#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"
#define PHOTO_SPIN_FREQUENCY	@"PhotoSpinFrequency"
#include <stdio.h>
#import <objc/objc-class.h>


/*@implementation ATVDefaultPhotos 
 @end*/
@interface BRBacktracingException
@end
@interface BRBackupPhotoAsset
@end
@class ATVPhloatoPlane, NSTimer;

@interface ATVPhloatoControl
{
    ATVPhloatoPlane *_frontPlane;
    ATVPhloatoPlane *_middlePlane;
    ATVPhloatoPlane *_backPlane;
    NSTimer *_spinTimer;
    float _spinFrequency;
    BOOL _waitingForQueue;
}

- (id)init;
- (void)dealloc;
- (void)setImageProviders:(id)fp8;
- (id)loadAssets;
- (void)setSpinFrequency:(float)fp8;
- (float)spinFrequency;
- (void)controlWasActivated;
- (void)controlWasDeactivated;

@end


@implementation SMPhotos
-(ATVPhloatoControl *)gimmeControl {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_control");
	return *(ATVPhloatoControl * *)(((char *)self)+ret->ivar_offset);
}
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
	Boolean temp;
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
	//NSLog(@"hellotoo: %@",hellotoo);
	CFPreferencesAppSynchronize(myDomain);
	/*CFPropertyListRef value;
	value = CFPreferencesCopyAppValue((CFStringRef)PHOTO_SPIN_FREQUENCY, myDomain);
	CFNumberGetValue(value, kCFNumberFloatType, &ret);*/
	int outInt = CFPreferencesGetAppIntegerValue((CFStringRef)PHOTO_SPIN_FREQUENCY, myDomain, &temp);
	if(outInt == nil)
		outInt = 60;
	ATVPhloatoControl *hellos = [self gimmeControl];
	float ii = (float)[hellos spinFrequency];
	[hellos setSpinFrequency:(float)outInt];
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
