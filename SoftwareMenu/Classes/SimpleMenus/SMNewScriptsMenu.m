//
//  SMNewScriptsMenu.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/18/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMNewScriptsMenu.h"

@implementation SMNewScriptsMenu
-(id)init
{
    self=[super init];
    BRTextMenuItemLayer *item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"About",@"About")];
    [_items addObject:item];
    [_options addObject:[NSNumber numberWithInt:0]];
    
    item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"Reload",@"Reload")];
    [_items addObject:item];
    [_options addObject:[NSNumber numberWithInt:1]];
    [[self list] addDividerAtIndex:[_items count] withLabel:BRLocalizedString(@"Scripts",@"Scripts")];
    [self everyLoad];
    return self;
}
-(NSString *)scriptsPath
{
    return SCRIPTS_FOLDER;
}
-(BOOL)pythonIsInstalled
{
    return NO;
}
-(void)everyLoad
{
    [_scripts release];
    _scripts=[[NSMutableArray alloc] init];
    [_scriptOptions release];
    _scriptOptions=[[NSMutableArray alloc] init];
    NSFileManager *man=[NSFileManager defaultManager];
    NSArray *contents = [man directoryContentsAtPath:[self scriptsPath]];
    int i,count=[contents count];
    BOOL python=[self pythonIsInstalled];
    for (i=0; i<count; i++) {
        NSString *filename=[contents objectAtIndex:i];
        if ([[filename pathExtension] isEqualToString:@"sh"]||(python && [[filename pathExtension] isEqualToString:@"py"])) {
            BRTextMenuItemLayer *item=[BRTextMenuItemLayer menuItem];
            [item setRightJustifiedText:BRLocalizedString(@"Default",@"Default")];
            [item setTitle:filename];
            [_scripts addObject:item];
            [_scriptOptions addObject:[NSNumber numberWithInt:0]];
        }
    }
}
-(long)itemCount
{
    return (long)([_scripts count]+[_items count]);
}
-(id)itemForRow:(long)row
{
    if (row<[_items count]) {
        return [_items objectAtIndex:row];
    }
    else if(row<([_items count]+[_scripts count]))
    {
        row-=[_items count];
        return [_scripts objectAtIndex:row];
    }
    return nil;
}
@end
