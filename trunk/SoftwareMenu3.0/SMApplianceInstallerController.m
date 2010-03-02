//
//  SMApplianceInstallerController.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/19/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMApplianceInstallerController.h"


@implementation SMApplianceInstallerController
- (void) drawSelf

{
    _gridNames = [[NSMutableArray alloc]init];
    
	[self _removeAllControls];
	//_theSourceText = [[NSString alloc] init];
	//_theSourceText = @"";
	//_header = [[BRHeaderControl alloc] init];
	//_sourceText = [[BRScrollingTextControl alloc] init];
	//_sourceImage = [[BRImageControl alloc] init];
    //_sourceImagel = [[BRCoverArtPreviewControl alloc]init];
    _sourceImages = [[BRImageControl alloc] init];
    _names = [[BRTextControl alloc] init];
//    BRHeaderControl *bla = [[BRHeaderControl alloc]init];
    [_names setText:[_information name] withAttributes:[[BRThemeInfo sharedTheme] menuTitleTextAttributes]];
    CGRect nframe;
    CGRect masterFrame = [[self parent] frame];

    nframe.size = [_names preferredFrameSize];
    nframe.origin.x=masterFrame.origin.x+masterFrame.size.height*0.5f;
    nframe.origin.y=masterFrame.origin.y+masterFrame.size.width*0.5f;
    [_names setFrame:nframe];
    _shelfControl = [[BRMediaShelfControl alloc] init];
    if([SMPreferences threePointZeroOrGreater])
        [_shelfControl setProvider:[self getProviderForGrid]];
    [_shelfControl setColumnCount:7];
    [_shelfControl setCentered:NO];
    
//    _trustedGrid = [[BRGridControl alloc]init];
//    [_trustedGrid setColumnCount:6];
//    [_trustedGrid setHorizontalGap:0.01f];
////    [_trustedGrid setVerticalGap:10];
//    [_trustedGrid setProviderRequester:_trustedGrid];
//    [_trustedGrid setProvider:[self getProviderForGrid]];
//    [_trustedGrid setAcceptsFocus:YES];
//    [_trustedGrid setWrapsNavigation:YES];
//    [_trustedGrid setTopMargin:0.3f];
//    //[_trustedGrid setHorizontalMargins:0.4f];
    CGRect gframe;
    gframe.origin.x=masterFrame.origin.x;//+masterFrame.size.width*0.05f;
    gframe.origin.y=masterFrame.origin.y+masterFrame.size.height*0.04f;
    gframe.size.width=masterFrame.size.width*0.9f;
    gframe.size.height=masterFrame.size.height*0.15f;
    [_shelfControl setFrame:gframe];
    [self addControl:_shelfControl];
    
    CGRect frameCTRL3 = gframe;
    BRDividerControl *ctrl3 = [[BRDividerControl alloc] init];
    [ctrl3 setLineThickness:2];
    [ctrl3 setBrightness:1.0f];
    frameCTRL3.origin.y = gframe.origin.y+gframe.size.height*0.95f;//+[ctrl3 recommendedHeight];//[ctrl2 recommendedHeight]*2.f-nframe.size.height*0.1f-masterFrame.size.height*0.25f;
    frameCTRL3.origin.x = masterFrame.origin.x+masterFrame.size.width*0.05;
    frameCTRL3.size.width=masterFrame.size.width*0.9f;
	frameCTRL3.size.height = [ctrl3 recommendedHeight];
    //frame.size.width = masterFrame.size.width-frame.origin.x-masterFrame.size.width*0.05f;
    [ctrl3 setFrame:frameCTRL3];
    [self addControl: ctrl3];
    
    BRTextControl *op = [[BRTextControl alloc]init];
    [op setText:@"Other Plugins" withAttributes:[[BRThemeInfo sharedTheme] metadataSummaryFieldAttributes]];
    frameCTRL3.origin.y=frameCTRL3.origin.y+[ctrl3 recommendedHeight];
    frameCTRL3.size = [op preferredFrameSize];
    [op setFrame:frameCTRL3];
    [self addControl:op];
    
//    [_trustedGrid setFrame:gframe];
//    [_trustedGrid layoutSubcontrols];
//    NSLog(@"data Count: %i",[_trustedGrid dataCount]);

    
    
//    CGRect framem = masterFrame;
//    framem.origin.y = framem.size.height * 0.9f;
//    framem.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
//    framem.origin.x = framem.origin.x-masterFrame.size.width*0.1f;
//    //nframe.origin.x=masterFrame.origin.x+masterFrame.size.width*0.5f;
////    nframe.origin.y=masterFrame.origin.y+masterFrame.size.height*0.5f;
//    [bla setFrame:framem];
	
	// lay out our UI
	//CGRect frame = masterFrame;
	BRTextControl *control = [[BRTextControl alloc]init];
	// header goes in a specific location
    if([[_information name] isEqualToString:@"nitoTV"])
        [control setText:@"As perian is the swiss army knife of quicktime codecs, nitoTV strives to be swiss knife for the AppleTV. it features both mplayer and quicktime support, mounting network shares, emulators and other applications support, weather and more. It also features a smart installer that can fix almost all the damage done to AppleTV OS by Apple using its smart installer." withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
    else
        [control setText:@"Ac dolor ac adipiscing amet bibendum nullam, massa lacus molestie ut libero nec, diam et, pharetra sodales eget, feugiat ullamcorper id tempor eget id vitae. Mauris pretium eget aliquet, lectus tincidunt. Porttitor mollis imperdiet libero senectus pulvinar. Etiam molestie mauris ligula eget laoreet, vehicula eleifend. Repellat orci eget erat et, sem cum, ultricies sollicitudin amet eleifend dolor nullam erat, malesuada est leo ac.\nAc dolor ac adipiscing amet bibendum nullam, massa lacus molestie ut libero nec, diam et, pharetra sodales eget, feugiat ullamcorper id tempor eget id vitae. Mauris pretium eget aliquet, lectus tincidunt. Porttitor mollis imperdiet libero senectus pulvinar. Etiam molestie mauris ligula eget laoreet, vehicula eleifend. Repellat orci eget erat et, sem cum, ultricies sollicitudin amet eleifend dolor nullam erat, malesuada est leo ac." withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
    if([_information shortDescription]!=nil)
        [control setText:[_information shortDescription] withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
    else
        [control setText:@"no description" withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
    //    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"blah blah blah blah blah blah blah blah balh \n blah \n blah" 
//                                                                 attributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
	//[_header setFrame: frame];
	
	// progress bar goes in a specific place too (one-eighth of the way
	// up the screen)

	
	//[self setTitle: _theName];
	//[self setSourceImage: nil];
	[self addImage];
    [self setupButtons];
    BRCursorControl * hey = [[BRCursorControl alloc] init];
    [self addControl:hey];
    CGRect frame;
    [self addControl: _sourceImages];
    [self addControl: _names];
    BRDividerControl *ctrl = [[BRDividerControl alloc] init];
    [ctrl setLineThickness:5];
    frame.origin.y = nframe.origin.y-[ctrl recommendedHeight];//*1.1f-nframe.size.height*0.1f;
    frame.origin.x = nframe.origin.x;
	frame.size.height = [ctrl recommendedHeight];
    frame.size.width = masterFrame.size.width-frame.origin.x-masterFrame.size.width*0.05f;
    [ctrl setFrame:frame];
    [self addControl: ctrl];

    CGRect tframe=frame;
    tframe.origin.y=frame.origin.y-masterFrame.size.height*0.21f;
    tframe.size.height = masterFrame.size.height*0.2f;
    [control setFrame:tframe];
    [self addControl:control];
    
    
    BRDividerControl *ctrl2 = [[BRDividerControl alloc] init];
    [ctrl2 setLineThickness:5];
    frame.origin.y = nframe.origin.y-[ctrl2 recommendedHeight]*2.f-nframe.size.height*0.1f-masterFrame.size.height*0.25f;
    //frame.origin.x = nframe.origin.x;
	frame.size.height = [ctrl2 recommendedHeight];
    //frame.size.width = masterFrame.size.width-frame.origin.x-masterFrame.size.width*0.05f;
    [ctrl2 setFrame:frame];
    [self addControl: ctrl2];

    BRTextControl *author = [[BRTextControl alloc] init];
    [author setText:@"Author:" withAttributes:[[BRThemeInfo sharedTheme] metadataLabelAttributes]];
    frame.origin.y = frame.origin.y/*-[ctrl recommendedHeight]*/-[author preferredFrameSize].height;
    frame.size = [author preferredFrameSize];
    [author setFrame:frame];
    [self addControl:author];
    
    CGRect frameTwo = frame;
    
    _author = [[BRTextControl alloc]init];
    [_author setText:[_information developer] withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
    frame.origin.y = frame.origin.y-[_author preferredFrameSize].height;
    frame.size = [_author preferredFrameSize];
    [_author setFrame:frame];
    [self addControl:_author];
    
    
    BRTextControl *license = [[BRTextControl alloc] init];
    
    [license setText:@"License:" withAttributes:[[BRThemeInfo sharedTheme] metadataLabelAttributes]];
    frameTwo.origin.y = frameTwo.origin.y;/*-[ctrl recommendedHeight]*///-[license preferredFrameSize].height;
    frameTwo.origin.x = frameTwo.origin.x+masterFrame.size.width*0.15f;
    frameTwo.size = [license preferredFrameSize];
    [license setFrame:frameTwo];
    [self addControl:license];
    
    CGRect frame3 = frameTwo;
    if([_information licenseURL]!=nil)
    {        
        _licenseButton = [BRPhotoBrowserBannerButton button];
        [_licenseButton setText:@"license"];

    }
    else {
        _licenseButton = [[BRTextControl alloc] init];
        [_licenseButton setText:@"No License" withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];        
    }
    frameTwo.origin.y =frameTwo.origin.y-[_licenseButton preferredFrameSize].height;
    frameTwo.size = [_licenseButton preferredFrameSize];
    [_licenseButton setFrame:frameTwo];
    [self addControl:_licenseButton];


        

    
    


    
    BRTextControl *infoB = [[BRTextControl alloc] init];
    [infoB setText:@"Information:" withAttributes:[[BRThemeInfo sharedTheme] metadataLabelAttributes]];
    //frameThree.origin.y = frameTwo.origin.y;/*-[ctrl recommendedHeight]*///-[license preferredFrameSize].height;
    frame3.origin.x = frame3.origin.x+masterFrame.size.width*0.15f;
    frame3.size = [infoB preferredFrameSize];
    [infoB setFrame:frame3];
    [self addControl:infoB];
    
    CGRect frame4 = frame3;
    if([_information informationURL]!=nil)
    {
        _infoButton = [BRPhotoBrowserBannerButton button];
        [_infoButton setText:@"More Info"];
    }
    else {
        _infoButton = [[BRTextControl alloc] init];
        [_infoButton setText:@"No Information" withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
    }
    frame3.origin.y=frame3.origin.y-[_infoButton preferredFrameSize].height;
    frame3.size=[_infoButton preferredFrameSize];
    [_infoButton setFrame:frame3];
    [self addControl:_infoButton];
    
    BRTextControl *releaseD = [[BRTextControl alloc] init];
    [releaseD setText:@"Release Date:" withAttributes:[[BRThemeInfo sharedTheme] metadataLabelAttributes]];
    frame4.origin.x = frame4.origin.x+masterFrame.size.width*0.15f;
    frame4.size = [releaseD preferredFrameSize];
    [releaseD setFrame:frame4];
    [self addControl:releaseD];
    
    BRTextControl *releaseDate = [[BRTextControl alloc] init];
    [releaseDate setText:[_information formatedReleaseDate] withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedTitleTextAttributess]];
    frame4.origin.y=frame4.origin.y-[releaseD preferredFrameSize].height;
    [releaseDate setFrame:frame4];
    [self addControl:releaseDate];
    
    
    
    
    if ([_information isTrusted] && [_information installOnCurrentOS]) {
        NSLog(@"isTRusted and tested");
        CGRect masterFrame = [[self parent] frame];
        CGRect frame;
        frame.size.height= nframe.size.height;
        frame.size.width = nframe.size.height; 
        frame.origin.x = masterFrame.origin.x + masterFrame.size.width *0.95f-frame.size.width;
        frame.origin.y = nframe.origin.y;
        _trustedImage = [[BRImageControl alloc] init];
        [_trustedImage setAutomaticDownsample:YES];
        [_trustedImage setImage:[[SMThemeInfo sharedTheme] trustedImage]];// imageForFrap:[_information name]]];
        [_trustedImage setFrame:frame];
        [_trustedImage retain];
        [self addControl:_trustedImage];
        _testedImage = [[BRImageControl alloc] init];
        
        [_testedImage setAutomaticDownsample:YES];
        [_testedImage setImage:[[SMThemeInfo sharedTheme] testedImage]];// imageForFrap:[_information name]]];
        frame.origin.x=frame.origin.x-frame.size.width*1.2f;
        [_testedImage setFrame:frame];
        [_testedImage retain];
        
        [self addControl:_testedImage];
    }
    else if([_information isTrusted])
    {
        NSLog(@"isTRusted");
        CGRect masterFrame = [[self parent] frame];
        CGRect frame;
        frame.size.height= nframe.size.height;
        frame.size.width = nframe.size.height; 
        frame.origin.x = masterFrame.origin.x + masterFrame.size.width *0.95f-frame.size.width;
        frame.origin.y = nframe.origin.y;
        _trustedImage = [[BRImageControl alloc] init];
        [_trustedImage setAutomaticDownsample:YES];
        [_trustedImage setImage:[[SMThemeInfo sharedTheme] trustedImage]];// imageForFrap:[_information name]]];
        [_trustedImage setFrame:frame];
        [_trustedImage retain];
        [self addControl:_trustedImage];
    }
    else {
        NSLog(@"tested");
        CGRect masterFrame = [[self parent] frame];
        CGRect frame;
        frame.size.height= nframe.size.height;
        frame.size.width = nframe.size.height; 
        frame.origin.x = masterFrame.origin.x + masterFrame.size.width *0.95f-frame.size.width;
        frame.origin.y = nframe.origin.y;

        _testedImage = [[BRImageControl alloc] init];
        
        [_testedImage setAutomaticDownsample:YES];
        [_testedImage setImage:[[SMThemeInfo sharedTheme] testedImage]];// imageForFrap:[_information name]]];
        [_testedImage setFrame:frame];
        [_testedImage retain];
        
        [self addControl:_testedImage];
    }

    //[self addControl:_trustedGrid];


    
    
	//[self customStuff];
    
    
	
	
}
-(id)getProviderForGrid
{
    NSDictionary *loginItemDict = [NSDictionary dictionaryWithContentsOfFile:[SMPreferences trustedPlistPath]];

    int feedCounts=[[loginItemDict allKeys] count];

	
	id currentItems = nil;
	NSString *currentKeys = nil;
	NSArray *sortedArrays;
    [_gridNames removeAllObjects];
    NSSortDescriptor *nameDescriptors = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *ArraySortDescriptor = [NSArray arrayWithObjects:nameDescriptors, nil];
	NSMutableArray *unsortedArray = [NSMutableArray arrayWithObjects:nil];
	int i;
	for (i = 0; i < feedCounts; i++)
	{
		currentKeys = [[loginItemDict allKeys] objectAtIndex:i];
		currentItems = [loginItemDict valueForKey:currentKeys];
		[unsortedArray addObject:currentItems];
	}
	sortedArrays = [unsortedArray sortedArrayUsingDescriptors:ArraySortDescriptor];
    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
    for(i=0;i<[sortedArrays count];i++)
    {
        SMApplianceDictionary *dict = [[SMApplianceDictionary alloc] initWithDictionary:[sortedArrays objectAtIndex:i]];
        if([dict installOnCurrentOS] && [dict hasImage])
        {
            [store addObject:[dict imageAsset]];
            [_gridNames addObject:dict];
        }
    }
//    
//    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
//    NSArray *assets=[SMImageReturns mediaAssetsForPath:[SMPreferences ImagesPath]];
//    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
//    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
//    int i =0;
//    int z = [assets count];
//    if(z>7)
//        z=7;
//    for (i=0;i<z;i++)
//    {
//        [store addObject:[assets objectAtIndex:i]];
//    }
    id dSPfCClass = NSClassFromString(@"BRPhotoDataStoreProvider");
    id tcControlFactory;// = [SMPhotoControlFactory standardFactory];
    if ([SMPreferences threePointZeroOrGreater]) 
        tcControlFactory = [SMPhotoControlFactory standardFactory];
    else
        tcControlFactory = [BRPhotoControlFactory standardFactory];
    id provider    = [dSPfCClass providerWithDataStore:store controlFactory:tcControlFactory];
    return provider;
}
-(void)dealloc
{

    [_information release];
    [_names release];
	[_author release];
	[_backupButton release];
	[_removeBackupButton release];
	[_removeButton release];
	[_installButton release];
	[_restoreButton release];
	[_sourceImages release];
    [_trustedImage release];
    [_testedImage release];
    //[_trustedGrid release];
    if([SMPreferences threePointZeroOrGreater])
    {        
        [_shelfControl release];
        [_gridNames release];


        
    }
    [_licenseButton release];
    [_infoButton release];
    
    [super dealloc];
}
-(void)setupButtons
{
        CGRect frame;
    CGRect framem = [[self parent] frame];
    //[_removeBackupButton release];
  //  NSLog(@"parent of _removebackup: %@",); 
    if([_removeBackupButton parent]!=nil)
    {
        [_removeBackupButton removeFromParent];
        [_restoreButton removeFromParent];
        [_backupButton removeFromParent];
        [_removeButton removeFromParent];
        [_installButton removeFromParent];
    }
    if([_information isBackedUp])
        _removeBackupButton = [SMButtonControl actionButtonWithTitle:@"remove" subtitle:@"backup" badge:nil];
    else
        _removeBackupButton = [SMButtonControl dashedActionButtonWithTitle:@"Cannot remove backup" subtitle:@"no backup" selectable:nil];
    frame.size.height = framem.size.height*0.15f;
    frame.origin.x=framem.origin.x + framem.size.width*0.95f-frame.size.height*1.2f;
    frame.origin.y = framem.origin.y + framem.size.height *0.27f;
    frame.size.width = framem.size.height*0.15;
    //frame.origin.y=frame.origin.y+frame.size.height*1.1f;
    [_removeBackupButton setFrame:frame];
    //[_removeBackupButton retain];
    
    //[_restoreButton release];
    if([_information isBackedUp])
        _restoreButton = [SMButtonControl actionButtonWithTitle:@"restore" subtitle:[_information backupVersion] badge:nil];
    else
        _restoreButton = [SMButtonControl dashedActionButtonWithTitle:@"Cannot restore" subtitle:@"no backup" selectable:nil];
    frame.origin.x=frame.origin.x-frame.size.height*1.2f;
    //frame.origin.y=frame.origin.y+frame.size.height*1.1f;
    [_restoreButton setFrame:frame];
    //[_restoreButton retain];
    
    //[_backupButton release];
    if([_information isInstalled])
        _backupButton = [SMButtonControl actionButtonWithTitle:@"backup" subtitle:[_information installedVersion] badge:nil];
    else
        _backupButton = [SMButtonControl dashedActionButtonWithTitle:@"Cannot backup" subtitle:@"not installed" selectable:NO];
    frame.origin.x=frame.origin.x-frame.size.height*1.2f;
    //frame.origin.y=frame.origin.y+frame.size.height*1.1f;
    [_backupButton setFrame:frame];
    //[_backupButton retain];
    
    //[_removeButton release];
    if([_information isInstalled] && [_information allowedToRemove])
        _removeButton = [SMButtonControl actionButtonWithTitle:@"remove" subtitle:@"installed" badge:nil];
    else if([_information allowedToRemove])
        _removeButton = [SMButtonControl dashedActionButtonWithTitle:@"Cannot remove" subtitle:@"not installed" selectable:NO];
    else
        _removeButton = [SMButtonControl dashedActionButtonWithTitle:@"Cannot remove" subtitle:@"SoftwareMenu" selectable:NO];
    frame.origin.x=frame.origin.x-frame.size.height*1.2f;
    //frame.origin.y=frame.origin.y+frame.size.height*1.1f;
    [_removeButton setFrame:frame];
    //[_removeButton retain];
    

    //[_installButton release];
    if(![_information isInstalled]) // nothing installed
        _installButton = [SMButtonControl actionButtonWithTitle:@"install" subtitle:[_information displayVersion] badge:nil];
    else if([_information isInstalled] && ![_information installedIsUpToDate]) //updates available
        _installButton = [SMButtonControl actionButtonWithTitle:@"update" subtitle:[_information displayVersion] badge:nil];
    else //Up to date
        _installButton = [SMButtonControl dashedActionButtonWithTitle:@"up to date" subtitle:nil selectable:NO];

    frame.origin.x = frame.origin.x - frame.size.height*1.2f;
    
    [_installButton setFrame:frame];
    [self addControl:_installButton];
    [self addControl:_removeButton];
    [self addControl:_backupButton];
    [self addControl:_restoreButton];
    [self addControl:_removeBackupButton];
    [self setFocusedControl:_infoButton];
//    [_infoButton removeFromParent];
//    [_licenseButton removeFromParent];
//    [self addControl:_infoButton];
//    [self addControl:_licenseButton];
    //[_installButton retain];
    



}
-(id)initWithDictionary:(SMApplianceDictionary *)dict
{    
    if ( [super init] == nil )
        return ( nil );
	self = [super init];
    [_information release];
	_information = dict;
    //NSLog(@"theInformation: %@",_theInformation);
	[_information retain];
    return ( self );
}



- (BOOL)brEventAction:(BREvent *)event
{
	int remoteAction =[event remoteAction];
	
	if ([(BRControllerStack *)[self stack] peekController] != self)
		return [super brEventAction:event];
	//NSLog(@"event: %i, value: %i",remoteAction, [event value]);
    
	if([event value] == 0)
		return [super brEventAction:event];
//	if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] && remoteAction>1)
//		remoteAction ++;
	//long row = [self getSelection];
	//NSMutableArray *favorites = nil;
	switch (remoteAction)
	{
		case kBREventRemoteActionPlay:  // tap play
        {
            if([_installButton isFocused])
            {
                //NSLog(@"install");
                [self _install];
            }
            else if([_removeButton isFocused] && [_removeButton isEnabled])
            {
               // NSLog(@"remove");
                [self _handleSelectionWithCode:@"-r"];

            }
            else if([_backupButton isFocused] && [_backupButton isEnabled])
            {
               // NSLog(@"backup is Focused");
                [self _handleSelectionWithCode:@"-backup"];

            }
            else if([_removeBackupButton isFocused] && [_removeBackupButton isEnabled])
            {
               // NSLog(@"remove backup");
                [self _handleSelectionWithCode:@"-rb"];

            }
            else if([_restoreButton isFocused] && [_restoreButton isEnabled])
            {
               // NSLog(@"resotre backup");
                [self _handleSelectionWithCode:@"-restore"];

            }
            else if([_licenseButton isFocused])
            {
                SMInfo * infoController=[[SMInfo alloc] init];
                [infoController setTheName:[NSString stringWithFormat:@"License for %@",[_information name]]];
                [infoController setDescriptionWithURL:[_information licenseURL]];
                ///infoController setTheImage:[BRImage imageWithPath:[SMGeneralMethods getImagePath:[selectedOption valueForKey:NAME_KEY]]]];
                [infoController setTheImage:[[SMThemeInfo sharedTheme] licenseImage]];
                [[self stack] pushController:infoController];
                
            }
            else if([_infoButton isFocused])
            {
                //NSLog(@"info");
                SMInfo *infoController=[[SMInfo alloc] init];
                [infoController setTheName:[_information name]];
                [infoController setDescriptionWithURL:[_information informationURL]];
                [infoController setTheImage:[BRImage imageWithPath:[SMGeneralMethods getImagePath:[_information name]]]];
                [[self stack]pushController:infoController];
            }
            else if([_shelfControl isFocused])
            {
                //NSLog(@"shelf is focused: %@", [_shelfControl focusedControl]); 
                [self _handleSelectionForShelf];
            }
                
            break;
        }
            case kBREventRemoteActionMenu:
        {
            if(_downloader !=nil)
            {
                [self cancelDownload];
                return nil;

            }
            break; 
        }


	}
	return [super brEventAction:event];
}
-(void)_handleSelectionWithCode:(NSString *)code
{
   // NSLog(@"code : %@",code);
    NSArray *taskArray = [NSArray arrayWithObjects:code,[[_information name] stringByAppendingPathExtension:@"frappliance"],@"0",nil];
    [SMGeneralMethods runHelperApp:taskArray];
    [self setupButtons];
    //[_backupButton setButtonStyle:3];
    //[self setupButtonsCrap];
}
-(void)_handleSelectionForShelf
{
    int i =[_shelfControl focusedIndex];
    //NSLog(@"control: %@",[[_gridNames objectAtIndex:i] name]);
    SMApplianceInstallerController *a = [[SMApplianceInstallerController alloc]initWithDictionary:[_gridNames objectAtIndex:i]];
    [[self stack] swapController:a];
}
-(void)_install
{
    _progressBar =[[SMProgressBarControl alloc]init];
    CGRect framem=[[self parent] frame];
    CGRect frame =framem;
    frame.origin.x=frame.origin.x+frame.size.width*0.05f;
    frame.origin.y=frame.origin.y+frame.size.height*0.27f;
    frame.size.width=frame.size.width*0.2f;
    frame.size.height=frame.size.height*0.1f;
    [_progressBar setFrame:frame];
    [self addControl:_progressBar];
    _statusText = [[BRTextControl alloc]init];
    
    if([self beginDownload])
    {
        [self setStatusText:@"Downloading"];
       // NSLog(@"Download Beginning");
    }
}
-(void)addImage
{

       // NSString *appPng = nil;
//    NSString * b = [[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SM_SHELF ofType:@"png"];
//    BRPhotoMediaAsset *a = [[BRPhotoMediaAsset alloc] init];
//    [a setFullURL:b];
//    [a setCoverArtURL:b];
//    [a setThumbURL:b];
    //[a imageProxy];
    //[_sourceImagel setImageProxy:[a imageProxy]];
        //appPng = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"png"];
//
//        if(![[NSFileManager defaultManager] fileExistsAtPath:appPng])
//            appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
//        
//        id sp= [[SMThemeInfo sharedTheme] softwareMenuImageShelf]
//
//            [_sourceImage setImage:sp];
//        if(_theImage !=nil)
    BRImage *image=[[SMThemeInfo sharedTheme] imageForFrap:[_information name]];
            [_sourceImages setImage:image];
        [_sourceImages setAutomaticDownsample:YES];
        CGRect masterFrame = [[self parent] frame];
        float aspectRatio = [image aspectRatio];
        CGRect frame;
        frame.origin.x = masterFrame.size.width *0.05f;
        frame.origin.y = masterFrame.size.height *0.4f;
        frame.size.width = masterFrame.size.height*0.4f; 
        frame.size.height= masterFrame.size.height*0.4f;
        frame.size.height= frame.size.width/aspectRatio;
        if (frame.size.height>masterFrame.size.height*0.55f)
            frame.size.height=masterFrame.size.height*0.55f;
        [_sourceImages setFrame: frame];
    //[_sourceImagel setFrame:frame];
        
}
//-(void)layoutImage
//{
//    [_imageControl removeFromParent];
//    if (_image==nil)
//        _image = [[BRThemeInfo sharedTheme] appleTVIcon];
//    [_imageControl setImage:_image];
//    [_imageControl setAutomaticDownsample:YES];
//	CGRect masterFrame = [self getMasterFrame];
//    float aspectRatio = [_image aspectRatio];
//	CGRect frame;
//	frame.origin.x = masterFrame.size.width *0.7f;
//	frame.origin.y = masterFrame.size.height *0.3f;
//	frame.size.width = masterFrame.size.height*0.4f; 
//	frame.size.height= frame.size.width/aspectRatio;
//    [_imageControl setFrame:frame];
//    [self addControl:_imageControl];
//}
-(void)controlWasActivated
{
	[self drawSelf];
    [super controlWasActivated];
}

@end
