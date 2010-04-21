//
//  SMFTheme.m
//  SoftwareMenuFramework
//
//  Created by Thomas on 4/19/09.
//  Copyright 2010 Thomas Cool. All rights reserved.
//
//CGColorRef CGColorCreateFromNSColor (CGColorSpaceRef colorSpace, NSColor *color);
static CGColorRef CGColorCreateFromNSColor (CGColorSpaceRef 
											colorSpace, NSColor *color)
{
	NSColor *deviceColor = [color colorUsingColorSpaceName: 
							NSDeviceRGBColorSpace];
	float components[4];
	[deviceColor getRed: &components[0] green: &components[1] blue: 
	 &components[2] alpha: &components[3]];
	
	return CGColorCreate(colorSpace, components);
}

@implementation SMFThemeInfo

+(NSSet *)coverArtExtensions
{
    return [NSSet setWithObjects:@"jpg",@"jpeg",@"tif",@"tiff",@"png",@"gif",nil];
}
+ (id)sharedTheme
{
	static SMFThemeInfo *shared = nil;
	if(shared == nil)
		shared = [[SMFThemeInfo alloc] init];
	
	return shared;
}
+ (SMFThemeInfo *)sharedInstance
{
    return [[self alloc] init];
}
-(id)infoImage {
    
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_INFO ofType:@"png"]] ;
}
-(id)notFoundImage
{
    return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_NOT_FOUND ofType:@"png"]] ;
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
-(id)systemPrefsImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SYS_PREFS ofType:@"png"]] ;
}
-(id)scriptImage
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SCRIPT ofType:@"png"]] ;
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

-(id)greenGem
{
    //NSLog(@"%@, %@ %@",[self class],[NSBundle bundleForClass:[self class]],[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_GREEN_GEM ofType:@"png"]);

	return [BRImage imageWithPath:[[NSBundle bundleForClass:[SMFFolderBrowser class]] pathForResource:IMAGE_GREEN_GEM ofType:@"png"]];
}
-(id)redGem
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[SMFFolderBrowser class]] pathForResource:IMAGE_RED_GEM ofType:@"png"]];
}
-(id)greyGem
{
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[SMFFolderBrowser class]] pathForResource:IMAGE_GREY_GEM ofType:@"png"]];
}


-(id)trustedImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_TRUSTED ofType:@"png"]] ;
}
-(id)testedImage {
	return [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_TESTED ofType:@"png"]] ;
}
//-(id)imageForFrap:(NSString *)frapName
//{
//    if ([frapName isEqualToString:@"SoftwareMenu"])
//        return [self softwareMenuImageShelf];
//    
//    return [BRImage imageWithPath:[SMGeneralMethods getImagePath:frapName]];
//}
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
    [fontDict setObject:CGColorCreateFromNSColor(CGColorSpaceCreateDeviceRGB(), [NSColor blackColor] ) forKey:@"NSColor"];
    return [fontDict autorelease];
}
//-(id)imageForFrap:(NSString *)frapName
//{
//    return [BRImage imageWithPath:[SMFSharedMethods getImagePath:frapName]];
//}
-(CGColorRef)colorFromNSColor:(NSColor *)color
{
    return CGColorCreateFromNSColor(CGColorSpaceCreateDeviceRGB(), color );
}
@end
