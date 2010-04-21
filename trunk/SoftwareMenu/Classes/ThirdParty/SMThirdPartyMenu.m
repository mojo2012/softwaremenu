//
//  DownloadableMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
// in previewControlForItem: add support for downloadable icons
// add untrusted function...

#define DEBUG_MODE false
#import "SMThirdPartyMenu.h"

//static NSString  * trustedURL = @"http://web.me.com/tomcool420/Trusted.plist";

typedef enum _TPMenuTypes
{
    kSMCheck = 1,
    kSMRefresh = 2,
    kSMRestart = 3,
    kSMSm =4,
    kSMSettings=5,
} TPMenuTypes;


@implementation SMThirdPartyMenu
- (long)itemCount							{ return (long)([_items count] + [_itemsFraps count]);}
- (id)itemForRow:(long)row					
{
    if(row<[_items count])
       return [_items objectAtIndex:row];
    else if (row<[self itemCount]) {
        return [_itemsFraps objectAtIndex:(row - [_items count])];
    }
    return nil;
       
}
- (id)titleForRow:(long)row					
{ 
    if(row<[_items count])
        return [[_items objectAtIndex:row] title];
    else if (row<[self itemCount]) {
        return [[_itemsFraps objectAtIndex:(row - [_items count])]title];
    }
    return nil;
}
-(id)previewControlForItem:(long)row
{
    if (row>=[self itemCount])
        return nil;
    SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
    if (row<[_items count]) 
    {
        SMFBaseAsset *asset=[[SMFBaseAsset alloc]init];
        switch ([[_options objectAtIndex:row] intValue]) {
            case kSMCheck:
                [asset setTitle:BRLocalizedString(@"Check For Updates",@"Check For Updates")];
                [asset setSummary:BRLocalizedString(@"Check online for new updates",@"Check online for new updates")];
                [asset setCoverArt:[[SMThemeInfo sharedTheme] webImage]];
                break;
            case kSMRestart:
                NSLog(@"Restart");
                [asset setTitle:BRLocalizedString(@"Restart Finder",@"Restart Finder")];
                [asset setSummary:BRLocalizedString(@"Relaunches the Finder",@"Relaunches the Finder")];
                [asset setCoverArt:[[SMThemeInfo sharedTheme] standbyImage]];
                break;
            case kSMSettings:
                [asset setTitle:BRLocalizedString(@"Settings",@"Settings")];
                [asset setSummary:BRLocalizedString(@"Settings for Third Party Menu",@"Settings for Third Party Menu")];
                [asset setCoverArt:[[SMThemeInfo sharedTheme] softwareMenuImage]];
                break;
            default:
                break;
        }
        
        [preview setAsset:asset];
    }
    else if(row<[self itemCount])
    {
        int realrow=row-[_items count];
        SMPluginMediaAsset *asset = [[SMPluginMediaAsset alloc] initWithApplianceDictionary:[_optionsFraps objectAtIndex:realrow]];
        [asset setCoverArt:BRImageD([SMGeneralMethods getImagePath:[[_optionsFraps objectAtIndex:realrow] name]])];
        [preview setAsset:asset];
        
    }
    return preview;
}

-(id)init{
	self = [super init];
    [[NSFileManager defaultManager] constructPath:[[SMPreferences trustedPlistPath] stringByDeletingLastPathComponent]];
	[self setListIcon:[[SMThemeInfo sharedTheme] webImage] horizontalOffset:0.5f kerningFactor:0.2f];
    [self setListTitle:BRLocalizedString(@"Third Party",@"Third Party")];
	_man = [NSFileManager defaultManager];
    
    BRTextMenuItemLayer * a =[BRTextMenuItemLayer networkMenuItem];
    [a setTitle:BRLocalizedString(@"Check For Updates",@"Check For Updates")];
    [_items addObject:a];
    [_options addObject:[NSNumber numberWithInt:kSMCheck]];
    
    a=[BRTextMenuItemLayer menuItem];
    [a setTitle:BRLocalizedString(@"Restart Finder",@"Restart Finder")];
    [_items addObject:a];
    [_options addObject:[NSNumber numberWithInt:kSMRestart]];
    
    a=[BRTextMenuItemLayer menuItem];
    [a setTitle:BRLocalizedString(@"Settings",@"Settings")];
    [_items addObject:a];
    [_options addObject:[NSNumber numberWithInt:kSMSettings]];
    
    
    
//    a=[BRTextMenuItemLayer menuItem];
//    [a setTitle:BRLocalizedString(@"Software Menu",@"Software Menu")];
//    [_items addObject:a];
//    [_options addObject:[NSNumber numberWithInt:kSMSm]];
    _itemsFraps=[[NSMutableArray alloc]init];
    [self updateFrapItems];
	return self;
}
- (void)updateFrapItems
{
    [[self list] removeDividers];
    _itemsFraps=[[NSMutableArray alloc]init];
    _optionsFraps=[[NSMutableArray alloc]init];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:[SMPreferences trustedPlistPath]];
    BRTextMenuItemLayer *item;
    if([[dict allKeys]containsObject:@"SoftwareMenu"])
    {
        [[self list] addDividerAtIndex:[_items count] withLabel:@"SoftwareMenu"];
        item=[BRTextMenuItemLayer folderMenuItem];
        [item setTitle:@"SoftwareMenu"];
        [_itemsFraps addObject:item];
        [_optionsFraps addObject:[SMApplianceDictionary appDictionaryWithDictionary:[dict objectForKey:@"SoftwareMenu"]]];
    }
    [dict removeObjectForKey:@"SoftwareMenu"];
    [dict removeObjectForKey:@"SoftwareMenu_Update1"];
    
    [[self list] addDividerAtIndex:([_items count]+1) withLabel:BRLocalizedString(@"Plugins",@"Plugins")];
    int i,count=[[dict allKeys] count];
		
	id currentItems = nil;
	NSString *currentKeys = nil;
	NSArray *sortedArrays;
	NSSortDescriptor *nameDescriptors = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *ArraySortDescriptor = [NSArray arrayWithObjects:nameDescriptors, nil];
	NSMutableArray *unsortedArray = [NSMutableArray array];
	for (i = 0; i < count; i++)
	{
        
		currentKeys = [[dict allKeys] objectAtIndex:i];
		currentItems = [dict valueForKey:currentKeys];
		[unsortedArray addObject:currentItems];
		
		
	}
    sortedArrays = [unsortedArray sortedArrayUsingDescriptors:ArraySortDescriptor];
	NSEnumerator *enumerator = [sortedArrays objectEnumerator];
	id obj;
    
	while((obj = [enumerator nextObject]) != nil) 
	{
        SMApplianceDictionary *objm = [[SMApplianceDictionary alloc] initWithDictionary:obj];
        [objm setIsTrusted:YES];
        if ([objm installOnCurrentOS]&&[objm isValid]) 
        {
            
            item = [BRTextMenuItemLayer folderMenuItem];
            if([objm isInstalled])
            {
                if([objm installedIsUpToDate])
                    [item setRightJustifiedText:BRLocalizedString(@"Up to Date",@"Up to Date")];
                else
                    [item setRightJustifiedText:BRLocalizedString(@"New Version available",@"New Version available")];
            }
            else
                [item setRightJustifiedText:BRLocalizedString(@"Not Installed",@"Not Installed")];
            
            [_optionsFraps addObject:objm];
            [item setTitle:[objm displayName]];
            [_itemsFraps addObject: item];
        }
    }
}
- (void)dealloc
{
	[_man release];
	[tempFrapsInfo release];
	[tempFrapsInfo2 release];
	[istrusted release];
    [_itemsFraps release];
    [_optionsFraps release];
	[super dealloc];  
}


-(void)itemSelected:(long)fp8
{
    if(fp8<[_items count])
    {
        switch([[_options objectAtIndex:fp8] intValue])
        {
            case kSMCheck:
            {
//                NSString *thelog = [[NSString alloc] initWithString:@""];
//                [thelog writeToFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath] atomically:YES];
//                [self writeToLog:@"Initializing Update"];
//                [self startUpdate];
//                NSLog(@"check");
                [[SMThirdPartyPlugins singleton]loadPlugins];
                break;
            }
            case kSMRestart:
            {
                [[SMHelper helperManager] restartFinder];
                break;
            }
            default:
                break;
        }
    }
    else if(fp8<([_items count]+[_itemsFraps count]))
    {
        int realrow=fp8-[_items count];
        id controller = [[SMApplianceInstallerController alloc] initWithDictionary:[_optionsFraps objectAtIndex:realrow]];
        [[self stack] pushController:controller];
        [controller release];
    }

}





- (void)wasExhumed
{
    [self updateFrapItems];
    [[self list]reload];
}

//	Data source methods:

@end






