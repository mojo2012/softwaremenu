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
	if(item >= [_items count])
		return nil;
	else
	{

		SMMedia	*meta = [[SMMedia alloc] init];
		[meta setDefaultImage];
		[meta setTitle:[[_items objectAtIndex:item] title]];
		//[meta setTitle:[_items objectAtIndex:item]];
		if(item>4)
		{
			[meta setDescription:@"copy this frap over"];
		}
		else
		{
			[meta setDescription:[_optionDescriptions objectAtIndex:item]];

		}
		BRMetadataPreviewControl *previewtoo =[[BRMetadataPreviewControl alloc] init];
		[previewtoo setAsset:meta];
		
		[previewtoo setShowsMetadataImmediately:YES];
		[previewtoo setDeletterboxAssetArtwork:NO];
		[previewtoo _updateMetadataLayer];
		
		return [previewtoo autorelease];

		
	}
    return ( nil );
}
-(id)init
{
	self=[super init];
	NSLog(@"after super init");
	//Add Labels
	_options = [[NSMutableArray alloc] initWithObjects:nil];

	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"UOptions",@"UOptions")];
	
	//Set up Options, their descriptions and keys
	_theDefaults = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"preserve",
					[NSNumber numberWithBool:NO],@"updatenow",
					[NSNumber numberWithBool:NO],@"originalupdate",
					[NSNumber numberWithBool:YES],@"install_perian",
					[NSNumber numberWithBool:YES],@"install_bin_tools",
					[NSNumber numberWithBool:NO],@"retain_installed",
					[NSNumber numberWithBool:NO],@"retain_builtin",
					nil];
	_optionDict=[self getOptions];
	if([_optionDict count]==0){[SMGeneralMethods setDict:_theDefaults forKey:@"Updater_Options"];
								_optionDict=[self getOptions];}
	
	_optionDescriptions = [[NSMutableArray alloc] initWithObjects:BRLocalizedString(@"Saves downloaded file so you don't have to redownload them later.",@"Saves downloaded file so you don't have to redownload them later."),
						   BRLocalizedString(@"Update Immediatly after download and processing is done.\n Not really recommended.",@"Update Immediatly after download and processing is done.\n Not really recommended."),
						   BRLocalizedString(@"Download the OS and Update without processing. A standard apple Update except you can upgrade and downgrade",@"Download the OS and Update without processing. A standard apple Update except you can upgrade and downgrade"),
						   BRLocalizedString(@"Install Perian while Processing",@"Install Perian while Processing"),
						   BRLocalizedString(@"Install some basic binary tools compiled by nito ... not yet active",@"Install bin tools"),
						   BRLocalizedString(@"Copy the installed fraps over to the new OS, once YES is selected, you need to choose the fraps below\nWARNING: if a frappliance is not compatible, may cause problems",@"Copy the installed fraps over to the new OS\nWARNING: if a frappliance is not compatible, may cause problems"),
						   BRLocalizedString(@"Retain settings for Built in fraps... Not yet active",@"Retain settings for Built in fraps"),
						   nil];
	_optionNames=[NSArray arrayWithObjects:BRLocalizedString(@"Preserve Files",@"Preserve Files"),
				  BRLocalizedString(@"Update Immediately",@"Update Immediately"),
				  BRLocalizedString(@"Keep Unpatched",@"Keep Unpatched"),
				  BRLocalizedString(@"Install Perian",@"Install Perian"),
				  BRLocalizedString(@"Install Bin Tools",@"Install Bin Tools"),
				  BRLocalizedString(@"Retain Plugins",@"Retain Plugins"),
				  BRLocalizedString(@"Retain Builtin Backup",@"Retain Builtin Backup"), 
				  nil];
	_optionKeys=[NSArray arrayWithObjects:@"preserve",
				 @"updatenow",
				 @"originalupdate",
				 @"install_perian",
				 @"install_bin_tools",
				 @"retain_installed",
				 @"retain_builtin",
				 nil];


	NSEnumerator *keysEnum = [_optionKeys objectEnumerator];
	id obje;
	while((obje = [keysEnum nextObject]) != nil) 
	{
		[_options addObject:[NSArray arrayWithObjects:@"options",obje,nil]];
	}
	_nonBuiltinFraps=[[NSMutableArray alloc] initWithObjects:nil];
	long i, count = [[[NSFileManager defaultManager] directoryContentsAtPath:FRAP_PATH] count];
	for ( i = 0; i < count; i++ )
	{
		NSString *frapName = [[[NSFileManager defaultManager] directoryContentsAtPath:FRAP_PATH] objectAtIndex:i];
		if(![[SMGeneralMethods builtinfrapsWithSettings:YES] containsObject:frapName])
		{
			[_nonBuiltinFraps addObject:frapName];
			[_options addObject:[NSArray arrayWithObjects:@"frapCopy",[@"copy_" stringByAppendingString:[frapName stringByDeletingPathExtension]],nil]];
		}
	}
	_items = [[NSMutableArray alloc] initWithObjects:nil];

	return self;
	

}
-(id)initCust
{	
	int ii, counter;
	ii=[_items count];
	for(counter=1;counter<ii;counter++)
	{
		[_items removeLastObject];
	}
	
	
	
	NSMutableDictionary *tempOptions=[self getOptions];
	ii=[_optionKeys count];

	for(counter=0;counter<ii;counter++)
	{
		id item = [[BRTextMenuItemLayer alloc] init];
		NSString *optionKey=[_optionKeys objectAtIndex:counter];
		[item setTitle:[_optionNames objectAtIndex:counter]];
		
		if([tempOptions valueForKey:optionKey]==nil)			{[tempOptions setValue:[_theDefaults valueForKey:optionKey] forKey:optionKey];}
			
		if([[tempOptions valueForKey:optionKey] boolValue])		{[item setRightJustifiedText:BRLocalizedString(@"YES",@"YES")];}
		else													{[item setRightJustifiedText:BRLocalizedString(@"NO",@"NO")];}
		[_items addObject:item];
	}
	int counterone=[_items count];

		NSArray * builtinfraps = [SMGeneralMethods builtinfrapsWithSettings:YES];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *thepath =@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/";
		long i, count = [[fileManager directoryContentsAtPath:thepath] count];
		for ( i = 0; i < count; i++ )
		{
			NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
			if(![builtinfraps containsObject:idStr])
			{
				id item3 = [[BRTextMenuItemLayer alloc] init];
				[item3 setTitle:[idStr stringByDeletingPathExtension]];
				if([SMGeneralMethods boolForKey:[@"copy_" stringByAppendingString:[idStr stringByDeletingPathExtension]]])
				{
					[item3 setRightJustifiedText:BRLocalizedString(@"YES",@"YES")];
					
				}
				else
				{
					[SMGeneralMethods setBool:NO forKey:[@"copy_" stringByAppendingString:[idStr stringByDeletingPathExtension]]];
					[item3 setRightJustifiedText:BRLocalizedString(@"NO",@"NO")];
				}
				if(![SMGeneralMethods boolForKey:@"retain_installed"])
				{
					[item3 setDimmed:YES];
				}
				//[_options addObject:[NSArray arrayWithObjects:@"frapCopy",[@"copy_" stringByAppendingString:[idStr stringByDeletingPathExtension]],nil]];
				[_items addObject:item3];
				
			}
			
		
	}
	id list = [self list];
	[list setDatasource: self];

		[[self list] addDividerAtIndex:counterone withLabel:BRLocalizedString(@"Copy Installed Plugins",@"Copy Installed Plugins")];
		
	return self;
}
/*-(id)itemForRow:(long)row
{
	NSLog(@"row: %d",row);
	if(row>=[_optionNames count] && ![SMGeneralMethods boolForKey:@"retain_installed"]) return (nil);
	if(row<[_optionNames count])
	{
		NSLog(@"returning item2");
		id item2 = [[BRTextMenuItemLayer alloc] init];
		[item2 setTitle:[_optionNames objectAtIndex:row]];
		NSLog(@"title %@", [item2 title]);
		if([SMGeneralMethods boolForKey:[_optionKeys objectAtIndex:row]])
		{
			[item2 setRightJustifiedText:BRLocalizedString(@"YES",@"YES")];
			NSLog(@"YES");
		}
		else
		{
			NSLog(@"NO");
			[item2 setRightJustifiedText:BRLocalizedString(@"NO",@"NO")];
			[SMGeneralMethods setBool:NO forKey:[_optionKeys objectAtIndex:row]];
		}
		return item2;
	}
	if(row>=[_optionNames count] && row<([_optionNames count]+[_nonBuiltinFraps count]))
	{
		NSLog(@"returning item1");
		long itemIndex=row-[_optionNames count]+1;
		NSLog(@"itemIndex: %d",itemIndex);
		NSString * rowTitle = [[_nonBuiltinFraps objectAtIndex:1] stringByDeletingPathExtension];
		id item = [[BRTextMenuItemLayer alloc] init];
		[item setTitle:rowTitle];
		if([SMGeneralMethods boolForKey:[@"copy_" stringByAppendingString:rowTitle]])
		{
			[item setRightJustifiedText:@"YES"];
		}
		else
		{
			[SMGeneralMethods setBool:NO forKey:[@"copy_" stringByAppendingString:rowTitle]];
			[item setRightJustifiedText:@"NO"];
		}
		return item;
		//[_options addObject:[NSArray arrayWithObjects:@"frapCopy",[@"copy_" stringByAppendingString:rowTitle],nil]];
		//[_items addObject:item];
	}
}*/
-(void)itemSelected:(long)fp8
{
	NSLog(@"%@",[_options objectAtIndex:fp8]);
	if([[[_options objectAtIndex:fp8] objectAtIndex:0] isEqualToString:@"options"])
	{
		[SMGeneralMethods switchBoolforKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];
		if([[[_options objectAtIndex:fp8] objectAtIndex:1] isEqualToString:@"retain_installed"])
		{
			if([SMGeneralMethods boolForKey:@"retain_installed"])   {NSLog(@"retaining");}

			NSLog(@"bye");
			int i;
			int ii;
			int counter;
			i=[_items count];
			ii=6;//[_optionNames count];
			BOOL retain =NO;
			if([SMGeneralMethods boolForKey:@"retain_installed"])   {retain = YES;}
			for(counter=ii;counter<i;counter++)
			{
				if(retain)
				{
					[[_items objectAtIndex:counter] setDimmed:NO];
				}
				else
				{
					[[_items objectAtIndex:counter] setDimmed:YES];
				}
			}
		}
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
	}
	NSMutableDictionary * tempDict = [self getOptions];
	if([[[_items objectAtIndex:fp8] rightJustifiedText] isEqualToString:@"YES"])
	{
		[[_items objectAtIndex:fp8] setRightJustifiedText:@"NO"];
		
		[tempDict setValue:[NSNumber numberWithBool:NO] forKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];
		//[SMGeneralMethods switchBoolforKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];
	}
	else if([[[_items objectAtIndex:fp8] rightJustifiedText] isEqualToString:@"NO"])
	{
		[[_items objectAtIndex:fp8] setRightJustifiedText:@"YES"];
		[tempDict setValue:[NSNumber numberWithBool:YES] forKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];

		//[SMGeneralMethods switchBoolforKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];

	}
	[SMGeneralMethods setDict:tempDict forKey:@"Updater_Options"];
	[[self list] reload];
}


/*-(id)init{
	//NSLog(@"init");
	
	return [super init];
}*/
- (void)dealloc
{
	[_items release];
	[_options release];
	[_optionKeys release];
	[_optionDescriptions release];
	[_optionNames release];
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



-(NSMutableDictionary *)getOptions
{
	NSMutableDictionary *theoptions = [[SMGeneralMethods dictForKey:@"Updater_Options"] mutableCopy];
	return theoptions;
}

@end
