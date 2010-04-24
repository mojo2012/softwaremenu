//
//  QuDownloadController.m
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

#import "SMInfo.h"

@interface BRTextControl (protectedAccess)
-(id)text;
@end
//@interface BRScrollingTextControl (protectedAccess)
//-(id)text;
//@end


@implementation SMInfo
- (void)setTheName:(NSString *)theName
{
	[_theName release];
	_theName=theName;
	[_theName retain];
}
- (void)setTheImage:(BRImage *)theImage
{
	[_theImage release];
	_theImage = theImage;
	[_theImage retain];
	
}
-(void)setVersions:(NSString *)theOnlineVersion withBak:(NSString *)theBackupVersion withCurrent:(NSString *)theInstalledVersion
{
	if([theBackupVersion length]==0)
	{
		theBackupVersion =@"0.0 -- Not Backed up";
	}
	//NSLog(@"%@,%@,%@",theOnlineVersion,theBackupVersion,theInstalledVersion);
	_theVersions=[[NSArray alloc] initWithObjects:theOnlineVersion,theBackupVersion,theInstalledVersion,nil];
	[_theVersions retain];
}
-(void)setDescriptionWithURL:(NSString *)theDescriptionURL
{
	NSString *hello=[[NSString alloc] init];
    if(theDescriptionURL ==nil)
    {
        hello = @"Nothing Added";
    }
    else {
        if([theDescriptionURL isEqualToString:@"No description added"])
        {
            hello=@"No description added";
        }
        else
        {
            hello = [[NSString alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:theDescriptionURL] encoding:NSUTF8StringEncoding error:NULL];
            if([hello length]==0)
            {
                hello=@"The info file posted at the following URL does not exist";
            }
        }
    }

	
	//NSLog(@"hello:%@",hello);
	[self setDescription:hello];
}
-(void)setDescriptionWithFile:(NSString *)theDescriptionFile
{
	NSString *hello=[[NSString alloc] init];
	if([theDescriptionFile isEqualToString:@"No description added"])
	{
		hello=@"No description added";
	}
	else
	{
		hello = [[NSString alloc] initWithContentsOfFile:theDescriptionFile];
		if([hello length]==0)
		{
			hello=@"The info file posted at the following path does not exist";
		}
	}
	//NSLog(@"hello:%@",hello);
	[self setDescription:hello];
}
-(void)setDescription:(NSString *)theDescription
{
	[_theDescription release];
	_theDescription=[theDescription copy];
	[_theDescription retain];
}

- (void) drawSelf

{
	
	_theSourceText = [[NSString alloc] init];
	_theSourceText = @"";
	_header = [[BRHeaderControl alloc] init];
	_sourceText = [[BRScrollingTextControl alloc] init];
	_sourceImage = [[BRImageControl alloc] init];
	
	
	// lay out our UI
	CGRect masterFrame = [[self parent] frame];
	CGRect frame = masterFrame;
	
	// header goes in a specific location
	frame.origin.y = frame.size.height * 0.82f;
	frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
	[_header setFrame: frame];
	
	// progress bar goes in a specific place too (one-eighth of the way
	// up the screen)
	frame.size.width = masterFrame.size.width * 0.45f;
	frame.size.height = ceilf( frame.size.width * 0.068f );
	frame.origin.x = (masterFrame.size.width - frame.size.width) * 0.5f;
	frame.origin.y = masterFrame.origin.y + (masterFrame.size.height * (1.0f / 8.0f));
	
	[self setTitle: _theName];
	[self setSourceImage: _theName];
	//[self setSourceText: @"hello"];   // this lays itself out
	[self setSourceText:@"hello"];
	//NSLog(@"theDescription:%@",_theDescription);
	[self appendSourceText: _theDescription];
    

	//shrinksize.width=
	//[_sourceText shrinkTextToFitInBounds:{masterFrame.size.width*0.4f;masterFrame.size.height*0.45f;};]
	
	// add the controls
	[self addControl: _sourceText];
    [self addControl: _header];
    [self addControl: _sourceImage];
    [_sourceText layoutSubcontrols];

	//[self customStuff];


	
	
}


- (id) init {
    if ( [super init] == nil )
        return ( nil );
	self = [super init];
	_passData = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    return ( self );
}
-(void)customStuff
{
	/*_currentvers = [[BRTextControl alloc] init];
	_onlinevers = [[BRTextControl alloc] init];
	_bakvers = [[BRTextControl alloc] init];
	[self setBakVers: [_theVersions objectAtIndex:1]];
	[self setCurrVers:[_theVersions objectAtIndex:2]];
	[self setOnlineVers:[_theVersions objectAtIndex:0]];
	[self addControl:_bakvers];
	[self addControl:_currentvers];
	[self addControl:_onlinevers];*/
	
}

- (void) dealloc
{
    //[self cancelDownload];
	
    [_header release];
    [_sourceText release];
	[_sourceImage release];
	[_bakvers release];
	[_currentvers release];
	[_onlinevers release];
	[_theVersions release];
	[_theName release];
	[_theDescriptionURL release];
    [super dealloc];
}


-(void)controlWasActivated
{
	[self drawSelf];
    [super controlWasActivated];
	
}



// stack callbacks


- (void) setTitle: (NSString *) title
{
    [_header setTitle: title];
}

- (NSString *) title
{
    return ( [_header title] );
}
- (void) setSourceImage: (NSString *)name
{
        NSString *appPng = nil;
	if(_theImage !=nil)
		[_sourceImage setImage:_theImage];
    else {

        
        appPng = [[SMThemeInfo sharedTheme] imageForFrap:name];
        if([name isEqualToString:@"README"])
        {
            appPng = @"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/appleTVImage.png";
        }
        if(![[NSFileManager defaultManager] fileExistsAtPath:appPng])
            appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
        
        id sp= [BRImage imageWithPath:appPng];
        if([name isEqualToString:@"imageProvided"])
        {
            [_sourceImage setImage:_theImage];
        }
        else
        {
            [_sourceImage setImage:sp];
        }
    }

	[_sourceImage setAutomaticDownsample:YES];
	CGRect masterFrame = [[self parent] frame];
	CGRect frame;
	frame.origin.x = masterFrame.size.width *0.7f;
	frame.origin.y = masterFrame.size.height *0.25f;
	frame.size.width = masterFrame.size.height*0.4f; 
	frame.size.height= masterFrame.size.height*0.4f;
	[_sourceImage setFrame: frame];
	
}
- (void) appendSourceText: (NSString *)srcText
{
	//NSLog(@"appending: %@",srcText);
	_theSourceText = [_theSourceText stringByAppendingString:[NSString stringWithFormat:@"\n%@",srcText]];
	[self setSourceText:_theSourceText];
}

- (void) setSourceText: (NSString *) srcText
{
	//   [_sourceText setTextAttributes: [[BRThemeInfo sharedTheme] paragraphTextAttributes]];
    //[_sourceText setText: srcText withAttributes:[[BRThemeInfo sharedTheme] paragraphTextAttributes]];
	
//	NSAttributedString *srcsText =[[NSAttributedString alloc]initWithString:srcText attributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
	[_sourceText setText:srcText];
    // layout this item
	BRPasscodeEntryControl *hello = [[BRPasscodeEntryControl alloc] initWithNumDigits:4 userEditable:YES hideDigits:NO];
	[hello setDelegate:self];

    CGRect masterFrame = [[self parent] frame];
	
	// [_sourceText setMaximumSize: NSMakeSize(masterFrame.size.width * 0.66f,
	//                                       masterFrame.size.height)];
	
	// CGSize txtSize = [_sourceText renderedSize];
	
    CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.01f;
    frame.origin.y = (masterFrame.size.height * 0.01);// - txtSize.height;
    //frame.size = txtSize;
    frame.size.width = masterFrame.size.width*0.72f;
	frame.size.height = masterFrame.size.height*0.95f;
	//struct CGSize shrinksize;
	//shrinksize.width=
	//[_sourceText shrinkTextToFitInBounds:{masterFrame.size.width*0.4f;masterFrame.size.height*0.45f;};]
	//[hello setKeyboardTitle:@"one"];
	
	//[hello setFrame:frame];
	[_sourceText setFrame: frame];
}
- (void) setBakVers: (NSString *) srcText
{
    [_bakvers setText:[[NSString alloc]initWithFormat:@"Backup Vers: %@",srcText] withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];

    CGRect masterFrame = [[self parent] frame];

	
    CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.7f;
    frame.origin.y = (masterFrame.size.height * 0.35);// - txtSize.height;

    frame.size.width = masterFrame.size.width*0.25f;
	frame.size.height = masterFrame.size.height*0.07f;

	[_bakvers setFrame: frame];
}
- (void) setCurrVers: (NSString *) srcText
{
    [_currentvers setText:[[NSString alloc]initWithFormat:@"Installed Vers: %@",srcText] withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
	
    CGRect masterFrame = [[self parent] frame];
	
	
    CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.7f;
    frame.origin.y = (masterFrame.size.height * 0.28);// - txtSize.height;
	
    frame.size.width = masterFrame.size.width*0.25f;
	frame.size.height = masterFrame.size.height*0.07f;
	
	[_currentvers setFrame: frame];
}
- (void) setOnlineVers: (NSString *) srcText
{
    [_onlinevers setText:[[NSString alloc]initWithFormat:@"Online Vers: %@",srcText] withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
	
    CGRect masterFrame = [[self parent] frame];
	
	
    CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.7f;
    frame.origin.y = (masterFrame.size.height * 0.21);// - txtSize.height;
	
    frame.size.width = masterFrame.size.width*0.25f;
	frame.size.height = masterFrame.size.height*0.07f;
	
	[_onlinevers setFrame: frame];
}

-(id)sourceImage
{
	return ([_sourceImage image]);
}
-(NSString *)backVers
{
	return ([_bakvers text]);
}
-(NSString *)currVers
{
	return ([_currentvers text]);
}
-(NSString *)onlineVers
{
	return ([_onlinevers text]);
}

- (NSString *) sourceText
{
    return ( [[_sourceText attributedString]string] );
}
/*- (void)textDidChange:(id)fp8
{
	
}
- (void)textDidEndEditing:(id)fp8
{
	[[self stack] popController];
}*/

@end
@implementation SMLog
- (void) drawSelf
{
	
	_theSourceText = [[NSString alloc] init];
	_theSourceText = @"";
	_header = [[BRHeaderControl alloc] init];
	_sourceText = [[BRScrollingTextControl alloc] init];
	//_sourceImage = [[BRImageControl alloc] init];
	
	
	
	// lay out our UI
	CGRect masterFrame = [[self parent] frame];
	CGRect frame = masterFrame;
	
	// header goes in a specific location
	frame.origin.y = frame.size.height * 0.82f;
	frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
	[_header setFrame: frame];
	
	// progress bar goes in a specific place too (one-eighth of the way
	// up the screen)
	frame.size.width = masterFrame.size.width * 0.45f;
	frame.size.height = ceilf( frame.size.width * 0.068f );
	frame.origin.x = (masterFrame.size.width - frame.size.width) * 0.5f;
	frame.origin.y = masterFrame.origin.y + (masterFrame.size.height * (1.0f / 8.0f));
	
	
	[self setTitle: _theName];
	//[self setSourceImage: _theName];
	
	//[self setSourceText: @"hello"];   // this lays itself out
	
	
	[self appendSourceText: _theDescription];
	
	// add the controls
	
	[self addControl: _sourceText];
	[self addControl: _header];
	//[self addControl: _sourceImage];
	//[self customStuff];
}
-(void) setSourceText: (NSString *) srcText
{
	[_sourceText setText:srcText];
    CGRect frame;
	CGRect masterFrame = [[self parent] frame];
    frame.origin.x = masterFrame.size.width  * 0.05f;
    frame.origin.y = (masterFrame.size.height * 0.05f);// - txtSize.height;
    frame.size.width = masterFrame.size.width*0.9f;
	frame.size.height = masterFrame.size.height*0.80f;
	[_sourceText setFrame: frame];
}

@end
