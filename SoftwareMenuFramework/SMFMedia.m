//
//  SMFMedia.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 11/9/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <SMFMedia.h>
//#import "BackRowUtilstwo.h"
//#import <SapphireCompatClasses/SapphireFrontRowCompat.h>
//#typedef enum {       FILE_CLASS_UTILITY= -2} FileClass;
#define META_TITLE_KEY                                  @"Title"
#define FILE_CLASS_KEY                                  @"File Class"
#define META_DESCRIPTION_KEY                    @"Show Description"

@implementation SMFMedia

- (id)initB//:(NSURL *)url
{
	//This is here to fix 2.2
	self = [super initWithMediaProvider:nil];
	//NSString *urlString = [url absoluteString];
	//NSString *filename = [url path];
	[self setObject:@"hello.png" forKey:@"id"];
	[self setObject:[BRMediaType movie] forKey:@"mediaType"];
	[self setObject:@"hello" forKey:@"mediaURL"];
    type = kSMMOther;
	
	return self;
}
- (id)init
{
	self = [super init];
	
	type = kSMMOther;
	return self;
}

- (void)dealloc
{
	[imagePath release];
	[theSetDescription release];
	[theSetDescription release];
	[theDev release];
	[super dealloc];
}

-(id)assetID
{
	return @"hello";
}
- (void)setOnlineVersion:(NSString *)theOnlineVersion
{
	[onlineVersion release];
	onlineVersion = [theOnlineVersion retain];
}
- (void)setInstalledVersion:(NSString *)theInstalledVersion
{
	[installedVersion release];
	installedVersion = [theInstalledVersion retain];
}
- (id)developer
{
	if ([theDev isEqualToString:@"nil"])
		return nil;
	return theDev;
}
- (id)installedVersion
{
	//NSLog(@"InstalledVersion: %@",installedVersion);
	return installedVersion;
}
- (id)onlineVersion
{
	return onlineVersion;
}
/*- (void)setResumeTime:(unsigned int)time
{
	resumeTime = time;
}

/* Overrides the bookmark time */
//- (unsigned int)bookmarkTimeInSeconds
//{
	/*Check for resume time and if none, return bookmark time*/
//	if(time == 0)
//		return [super bookmarkTimeInSeconds];
	/*return resume time*/
//	return resumeTime;
//}

- (void)setImagePath:(NSString *)path
{
	//path=@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/SoftwareMenu.png";
	[imagePath release];
	imagePath = [path retain];
}
- (void)setDefaultImage
{
	//NSString *path=@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/softwaremenu.png";
	//[imagePath release];
	//imagePath = [path retain];
	type = kSMMDefault;
}
- (void)setBRImage:(id)theImage
{
	type = kSMMImaged;
	[bRImage release];
	bRImage = theImage;
	[bRImage retain];
	//NSLog(@"setBRImage");
}
- (void)setPhotosImage
{
	type = kSMMPhotos;
}
- (void)setPhotosSettingsImage
{
	type = kSMMPhotosSettings;
}
-(void)setDescription:(NSString *)description
{
	[theSetDescription release];
	theSetDescription=[description retain];
}
-(void)setSummary:(NSString *)description
{
	[theSetDescription release];
	theSetDescription=[description retain];
}
-(void)setTitle:(NSString *)title
{
	[theSetTitle release];
	theSetTitle=[title retain];
}
-(void)setDev:(NSString *)devName
{
	[theDev release];
	theDev=[devName retain];
}
-(id)description
{
	return [self stringReturn:theSetDescription];
}
-(id)title
{	
	return [self stringReturn:theSetTitle];
}

-(id)mediaSummary
{
	return [self stringReturn:theSetDescription];
}
- (id)mediaType
{

		return [BRMediaType movie];
}

- (BOOL)hasCoverArt
{
	return YES;
}

- (id)coverArt
{
	id coverArt;
    NSLog(@"coverArt from Media");
	switch (type) {
		case kSMMPhotos:
			coverArt = [[BRThemeInfo sharedTheme] photosImage];
			break;
		case kSMMPhotosSettings:
			coverArt = [[BRThemeInfo sharedTheme] photoSettingsImage];
			break;
		case kSMMOther:
			coverArt = [BRImage imageWithPath:imagePath];
			break;
		case kSMMDefault:
			coverArt = [[SMFThemeInfo sharedInstance] notFoundImage];
			break;
		case kSMMImaged:
            NSLog(@"BRImaged");
			coverArt = bRImage;
			break;
		default:
            NSLog(@"default");
			coverArt = [[SMFThemeInfo sharedInstance] notFoundImage];
			break;
	}
    NSLog(@"coverArt: %@",coverArt);
	return coverArt;
}

-(id)directors
{
	if([theDev isEqualToString:@"nil"])
		return nil;
	if(theDev == nil)
		return nil;
	return [NSArray arrayWithObject:[NSArray arrayWithObjects:[self stringReturn:theDev],nil]];
}
-(id)imageAtPath:(NSString *)path
{
	
	// this returns a CGImageRef
	id sp= [BRImage imageWithPath:imagePath];
	return [sp autorelease];
}
-(NSString *)stringReturn:(NSString *)theString
{
	if ([theString isEqualToString:@"nil"])
		return nil;
	
	return theString;
}



@end
