//
//  SMFSimpleDirectoryChooserController.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 3/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

typedef enum _kSMFDirChooser
{
    kSMFCurrDir=0,
    kSMFCreateDir=1,
    kSMFDirSelect=2,
    kSMFUpDir=3,
}kSMFDirChooser;

@implementation SMFSimpleDirectoryChooserController
-(id)initWithFolder:(NSString *)folder delegate:(id)delegate topFolder:(NSString *)topFolder
{
    self=[super init];
    _man=[NSFileManager defaultManager];
    BOOL isDir=NO;
    BOOL isDirToo=NO;
    if ([_man fileExistsAtPath:folder isDirectory:&isDir]&&isDir&&[_man fileExistsAtPath:topFolder isDirectory:&isDirToo]&&isDirToo) {
        _folder=[folder retain];
        _topFolder=[topFolder retain];
    }
    if (_delegate==nil) {
        _delegate=self;
    }
    _delegate=[delegate retain];
    BRTextMenuItemLayer *a=[BRTextMenuItemLayer menuItem];
    [a setTitle:BRLocalizedString(@"Select Current Folder",@"Select Current Folder")];
    [_items addObject:a];
    [_options addObject:[NSNumber numberWithInt:kSMFCurrDir]];
    [[self list] addDividerAtIndex:[_items count] withLabel:@""];
    
    
    a=[BRTextMenuItemLayer menuItem];
    [a setTitle:BRLocalizedString(@"Create Folder Here",@"Create Folder Here")];
    [_items addObject:a];
    [_options addObject:[NSNumber numberWithInt:kSMFCreateDir]];
    [[self list] addDividerAtIndex:[_items count] withLabel:@""];
    
    
    if (![_folder isEqualToString:NSHomeDirectory()] && ![_folder isEqualToString:@"/"] && ![_folder isEqualToString:_topFolder] ) {
        a=[BRTextMenuItemLayer menuItem];
        [a setTitle:BRLocalizedString(@"Up a Directory",@"Up a Directory")];
        [_items addObject:a];
        [_options addObject:[NSNumber numberWithInt:kSMFUpDir]];
        [[self list] addDividerAtIndex:[_items count] withLabel:@""];
    }
    
    NSArray *files = [_man directoryContentsAtPath:_folder];
    int i,count=[files count];
    for(i=0;i<count;i++)
    {
        isDir = NO;
        NSString *file = [files objectAtIndex:i];
        NSLog(file);
        if ([_man fileExistsAtPath:[_folder stringByAppendingPathComponent:file]isDirectory:&isDir]&&isDir) {
            a=[BRTextMenuItemLayer folderMenuItem];
            [a setTitle:file];
            [_items addObject:a];
            [_options addObject:[NSNumber numberWithInt:kSMFDirSelect]];
        }
    }
    return self;
    
}
-(void)itemSelected:(long)arg1
{
    switch ([[_options objectAtIndex:arg1]intValue]) {
        case kSMFCurrDir:
            [_delegate dirSelected:_folder];
            [[self stack]popController];
            break;
        case kSMFCreateDir:
        {
            id b = [[BRTextEntryController alloc]initWithTextEntryStyle:1];
            [b setPrimaryInfoText:@"Create Directory"];
            [b setDelegate:self];
            [[self stack] pushController:b];
            break;

        }
        case kSMFDirSelect:
        {
            NSString *newDir=[_folder stringByAppendingPathComponent:[[_items objectAtIndex:arg1]title]];
            id a =[[SMFSimpleDirectoryChooserController alloc] initWithFolder:newDir 
                                                                     delegate:_delegate 
                                                                    topFolder:_topFolder];
            [_topFolder release];
            [_delegate release];
            [[self stack]popController];
            [[self stack]pushController:a];
            [a release];
            break;
        }
        case kSMFUpDir:
        {
            NSString *newDir=[_folder stringByDeletingLastPathComponent];
            id a =[[SMFSimpleDirectoryChooserController alloc] initWithFolder:newDir
                                                                     delegate:_delegate 
                                                                    topFolder:_topFolder];
            [_topFolder release];
            [_delegate release];
            [[self stack]popController];
            [[self stack]pushController:a];
            [a release];
        }
        default:
            break;
    }
}
- (void) textDidChange: (id) sender
{
}

- (void) textDidEndEditing: (id) sender
{
    NSString *dir = [_folder stringByAppendingPathComponent:[sender stringValue]];
    [_man createDirectoryAtPath:[_folder stringByAppendingPathComponent:dir] attributes:nil];
    BOOL isDir=NO;
    if([_man fileExistsAtPath:[_folder stringByAppendingPathComponent:dir] isDirectory:&isDir]&&isDir)
    {
        id a =[[SMFSimpleDirectoryChooserController alloc] initWithFolder:dir 
                                                                 delegate:_delegate 
                                                                topFolder:_topFolder];
        [_topFolder release];
        [_delegate release];
        [[self stack]popController];
        [[self stack]pushController:a];
        [a release];
    }
}
-(void)dirSelected:(NSString *)dir
{
    NSLog(@"dir: %@",dir);
}
@end
