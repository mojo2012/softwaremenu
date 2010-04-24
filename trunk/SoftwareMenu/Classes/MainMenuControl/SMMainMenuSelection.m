//
//  SMMainMenuSelection.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/13/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//


#define MEXT_PATH   [ATV_PLUGIN_PATH stringByAppendingPathComponent:@"SoftwareMenu.frappliance/Contents/Mextensions/"]
#import <SoftwareMenuFramework/BackRowExtensions.h>
@implementation SMMainMenuSelection
-(id)previewControlForItem:(long)arg1
{
    if (arg1>=[_items count])
        return nil;
    SMFBaseAsset *asset=[[SMFBaseAsset alloc]init];
    [asset setTitle:[[[_items objectAtIndex:arg1] title] substringFromIndex:2]];
    if(arg1>0)
    {
        [asset setSummary:[[_options objectAtIndex:arg1]objectForKey:@"Summary"]];
        [asset setCustomKeys:[NSArray arrayWithObjects:
                              @"Developer",
                              nil]
                  forObjects:[NSArray arrayWithObjects:
                              [[_options objectAtIndex:arg1]objectForKey:@"Developer"],
                              nil]];
        [asset setCoverArt:[[SMThemeInfo sharedTheme]bundleImage]];
    }

    SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
    [preview setAsset:asset];
    return preview;
}

-(id)init
{
    self=[super init];
    [self setListTitle:BRLocalizedString(@"Select Extension",@"Select Extension")];
    _selectedPath=[[SMPreferences selectedExtension] retain];
    NSFileManager *man = [NSFileManager defaultManager];
    NSArray *files=[man directoryContentsAtPath:MEXT_PATH];
    int i,count=[files count];
    BRTextMenuItemLayer *item=[BRTextMenuItemLayer menuItem];
    [item setTitle:@"  None"];
    [_items addObject:item];
    [_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"None",@"Type",nil]];
    for(i=0;i<count;i++)
    {
        NSString *path = [MEXT_PATH stringByAppendingPathComponent:[files objectAtIndex:i]];
        if ([[path pathExtension] isEqualToString:@"mext"]) {
            NSBundle *bundle = [NSBundle bundleWithPath:path];
            id pc=[bundle principalClass];
            if ([pc conformsToProtocol:@protocol(SMMextProtocol)]) {
                item = [BRTextMenuItemLayer menuItem];
                [item setTitle:[@"  " stringByAppendingString:[[path lastPathComponent] stringByDeletingPathExtension]]];
                [_items addObject:item];
                [_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:[pc pluginSummary],@"Summary",[pc developer],@"Developer",nil]];
            }
        }
    }
    return self;
}
-(id)itemForRow:(long)row
{
    if (row>[_items count]) {
        return nil;
    }
    BRTextMenuItemLayer *item = [_items objectAtIndex:row];
    if (row==0) 
    {
        if (_selectedPath==nil || [_selectedPath isEqualToString:@"None"]) {
            [item setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [[BRThemeInfo sharedTheme] selectedSettingImage],@"BRMenuIconImageKey",nil]];
            
        }
        else {
            
            [item setLeftIconInfo:nil];
        }
        
    }
    if (row>=1 ) 
    {
        NSString *path = [[MEXT_PATH stringByAppendingPathComponent:[[[_items objectAtIndex:row] title]substringFromIndex:2]]stringByAppendingPathExtension:@"mext"];
        if ([path isEqualToString:_selectedPath]) 
        {
            [item setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [[BRThemeInfo sharedTheme] selectedSettingImage], @"BRMenuIconImageKey",nil]];

                                   
        }
        else{
            
            [item setLeftIconInfo:nil];

        }
        
    }
    return item;
}
-(void)itemSelected:(long)arg1
{
    if (arg1>0) {
        [SMPreferences setSelectedExtension:[[MEXT_PATH stringByAppendingPathComponent:[[[_items objectAtIndex:arg1] title] substringFromIndex:2]]stringByAppendingPathExtension:@"mext"]];
    }
    else 
        [SMPreferences setSelectedExtension:@"None"];
    if (_selectedPath!=nil) {
        [_selectedPath release];
    }

    _selectedPath=[[SMPreferences selectedExtension] retain];
    [[self list]reload];
    
}
@end
