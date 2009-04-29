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
	_header = [[BRHeaderControl alloc] init];
	_passData = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	_firstText = [[BRTextControl alloc] init];

    return ( self );
}
- (id)initWithTitle:(NSString *)title withDescription:(NSString *)description withBoxes:(int)boxes withKey:(NSString *)key
{
	self = [super init];
	_passData = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	_header = [[BRHeaderControl alloc] init];
	_firstText = [[BRTextControl alloc] init];

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
	[_entryControl release];
	[_header release];
	[_firstText release];
    [super dealloc];
}


-(void)controlWasActivated
{
	[self drawSelf];
    [super controlWasActivated];
	
}
-(void)setBRImage:(BRImage *)image
{
	[_image release];
	_image = image;
	[_image retain];
}
- (void)setInitialValue:(int)value
{
	NSString *theString=nil;
	switch([[_passData objectForKey:NUMBER_BOXES_KEY] intValue])
	{
		case 1:
			theString = [NSString stringWithFormat:@"%01i", value];
			break;
		case 2:
			theString = [NSString stringWithFormat:@"%02i", value];
			break;
		case 3:
			theString = [NSString stringWithFormat:@"%03i", value];
			break;
		case 4:
			theString = [NSString stringWithFormat:@"%04i", value];
			break;
		case 5:
			theString = [NSString stringWithFormat:@"%05i", value];
			break;
		case 6:
			theString = [NSString stringWithFormat:@"%06i", value];
			break;
			
	}
	NSLog(@"initValue: %i",value);
	[_passData setObject:theString forKey:@"initValue"];
}
- (void)setDescription:(NSString *)description
{
	[_passData setObject:description forKey:DESCRIPTION_KEY];
}
- (void)setChangeOrder:(NSString *)path
{
	[_passData setObject:path forKey:@"changeOrderPath"];
}
- (void)setValue:(id)value forKey:(NSString *)key
{
	[_passData setObject:value forKey:key];
}
- (void)setTitle:(NSString *)title
{
	[_passData setObject:title forKey:TITLE_KEY];
	
}
-(void)setNumberOfBoxes:(int)boxes
{
	[_passData setObject:[NSNumber numberWithInt:boxes] forKey:NUMBER_BOXES_KEY];
	
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
	
	[self addControl:_header];
	
	[_header setTitle:[self getTitle]];
	if(_image != nil)
		[_header setIcon:_image horizontalOffset:0.5f kerningFactor:0.2f];
	
	[self addControl:_firstText];
	
	[_firstText setText:[NSString stringWithFormat:[self getDescription]] withAttributes:[[BRThemeInfo sharedTheme] promptTextAttributes]];
	
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
    [_header setFrame: frame];
	
	_entryControl = nil;
	_entryControl = [[BRPasscodeEntryControl alloc] initWithNumDigits:[self getNumberOfBoxes]
														userEditable:YES 
														  hideDigits:NO];
	
	
	[self addControl:_entryControl];
	if([_passData valueForKey:@"initValue"]!=nil)
	{
		[_entryControl setInitialPasscode:[_passData valueForKey:@"initValue"]];
		NSLog(@"drawself: %@",[_passData valueForKey:@"initValue"]);
	}
	CGDirectDisplayID display = [[BRDisplayManager sharedInstance] display];
	NSRect testFrame;
	NSRect firstFrame;
	
	firstFrame.size = [_firstText renderedSize];
    firstFrame.origin.y = master.origin.y + (master.size.height * 0.72f);
    //firstFrame.origin.x = NSMinX(master) + (NSMaxX(master) * 1.0f/ 2.42f);
	firstFrame.origin.x = NSMaxX(master)*0.5f-firstFrame.size.width*0.5f+NSMinX(master);
	[_firstText setFrame: firstFrame];
	
	NSSize frameSize;
	
	frameSize.width = CGDisplayPixelsWide( display );
    frameSize.height = CGDisplayPixelsHigh( display );
	
	if (![self is1080i])
	{
		testFrame.size = [_entryControl preferredSizeFromScreenSize:frameSize];
	} else {
		testFrame.size = [_entryControl preferredSizeFromScreenSize:[self sizeFor1080i]];
	}
	
	
    testFrame.origin.y = master.origin.y + (master.size.height * 0.40f);
    //testFrame.origin.x = NSMinX(master) + (NSMaxX(master) * 1.0f/ 3.62f);
	testFrame.origin.x = NSMinX(master) +NSMaxX(master)*0.5f-testFrame.size.width*([[_passData valueForKey:NUMBER_BOXES_KEY] floatValue]*0.5f)/([[_passData valueForKey:NUMBER_BOXES_KEY] floatValue]+0.6f);
	[_entryControl setFrame:testFrame];
	[_entryControl setDelegate:self];		
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
	if([[_passData allKeys] containsObject:@"options"])
	{
		//Specific options
		switch ([[_passData valueForKey:@"options"] intValue])
		{
			case 1:
				[[BRSettingsFacade singleton] setSlideshowSecondsPerSlide:[[sender stringValue] intValue]];
				break;
		}
	}
	else if([self getChangePath]!=nil)
	{
		// FrapMover change position
		[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-changeOrder", [self getChangePath] ,[sender stringValue],nil]];
	}
	else if([self getKey]!=nil && ![self defaults])
	{
		//SoftwareMenu Preferences values
		[SMGeneralMethods setInteger:[[sender stringValue] intValue] forKey:[self getKey]];
	}
	else if ([self defaults])
	{
		//Finally, default return if nothing else was asked for
		[SMGeneralMethods setInteger:[[sender stringValue] intValue] forKey:@"defaultReturn"];
	}
	[[self stack] popController];	
}
-(BOOL)defaults
{
	if([[_passData objectForKey:DEFAULT_KEY] boolValue])
		return YES;
	return NO;
}
-(NSString *)getKey
{
	NSString *key = nil;
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
	return [title autorelease];
}
-(int)getNumberOfBoxes
{
	int boxes = 4;
	if([[_passData allKeys]containsObject:NUMBER_BOXES_KEY])
	{
		boxes = [[_passData valueForKey:NUMBER_BOXES_KEY] intValue];
	}
	return boxes;
}
-(NSString *)getDescription
{
	NSString *description = nil;
	description = [_passData valueForKey:DESCRIPTION_KEY];
	return [description autorelease];
}


@end
