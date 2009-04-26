//
//  QuDownloadController.m
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

#import "SoftwarePasscodeController.h"
#import "BRLocalizedString.h"
////#import <BackRow/BackRow.h>


@implementation SoftwarePasscodeController
- (id) init {
    if ( [super init] == nil )
        return ( nil );
	self = [super init];
	_passData = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    return ( self );
}
- (id)initWithTitle:(NSString *)title withDescription:(NSString *)description withBoxes:(int)boxes withKey:(NSString *)key
{
	self = [super init];
	_passData = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	if(title !=nil)
		[_passData setObject:title forKey:TITLE_KEY];
	if(description != nil)
		[_passData setObject:description forKey:DESCRIPTION_KEY];
	if(boxes !=nil)
		[_passData setObject:[NSNumber numberWithInt:boxes] forKey:NUMBER_BOXES_KEY];
	else
		[_passData setObject:[NSNumber numberWithInt:4] forKey:NUMBER_BOXES_KEY];
	if(key !=nil)
	{
		[_passData setObject:key forKey:KEY_KEY];
		[_passData	setObject:[NSNumber numberWithBool:NO] forKey:DEFAULT_KEY];
	}
	else
	{
		[_passData	setObject:[NSNumber numberWithBool:YES] forKey:DEFAULT_KEY];
	}
	[_passData retain];
	return self;

}

- (void) dealloc
{
    //[self cancelDownload];
	[_image release];
    	[_passData release];
    [super dealloc];
}


-(void)controlWasActivated
{
	[self drawSelf];
    [super controlWasActivated];
	
}
-(void)setImage:(BRImage *)image
{
	[_image release];
	_image = image;
	[_image retain];
}

- (void)setDescription:(NSString *)description
{
	[_passData setObject:description forKey:DESCRIPTION_KEY];
	NSLog(@"_passData %@",_passData);
}
- (void)setChangeOrder:(NSString *)path
{
	[_passData setObject:path forKey:@"changeOrderPath"];
}
- (void)setTitle:(NSString *)title
{
	NSLog(@"setTitle: %@",title);
	[_passData setObject:title forKey:TITLE_KEY];
	NSLog(@"_passData %@",_passData);
	
}
-(void)setNumberOfBoxes:(int)boxes
{
	[_passData setObject:[NSNumber numberWithInt:boxes] forKey:NUMBER_BOXES_KEY];
	NSLog(@"_passData %@",_passData);
	
}
- (void)setKey:(NSString *)key
{
	
	[_passData setObject:key forKey:KEY_KEY];
}

- (void)setWriteToDefault:(BOOL)defaults;
{
	[_passData	setObject:[NSNumber numberWithBool:defaults] forKey:DEFAULT_KEY];
}

-(void)drawSelf
{
	id theTheme = [BRThemeInfo sharedTheme];
	BRHeaderControl *theHeader = [[BRHeaderControl alloc] init];
	
	[self addControl:theHeader];
	
	[theHeader setTitle:[self getTitle]];
	if(_image != nil)
		[theHeader setIcon:_image horizontalOffset:0.5f kerningFactor:0.2f];
	BRTextControl *firstTextControl = [[BRTextControl alloc] init];
	
	[self addControl:firstTextControl];
	
	[firstTextControl setText:[NSString stringWithFormat:[self getDescription]] withAttributes:[[BRThemeInfo sharedTheme] promptTextAttributes]];
	
	NSRect master ;
	if ([[SMGeneralMethods sharedInstance] usingTakeTwoDotThree]){
		master  = [[self parent] frame];
	} else {
		master = [self frame];
	}
    
	NSRect frame = master;
	frame.origin.y = frame.size.height * 0.60;
	
	
	// position it near the top of the screen (remember, origin is
    // lower-left)
    frame.origin.y = frame.size.height * 0.82f;
    frame.size.height = [theTheme listIconHeight];
    [theHeader setFrame: frame];
	
	id timeControls = nil;
	timeControls = [[BRPasscodeEntryControl alloc] initWithNumDigits:[self getNumberOfBoxes]
														userEditable:YES 
														  hideDigits:NO];
	
	
	[self addControl:timeControls];
	
	CGDirectDisplayID display = [[BRDisplayManager sharedInstance] display];
	NSRect testFrame;
	NSRect firstFrame;
	
	firstFrame.size = [firstTextControl renderedSize];
    firstFrame.origin.y = master.origin.y + (master.size.height * 0.72f);
    //firstFrame.origin.x = NSMinX(master) + (NSMaxX(master) * 1.0f/ 2.42f);
	firstFrame.origin.x = NSMaxX(master)*0.5f-firstFrame.size.width*0.5f+NSMinX(master);
	[firstTextControl setFrame: firstFrame];
	
	NSSize frameSize;
	
	frameSize.width = CGDisplayPixelsWide( display );
    frameSize.height = CGDisplayPixelsHigh( display );
	
	if (![self is1080i])
	{
		testFrame.size = [timeControls preferredSizeFromScreenSize:frameSize];
	} else {
		testFrame.size = [timeControls preferredSizeFromScreenSize:[self sizeFor1080i]];
	}
	
	
    testFrame.origin.y = master.origin.y + (master.size.height * 0.40f);
    testFrame.origin.x = NSMinX(master) + (NSMaxX(master) * 1.0f/ 3.62f);
	[timeControls setFrame:testFrame];
	[timeControls setDelegate:self];	
	NSLog(@"passData1: %@",_passData);
	
}
- (BOOL)is1080i
{
	NSString *displayUIString = [BRDisplayManager currentDisplayModeUIString];
	NSArray *displayCom = [displayUIString componentsSeparatedByString:@" "];
	NSString *shortString = [displayCom objectAtIndex:0];
	if ([shortString isEqualToString:@"1080i"])
		return YES;
	else
		return NO;
}

- (NSSize)sizeFor1080i
{
	
	NSSize currentSize;
	currentSize.width = 1280.0f;
	currentSize.height = 720.0f;
	
	
	return currentSize;
}
- (void) textDidChange: (id<BRTextContainer>) sender
{
}

- (void) textDidEndEditing: (id) sender
{
	NSLog(@"done");
	//[_passData writeToFile:@"/Users/frontrow/passData" atomically:YES];
	NSLog(@"passData: %@",_passData);
	if([self getChangePath]!=nil)
	{
		[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-changeOrder", [self getChangePath] ,[sender stringValue],nil]];
		NSLog(@"change order of: %@ to %@",[self getChangePath],[sender stringValue],nil);
	}
	else if([self getKey]!=nil && ![self defaults])
	{
		NSLog(@"setting");
		[SMGeneralMethods setInteger:[[sender stringValue] intValue] forKey:[self getKey]];
	}
	else if ([self defaults])
	{
		[SMGeneralMethods setInteger:[[sender stringValue] intValue] forKey:@"defaultReturn"];
	}
	[[self stack] popController];
	//[SMGeneralMethods setInteger:[[sender stringValue] intValue] forKey:PHOTO_SPIN_FREQUENCY];
	
}
-(BOOL)defaults
{
	NSLog(@"defaults");
	if([[_passData objectForKey:DEFAULT_KEY] boolValue])
		return YES;
	return NO;
}
-(NSString *)getKey
{
	NSString *key = nil;
	NSLog(@"getKey");
	key = [_passData valueForKey:KEY_KEY];
	return [key autorelease];
}
-(NSString *)getChangePath
{
	return [_passData objectForKey:@"changeOrderPath"];
}
-(NSString *)getTitle
{
	NSString *title = nil;
	title = [_passData valueForKey:TITLE_KEY];
	if(title == nil)
		title = @"Empty Title";
	return [title autorelease];
}
-(int)getNumberOfBoxes
{
	int boxes = 4;
	if([[_passData allKeys]containsObject:NUMBER_BOXES_KEY])
	{
		NSLog(@"custom boxes");
		boxes = [[_passData valueForKey:NUMBER_BOXES_KEY] intValue];
	}
	return boxes;
}
-(NSString *)getDescription
{
	NSString *description = nil;
	description = [_passData valueForKey:DESCRIPTION_KEY];
	if(description == nil)
		description = @"Empty Title";
	return [description autorelease];
}


@end
