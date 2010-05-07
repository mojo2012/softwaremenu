//
//  SMTheme.m
//  SoftwareMenu
//
//  Created by Thomas on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMTheme.h"
#define IMAGE_SM_SHELF      @"shelff"
#define IMAGE_SM			@"softwaremenu"
#define IMAGE_INFO			@"info"
#define IMAGE_INTERNET		@"internet"
#define IMAGE_POWER			@"power"
#define IMAGE_REFRESH		@"refresh"
#define IMAGE_STANDBY		@"standby"
#define IMAGE_TRASH_EMPTY	@"trashempty"
#define IMAGE_WEB			@"web"
#define	IMAGE_HARDDISK		@"RW"
#define IMAGE_AFP			@"AFP"
#define	IMAGE_FTP			@"FTP"
#define IMAGE_VNC			@"VNC"
#define IMAGE_SYS_PREFS		@"sysprefs"
#define IMAGE_SCRIPT		@"script"
#define IMAGE_TIME_MACHINE	@"timemachine"
#define	IMAGE_PERIAN		@"Perian"
#define IMAGE_PACKAGE		@"package"
#define IMAGE_FOLDER		@"folderIcon"
#define IMAGE_PHOTO_HELP	@"RemotePhotos"
#define IMAGE_GREEN_GEM		@"green"
#define	IMAGE_RED_GEM		@"red"
#define IMAGE_GREY_GEM		@"grey"
#define IMAGE_TRUSTED       @"trusted"
#define IMAGE_TESTED        @"tested"
#define IMAGE_BUNDLE        @"bundle"
#define IMAGE_SM_TINY       @"sm_tiny"
#define IMAGE_SSH           @"ssh"
static CGColorRef CGColorCreateFromNSColor (CGColorSpaceRef 
											colorSpace, NSColor *color)
{
	NSColor *deviceColor = [color colorUsingColorSpaceName: 
							NSDeviceRGBColorSpace];
	float components[4];
	[deviceColor getRed: &components[0] green: &components[1] blue: 
	 &components[2] alpha: &components[3]];
	
	return CGColorCreate (colorSpace, components);
}
@implementation SMThemeInfo

+ (id)sharedTheme
{
	static SMThemeInfo *shared = nil;
	if(shared == nil)
		shared = [[SMThemeInfo alloc] init];
	
	return shared;
}
+ (SMThemeInfo *)sharedInstance
{
    return [[self alloc] init];
}
-(id)tinySMImage
{
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SM_TINY ofType:@"png"]];
}
-(id)softwareMenuImageShelf
{	
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SM_SHELF ofType:@"png"]];
}
-(id)bundleImage
{	
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_BUNDLE ofType:@"png"]];
}
-(id)softwareMenuImage
{	
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SM ofType:@"png"]];
}
-(id)softwareMenuImageTiny
{	
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SM_TINY ofType:@"png"]];
}
-(id)infoImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_INFO ofType:@"png"]] ;
}
-(id)internetImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_INTERNET ofType:@"png"]] ;
}
-(id)powerImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_POWER ofType:@"png"]] ;
}
-(id)refreshImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_REFRESH ofType:@"png"]] ;
}
-(id)standbyImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_STANDBY ofType:@"png"]] ;
}
-(id)trashEmptyImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_TRASH_EMPTY ofType:@"png"]] ;
}
-(id)webImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_WEB ofType:@"png"]] ;
}
-(id)hardDiskImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_HARDDISK ofType:@"png"]] ;
}
-(id)AFPImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_AFP ofType:@"png"]] ;
}
-(id)FTPImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_FTP ofType:@"png"]] ;
}
-(id)VNCImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_VNC ofType:@"png"]] ;
}
-(id)SSHImage
{
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SSH ofType:@"png"]] ;
}
-(id)systemPrefsImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SYS_PREFS ofType:@"png"]] ;
}
-(id)scriptImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SCRIPT ofType:@"png"]] ;
}
-(id)timeMachineImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_TIME_MACHINE ofType:@"png"]] ;
}
-(id)perianImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_PERIAN ofType:@"png"]];
}
-(id)packageImage
{	
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_PACKAGE ofType:@"png"]];
	
}
-(id)folderIcon
{	
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_FOLDER ofType:@"png"]];
}
-(id)licenseImage
{	

	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"license" ofType:@"png"]];
}
-(id)photosImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_PHOTO_HELP ofType:@"png"]];
}
-(id)greenGem
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_GREEN_GEM ofType:@"png"]];
}
-(id)redGem
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_RED_GEM ofType:@"png"]];
}
-(id)greyGem
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_GREY_GEM ofType:@"png"]];
}

-(id)imageForString:(NSString *)imageName
{
	NSArray *imageNames = [NSArray arrayWithObjects:
						   IMAGE_SM,
						   IMAGE_INFO,
						   IMAGE_INTERNET,
						   IMAGE_POWER,
						   IMAGE_REFRESH,
						   IMAGE_STANDBY,
						   IMAGE_TRASH_EMPTY,
						   IMAGE_WEB,
						   IMAGE_HARDDISK,
						   IMAGE_AFP,
						   IMAGE_FTP,
						   IMAGE_VNC,
						   IMAGE_SYS_PREFS,
						   IMAGE_SCRIPT,
						   IMAGE_TIME_MACHINE,
						   IMAGE_PERIAN,
						   IMAGE_PACKAGE,
						   IMAGE_FOLDER,
						   nil];
	int indexOfImage = -1;
	indexOfImage = [imageNames indexOfObject:imageName];
	BRImage *returnImage = nil;
	switch (indexOfImage) {
		case 0:
			returnImage = [self softwareMenuImage];
			break;
		case 1:
			returnImage = [self infoImage];
			break;
		case 2:
			returnImage = [self internetImage];
			break;
		case 3:
			returnImage = [self powerImage];
			break;
		case 4:
			returnImage = [self refreshImage];
			break;
		case 6:
			returnImage = [self standbyImage];
			break;
		case 7:
			returnImage = [self trashEmptyImage];
			break;
		case 8:
			returnImage = [self webImage];
			break;
		case 9:
			returnImage = [self hardDiskImage];
			break;
		case 10 :
			returnImage = [self AFPImage];
			break;
		case 11 :
			returnImage = [self FTPImage];
			break;
		case 12:
			returnImage = [self VNCImage];
			break;
		case 13:
			returnImage = [self systemPrefsImage];
			break;
		case 14:
			returnImage = [self	scriptImage];
			break;
		case 15:
			returnImage = [self timeMachineImage];
			break;
		case 16:
			returnImage = [self perianImage];
			break;
		case 17:
			returnImage = [self packageImage];
			break;
		case 18:
			returnImage = [self folderIcon];
			break;
		default:
			returnImage = [self softwareMenuImage];
			break;
	}
	return returnImage;


}
-(id)trustedImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_TRUSTED ofType:@"png"]] ;
}
-(id)testedImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_TESTED ofType:@"png"]] ;
}
-(id)imageForFrap:(NSString *)frapName
{
    if ([frapName isEqualToString:@"SoftwareMenu"])
        return [self softwareMenuImageShelf];
    
    return [BRImage imageWithPath:[SMGeneralMethods getImagePath:frapName]];
}
- (id)leftJustifiedParagraphTextAttributes
{
	NSMutableDictionary *myDict = [[NSMutableDictionary alloc] init];
	
	BRThemeInfo *theInfo = [[BRThemeInfo sharedTheme] settingsItemSmallTextAttributes];
	id colorObject = [theInfo valueForKey:@"NSColor"];
    NSLog(@"theInfo: %@", theInfo);
    NSLog(@"thecolor: %@",colorObject);
	[myDict setValue:[NSNumber numberWithInt:21] forKey:@"BRFontLines"];
	[myDict setValue:[NSNumber numberWithInt:0] forKey:@"BRTextAlignmentKey"];
	
	if (YES)
	{
		
        
		id sizeObject = [theInfo valueForKey:@"BRFontPointSize"];
		id fontObject = [theInfo valueForKey:@"BRFontName"];
		[myDict setValue:sizeObject forKey:@"BRFontPointSize"];
		[myDict setValue:fontObject forKey:@"BRFontName"];
		//[myDict setValue:[NSNumber numberWithInt:24] forKey:@"BRFontPointSize"];
		//[myDict setValue:@"HelveticaNeueATV-Medium" forKey:@"BRFontName"];
		
	} else {
		[myDict setValue:@"LucidaGrande-Bold" forKey:@"BRFontName"];
	}
	
	[myDict setValue:colorObject forKey:@"NSColor"];
	return [myDict autorelease];
}
- (id)leftJustifiedTitleTextAttributess
{
	NSMutableDictionary *myDict = [[NSMutableDictionary alloc] init];
	
	BRThemeInfo *theInfo = [[BRThemeInfo sharedTheme] settingsItemSmallTextAttributes];
	id colorObject = [theInfo valueForKey:@"NSColor"];
	//NSLog(@"theInfo: %@", theInfo);
//    NSLog(@"theInfo: %@", theInfo);
//    NSLog(@"thecolor: %@",colorObject);
	[myDict setValue:[NSNumber numberWithInt:21] forKey:@"BRFontLines"];
	[myDict setValue:[NSNumber numberWithInt:0] forKey:@"BRTextAlignmentKey"];
	
	if (YES)
	{
		
        
		id sizeObject = [theInfo valueForKey:@"BRFontPointSize"];
		id fontObject = [theInfo valueForKey:@"BRFontName"];
		[myDict setValue:sizeObject forKey:@"BRFontPointSize"];
		[myDict setValue:fontObject forKey:@"BRFontName"];
		//[myDict setValue:[NSNumber numberWithInt:24] forKey:@"BRFontPointSize"];
		//[myDict setValue:@"HelveticaNeueATV-Medium" forKey:@"BRFontName"];
		
	} else {
		[myDict setValue:@"LucidaGrande-Bold" forKey:@"BRFontName"];
	}
	
	[myDict setValue:colorObject forKey:@"NSColor"];
	return [myDict autorelease];
}
-(id)centerJustifiedRedText
{
    NSMutableDictionary *fontDict = [[NSMutableDictionary alloc]init];
    [fontDict setValue:[NSNumber numberWithInt:21] forKey:@"BRFontLines"];
	[fontDict setValue:[NSNumber numberWithInt:2] forKey:@"BRTextAlignmentKey"];
    BRThemeInfo *theInfo = [[BRThemeInfo sharedTheme] settingsItemSmallTextAttributes];
    id sizeObject = [theInfo valueForKey:@"BRFontPointSize"];
    id fontObject = [theInfo valueForKey:@"BRFontName"];
    [fontDict setValue:sizeObject forKey:@"BRFontPointSize"];
    [fontDict setValue:fontObject forKey:@"BRFontName"];
    [fontDict setValue:(NSColor *)[self colorFromNSColor:[NSColor blackColor]] forKey:@"NSColor"];
    return [fontDict autorelease];
}
-(CGColorRef)colorFromNSColor:(NSColor *)color
{
    return CGColorCreateFromNSColor(CGColorSpaceCreateDeviceRGB(), color );
}
+(NSSet *)imageExtensions
{
    return [NSSet setWithObjects:
            @"jpg",
            @"jpeg",
            @"tif",
            @"tiff",
            @"png",
            @"gif",
            nil];
}
@end
