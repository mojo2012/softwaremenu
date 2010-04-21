//
//  SoftwareScriptsMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SMFrappMover.h"

#define SETTINGSPATH						@"/Users/frontrow/Library/Application Support/SoftwareMenu/settings.plist"

@implementation SMFrappMover
- (id) previewControlForItem: (long) row
{
    SMFBaseAsset	*meta = [[SMFBaseAsset alloc] init];
    [meta setTitle:(NSString *)[[_items objectAtIndex:row] title]];
    [meta setCoverArt:kSMDefaultImage];
    if(row>2) {
        [meta setSummary:BRLocalizedString(@"Change Order of Plugin",@"Change Order of Plugin")];
        
        NSString *txt = [(BRTextMenuItemLayer *)[_items objectAtIndex:row] rightJustifiedText];
        if (txt!=nil && [txt length]>0) {
            float v=[txt floatValue];
            if (v>=0)         
                [meta setCustomKeys:[NSArray arrayWithObject:@"Status"] forObjects:[NSArray arrayWithObject:@"Visible"]];
            else
                [meta setCustomKeys:[NSArray arrayWithObject:@"Status"] forObjects:[NSArray arrayWithObject:@"Invisible"]];
         }

    }
    
    SMFMediaPreview *preview =[[SMFMediaPreview alloc] init];
    [preview setAsset:meta];
    return preview ;
}



- (NSArray *)frapEnumerator
{
	BOOL isDir;
	NSMutableArray *frappliances = [[NSMutableArray alloc] init];
	
	NSString *pluginPath = @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/";
	NSFileManager * manager = [NSFileManager defaultManager];
	NSArray *filelist = [manager directoryContentsAtPath:pluginPath];
	NSEnumerator *fileEnum = [filelist objectEnumerator]; 
	NSString *file;
    while (file = [fileEnum nextObject]) {
		//NSLog(@"%@",file);
		[manager changeCurrentDirectoryPath:pluginPath];
        if ([manager fileExistsAtPath:file isDirectory:&isDir] && isDir) {
            NSString *fullpath = [pluginPath stringByAppendingPathComponent:file];
            if ([[file pathExtension] isEqualToString:@"frappliance"]) [frappliances addObject:fullpath];
			//NSLog(@"frap found at %@",fullpath);
			
            
        }
	}
	return frappliances;
}

-(NSArray *)frapOrderDict:(NSArray *)frapList
{
	NSMutableArray *theorders=[[NSMutableArray alloc] init];
	NSEnumerator *frapEnum=[frapList objectEnumerator];
	NSString *frapPath;
	while (frapPath=[frapEnum nextObject])
	{
		NSString *infoPath=[frapPath stringByAppendingPathComponent:@"/Contents/Info.plist"];
		NSDictionary *infoplist=[[NSDictionary alloc] initWithContentsOfFile:infoPath];
		id preforders = [infoplist valueForKey:@"FRAppliancePreferedOrderValue"];
        if ([preforders respondsToSelector:@selector(floatValue)]) {
            preforders=[NSNumber numberWithFloat:[preforders floatValue]];
        }
		[theorders addObject:[[NSDictionary alloc] initWithObjectsAndKeys:preforders,@"order",frapPath,@"fullpath",[frapPath lastPathComponent],@"name",nil]];
	}
	//NSLog(@"the orders: %@",theorders);
	return theorders;
}
-(id)init
{
	self = [super init];
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Frap Order",@"Frap Order")];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
    [self initCustom];
	return self;
	
}

-(id)initCustom
{
	[_items removeAllObjects];
	[_items removeAllObjects];
	
	NSArray *theFrapList=[[NSArray alloc] init];
	theFrapList=[self frapEnumerator];
	//}
	NSArray *FrapOrderArray=[[NSArray alloc] initWithArray:[self frapOrderDict:theFrapList]];
	//NSLog(@"1");
	NSArray *names = [NSArray arrayWithObjects:
						   BRLocalizedString(@"Help",@"Help"),
						   BRLocalizedString(@"Backup",@"Backup"),
						   BRLocalizedString(@"Restore",@"Restore"),
						   nil];
	NSArray *types = [NSArray arrayWithObjects:
						   [NSNumber numberWithInt:0],
						   [NSNumber numberWithInt:1],
						   [NSNumber numberWithInt:2],
						   nil];
	
	NSSortDescriptor *lastDescriptor =[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	NSSortDescriptor *firstDescriptor =[[NSSortDescriptor alloc] initWithKey:@"name"
								 ascending:YES
								  selector:@selector(localizedCaseInsensitiveCompare:)];
	NSArray *thedescriptors = [NSArray arrayWithObjects:lastDescriptor,firstDescriptor, nil];
	NSMutableArray *thesortedArray;
	thesortedArray = [[FrapOrderArray sortedArrayUsingDescriptors:thedescriptors] mutableCopy];
	int counter , i = [names count];
	for(counter = 0;counter<i;counter++)
	{
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 [types objectAtIndex:counter],LAYER_TYPE,
							 [names objectAtIndex:counter],LAYER_NAME,
							 nil]];
		id item1 = [BRTextMenuItemLayer menuItem];
		[item1 setTitle:[names objectAtIndex:counter]];
		[_items addObject:item1];
	}
	
	int marker1 =[_items count];
    [lastDescriptor release];
    [firstDescriptor release];
	
	NSEnumerator *enumerator = [thesortedArray objectEnumerator];
	id anObject;
	
	
	

	while (anObject = [enumerator nextObject]) 
	{
		id item = [[BRTextMenuItemLayer alloc] init];
		[item setTitle:[[anObject valueForKey:@"name"] stringByDeletingPathExtension]];
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 anObject,LAYER_NAME,
							 [NSNumber numberWithInt:3],LAYER_TYPE,
							 nil]];
		[item setRightJustifiedText:[[anObject valueForKey:@"order"] stringValue]];
		[_items addObject:item];
	}


	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:marker1 withLabel:@"Plugins"];
    //NSLog(@"last: %@",[[NSBundle bundleWithPath:[ATV_PLUGIN_PATH stringByAppendingPathComponent:[@"Sapphire" stringByAppendingPathExtension:@"frappliance"]]] infoDictionary]);

	return self;
}

-(void)itemSelected:(long)row
{
	
	NSArray *option = [_options objectAtIndex:row];
	BOOL isDir;
	switch([[option valueForKey:LAYER_TYPE] intValue])
	{
		case 0:
			break;
		case 1:
			isDir = NO;
			NSMutableDictionary *settingsDict = [[NSMutableDictionary alloc] initWithDictionary:nil];
			
			if([[NSFileManager defaultManager] fileExistsAtPath:SETTINGSPATH])
			{
				NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:SETTINGSPATH];
				[settingsDict addEntriesFromDictionary:tempdict];
			}
			
			[settingsDict setValue:[option valueForKey:@"data"] forKey:@"OrderBak"];
			[settingsDict writeToFile:SETTINGSPATH atomically:YES];
			[self initCustom];
			break;
		case 2:
			isDir = YES;
			NSMutableDictionary *settingsDicts =[[NSMutableDictionary alloc] initWithContentsOfFile:SETTINGSPATH];
			NSArray *backupArray=[[NSArray alloc] initWithArray:[settingsDicts valueForKey:@"OrderBak"]];
			NSEnumerator *enumerator = [backupArray objectEnumerator];
			id anObject;
			while (anObject = [enumerator nextObject]) 
			{
                [[SMHelper helperManager] changeOrderForPlugin:[anObject valueForKey:@"fullpath"] newOrder:[[anObject valueForKey:@"order"] intValue]];
            }
			[self initCustom];
			break;
		case 3:
        {
            if (_selected!=nil) {
                [_selected release];
                _selected=nil;
            }
            _selected = [self titleForRow:row];
            [_selected retain];
            id newController = [SMFPasscodeController passcodeWithTitle:[[option valueForKey:LAYER_NAME] valueForKey:@"name"] 
                                                        withDescription:BRLocalizedString(@"Please enter a new value for prefered Order", @"Please enter a new value for prefered Order") 
                                                              withBoxes:4 
                                                           withDelegate:self];
            [newController setDelegate:self];
			[[self stack] pushController:newController];
        }

	}
}
- (BOOL)brEventAction:(BREvent *)event
{
	int remoteAction =[event remoteAction];
	
	if ([(BRControllerStack *)[self stack] peekController] != self)
		return [super brEventAction:event];

	if([event value] == 0)
		return [super brEventAction:event];
	if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] && remoteAction>1)
		remoteAction ++;
	long row = [self getSelection];
	//NSMutableArray *favorites = nil;
	switch (remoteAction)
	{
		case kBREventRemoteActionLeft:  // tap left
        case kBREventRemoteActionRight:
        {
            NSLog(@"type Left/Right");
            if(row>=3)
            {
                NSString *txt = [(BRTextMenuItemLayer *)[_items objectAtIndex:row] rightJustifiedText];
                if (txt!=nil && [txt length]>0) {
                    float v=[txt floatValue];
                    if(v>=0)
                    {
                        [[SMHelper helperManager]makeInvisible:[self titleForRow:row]];
                    }
                    else {
                        [[SMHelper helperManager]makeVisible:[self titleForRow:row]];
                    }

                }
                [self initCustom];
            }
            break;
        }
	}
	return [super brEventAction:event];
}

- (void) textDidEndEditing: (id) sender
{
    int theVal = [[sender stringValue] intValue];
    [[SMHelper helperManager] changeOrderForPlugin:_selected newOrder:theVal];
	[[self stack] popController];
	[self initCustom];
	
}
- (void) textDidChange: (id) sender
{
	//Do Nothing Now
}
-(void)wasExhumed
{
	[self initCustom];
}
- (void)wasExhumedByPoppingController:(id)fp8
{
	[self initCustom];      
}
-(void)dealloc
{
    if (_selected!=nil) {
        [_selected release];
        _selected=nil;
    }
    [super dealloc];
}


//	Data source methods:




@end
