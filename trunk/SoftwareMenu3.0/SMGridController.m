//
//  BRGridController.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/5/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMGridController.h"

#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"


@implementation SMGridController
-(id)initWithPath:(NSString *)path
{
    return self;
}

- (void) drawSelf
{
    _spinner=[[BRWaitSpinnerControl alloc]init];
    _cursorControl=[[BRCursorControl alloc] init];
    _scroller=[[BRScrollControl alloc] init];
    _gridControl=[[BRGridControl alloc] init];
    [self setGrid];
	//_sourceImage = [[BRImageControl alloc] init];
	
	
	
	// lay out our UI
	//CGRect masterFrame = [[self parent] frame];
	//CGRect frame = masterFrame;


	
	// add the controls
	
	[self addControl: _gridControl];
    [self layoutSubcontrols];
	//[self addControl: _header];
	//[self addControl: _sourceImage];
	//[self customStuff];
}
- (void) setGrid;
{
    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
    NSArray *assets=[SMImageReturns mediaAssetsForPath:[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY]];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
    int i =0;
    for (i=0;i<[assets count];i++)
    {
        [store addObject:[assets objectAtIndex:i]];
    }
    id dSPfCClass = NSClassFromString(@"BRPhotoDataStoreProvider");
    id pBCFClass = NSClassFromString(@"BRPhotoControlFactory");
    id controlFactory = [pBCFClass standardFactory];
    id provider    = [dSPfCClass providerWithDataStore:store controlFactory:controlFactory];//[[ATVSettingsFacade sharedInstance] providerForScreenSaver];//[collection provider];
    //id controller  = [BRPhotoBrowserController controllerForProvider:provider];
    [_gridControl setProvider:provider];
    [_gridControl setColumnCount:3];
    id a = [BRBoxFlowLayoutManager managerWithDirection:1];
    [a setSpacingScale:0.1f];
    [self setControls:[NSArray arrayWithObjects:_spinner,_cursorControl,_scroller,nil]];
    CGRect masterFrame = [[self parent] frame];
	
	
    CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.1f;
    frame.origin.y = (masterFrame.size.height * 0.1f);// - txtSize.height;
	
    frame.size.width = masterFrame.size.width*0.8f;
	frame.size.height = masterFrame.size.height*0.8f;
	[_gridControl setAcceptsFocus:YES];
    [_gridControl setWrapsNavigation:YES];
    [_gridControl setProviderRequester:[NSNotificationCenter defaultCenter]];
    [_gridControl addControl:[_scroller plane]];
	[_gridControl setFrame: frame];
    
}
-(void)controlWasActivated
{
	[self drawSelf];
    [super controlWasActivated];
	
}
@end
