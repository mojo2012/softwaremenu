//
//  SMUpdater.m
//  SoftwareMenu
//
//  Created by Thomas on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMUOptions.h"
#import "SMDownloaderSTD.h"
#import "SMUpdaterProcess.h"
#import "SMInfo.h"
#import "SMUpdaterOptionss.h"
#import "SMGeneralMethods.h"
#import "SMMedia.h"



@implementation SMUOptions


- (id) previewControlForItem: (long) item
{
    // If subclassing BRMediaMenuController, this function is called when the selection cursor
    // passes over an item.
	if(item >= [_items count])
		return nil;
	else
	{
		//NSLog(@"in preview loop");
		//NSArray *names = [[NSArray alloc] initWithObjects:       BRLocalizedString(@"  Populate File Data", @"Populate File Data menu item"),BRLocalizedString(@"  Fetch TV Show Data", @"Fetch TV Show Data menu item"),nil];
		/* Get setting name & kill the gem cushion  */
		NSString *settingName = @"hello";
		//NSArray *settingDescriptions=[[NSArray alloc] initWithObjects: BRLocalizedString(@"Tells Sapphire that for every TV episode, gather more information about this episode from the internet.", @"Fetch TV Show Data description"),nil];
		NSString *settingDescription=@"Bye";
		/* Construct a gerneric metadata asset for display */
		/*NSMutableDictionary *settingMeta=[[NSMutableDictionary alloc] init];
		 [settingMeta setObject:settingName forKey:META_TITLE_KEY];
		 [settingMeta setObject:[NSNumber numberWithInt:-2] forKey:FILE_CLASS_KEY];
		 [settingMeta setObject:settingDescription forKey:META_DESCRIPTION_KEY];
		 SMMediaPreview *preview = [[SMMediaPreview alloc] init];
		 [preview setUtilityData:settingMeta];
		 [preview setShowsMetadataImmediately:YES];*/
		//[preview _populateMetadata];
		/*SMMedia *media = [[SMMedia alloc] init];
		 [media setImagePath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/SoftwareMenu.png"];
		 [media setObject:@"hello" forKey:@"title"];
		 BRMetadataControl *meta=[[BRMetadataControl alloc] init];
		 [meta setTitle:BRLocalizedString(@"Hello",@"Hello")];
		 [meta setSummary:BRLocalizedString(@"hello",@"Hello")];
		 [meta setStarRating:nil];
		 [meta setRating:nil];
		 [meta setCopyright:nil];*/
		SMMedia	*meta = [[SMMedia alloc] init];
		/*[meta setObject:@"hello" forKey:@"title"];
		 [meta setObject:@"hello" forKey:@"description"];
		 [meta setObject:@"Bye" forKey:@"mediaSummary"];
		 [meta setObject:@"SoftwareMenu.png" forKey:@"id"];
		 [meta setObject:[BRMediaType movie] forKey:@"mediaType"];*/
		[meta setImagePath:@"hello"];
		//NSURL *hello = [[NSURL alloc] initFileURLWithPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/SoftwareMenu.png"];
		//[meta setObject:[hello absoluteString] forKey:@"previewURL"];
		//
		//[meta setObject:[hello absoluteString] forKey:@"mediaURL"];
		
		
		BRMetadataPreviewControl *previewtoo =[[BRMetadataPreviewControl alloc] init];
		[previewtoo setAsset:meta];
		
		[previewtoo setShowsMetadataImmediately:YES];
		[previewtoo setDeletterboxAssetArtwork:NO];
		[previewtoo _updateMetadataLayer];
		
		return [previewtoo autorelease];
		
		//BRMediaAssetItemProvider *assetProvider =[[BRMediaAssetItemProvider alloc] init];
		//[assetProvider setMediaAssets:[NSArray arrayWithObjects:meta,nil]];
		//[media setObject:@"hello" forKey:META_DESCRIPTION_KEY];
		//[previewtoo setMetadataProvider:hellotoo];
		//[previewtoo setMetadataProvider:assetProvider];*/
		/*And go*/
		//[preview doPopulation];
		
	}
    return ( nil );
}

-(id)initCustom
{
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"UOptions",@"UOptions")];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	
	NSArray *optionKeys  = [NSArray arrayWithObjects:@"preserve",@"updatenow",@"originalupdate",@"install_perian",@"retain_installed",@"retain_builtin",nil];
	NSArray *optionNames = [NSArray arrayWithObjects:BRLocalizedString(@"Preserve Files",@"Preserve Files"),
							BRLocalizedString(@"Update Immediately",@"Update Immediately"),
							BRLocalizedString(@"Keep Unpatched",@"Keep Unpatched"),
							BRLocalizedString(@"Install Perian",@"Install Perian"),
							BRLocalizedString(@"Retain Plugins",@"Retain Plugins"),
							BRLocalizedString(@"Retain Builtin Backup",@"Retain Builtin Backup"), nil];
	int ii, counterr;
	ii=[optionKeys count];
	for(counterr=0;counterr<ii;counterr++)
	{
		id item2 = [[BRTextMenuItemLayer alloc] init];
		NSString *optionKey=[optionKeys objectAtIndex:counterr];
		[_options addObject:[NSArray arrayWithObjects:@"options",optionKey,nil]];
		[item2 setTitle:[optionNames objectAtIndex:counterr]];
		if([SMGeneralMethods boolForKey:optionKey])
		{
			[item2 setRightJustifiedText:BRLocalizedString(@"YES",@"YES")];
		}
		else
		{
			[item2 setRightJustifiedText:BRLocalizedString(@"NO",@"NO")];
			[SMGeneralMethods setBool:NO forKey:optionKey];
		}
		[_items addObject:item2];
	}
	int counterone=[_items count];
	NSLog(@"options3");
	if([SMGeneralMethods boolForKey:@"retain_installed"])
	{
		//NSMutableDictionary *optionsDict=[[SMGeneralMethods dictForKey:@"frapCopy"] mutableCopy];
		//NSArray *theKeys=[optionsDict allKeys];
		NSArray * builtinfraps = [[NSArray alloc] initWithObjects:@"Movies.frappliance",@"Music.frappliance",@"Photos.frappliance",@"Podcasts.frappliance",@"YT.frappliance",@"TV.frappliance",@"Settings.frappliance",@"SoftwareMenu.frappliance",nil];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *thepath =@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/";
		long i, count = [[fileManager directoryContentsAtPath:thepath] count];
		for ( i = 0; i < count; i++ )
		{
			NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
			NSLog(@"idStr: %@",idStr);
			if(![builtinfraps containsObject:idStr])
			{
				id item3 = [[BRTextMenuItemLayer alloc] init];
				[item3 setTitle:[idStr stringByDeletingPathExtension]];
				if([SMGeneralMethods boolForKey:[@"copy_" stringByAppendingString:[idStr stringByDeletingPathExtension]]])
				{
					[item3 setRightJustifiedText:@"YES"];
				}
				else
				{
					[SMGeneralMethods setBool:NO forKey:[@"copy_" stringByAppendingString:[idStr stringByDeletingPathExtension]]];
					[item3 setRightJustifiedText:@"NO"];
				}
				[_options addObject:[NSArray arrayWithObjects:@"frapCopy",[@"copy_" stringByAppendingString:[idStr stringByDeletingPathExtension]],nil]];
				[_items addObject:item3];
				NSLog(@"1");
				
			}
			
		}
		NSLog(@"2");
		//[SMGeneralMethods setDict:(NSDictionary *)optionsDict forKey:@"frapCopy"];
		NSLog(@"3");
	}
	
	id list = [self list];
	[list setDatasource: self];
	if([SMGeneralMethods boolForKey:@"retain_installed"])
	{
		[[self list] addDividerAtIndex:counterone withLabel:BRLocalizedString(@"Fraps",@"Fraps")];
		
	}		
	return self;
	
}

-(void)itemSelected:(long)fp8
{
	if([[[_options objectAtIndex:fp8] objectAtIndex:0] isEqualToString:@"options"])
	{
		[SMGeneralMethods switchBoolforKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];
		[self initCustom];
	}
	if([[[_options objectAtIndex:fp8] objectAtIndex:0] isEqualToString:@"frapCopy"])
	{
		//NSMutableDictionary *optionsDict= [[SMGeneralMethods dictForKey:@"frapCopy"] mutableCopy];
		if([SMGeneralMethods boolForKey:[[_options objectAtIndex:fp8] objectAtIndex:1]])
		{
			[SMGeneralMethods setBool:NO forKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];
			//[optionsDict setValue:NO forKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];
		}
		else
		{
			//NSLog(@"set YES: %@",[[_options objectAtIndex:fp8] objectAtIndex:1]);
			[SMGeneralMethods setBool:YES	forKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];
			//[optionsDict setValue:(BOOL)YES forKey:(NSString *)[[_options objectAtIndex:fp8] objectAtIndex:1]];
		}
		//[SMGeneralMethods setDict:optionsDict forKey:@"frapCopy"];
		[self initCustom];
	}
}


-(id)init{
	//NSLog(@"init");
	
	return [super init];
}
- (void)dealloc
{
	[_items release];
	[_options release];

	[super dealloc];  
}
- (int)getSelection
{
	BRListControl *list = [self list];
	int row;
	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(selection)];
	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
	[selInv setSelector:@selector(selection)];
	[selInv invokeWithTarget:list];
	if([signature methodReturnLength] == 8)
	{
		double retDoub = 0;
		[selInv getReturnValue:&retDoub];
		row = retDoub;
	}
	else
		[selInv getReturnValue:&row];
	return row;
}

-(long)defaultIndex
{
	return 0;
}


-(void)willBePopped
{
	//NSLog(@"willBePopped");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBePopped];
}



- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }




@end
