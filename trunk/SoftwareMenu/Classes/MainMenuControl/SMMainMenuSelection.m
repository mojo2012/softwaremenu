//
//  SMMainMenuSelection.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/13/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//


#define MEXT_PATH   [ATV_PLUGIN_PATH stringByAppendingPathComponent:@"SoftwareMenu.frappliance/Contents/Mextensions/"]

@implementation SMMainMenuSelection
-(id)previewControlForItem:(long)arg1
{
    if (arg1>=[_items count])
        return nil;
    SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
    SMFBaseAsset *asset=[[SMFBaseAsset alloc]init];
    [asset setTitle:[[_items objectAtIndex:arg1] title]];
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
        
    //[asset setSummary:BRLocalizedString(@"Check online for new updates",@"Check online for new updates")];
    //[asset setCoverArt:[SMPhotoPreview firstPhotoForPath:[_paths objectAtIndex:item]]];
    //[asset setCoverArt:[[SMThemeInfo sharedTheme] webImage]];
    [preview setAsset:asset];
    return preview;
}
-(id)itemForRow:(long)row
{
    if (row>[_items count]) {
        return nil;
    }
    BRTextMenuItemLayer *item = [_items objectAtIndex:row];
    return item;
}
-(id)init
{
    self=[super init];
    [self setListTitle:BRLocalizedString(@"Select Extension",@"Select Extension")];
    NSFileManager *man = [NSFileManager defaultManager];
    NSArray *files=[man directoryContentsAtPath:MEXT_PATH];
    int i,count=[files count];
    BRTextMenuItemLayer *item=[BRTextMenuItemLayer menuItem];
    [item setTitle:@"None"];
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
                [item setTitle:[[path lastPathComponent] stringByDeletingPathExtension]];
                [_items addObject:item];
                [_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:[pc pluginSummary],@"Summary",[pc developer],@"Developer",nil]];
            }
        }
    }
    return self;
}
-(void)itemSelected:(long)arg1
{
    if (arg1>0) {
        [SMPreferences setSelectedExtension:[[MEXT_PATH stringByAppendingPathComponent:[[_items objectAtIndex:arg1] title]]stringByAppendingPathExtension:@"mext"]];
    }
    else 
        [SMPreferences setSelectedExtension:@"None"];
    [[self list]reload];
    
}
@end
