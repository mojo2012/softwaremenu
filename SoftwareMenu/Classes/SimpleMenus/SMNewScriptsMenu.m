//
//  SMNewScriptsMenu.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/18/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//
#define ROOT_KEY        @"root"
#define WAIT_KEY        @"wait"
#define CUST_KEY        @"custom"
#define MAIN_KEY        @"mainmenu"

#import "SMNewScriptsMenu.h"
@interface SMNewScriptsMenu (Private)
-(void)save;
@end

@implementation SMNewScriptsMenu
+(NSString *)scriptsPlistPath
{
    return [SUPPORT_FOLDER stringByAppendingPathComponent:@"Scripts.plist"];
}
+(NSString *)scriptsPath
{
    return SCRIPTS_FOLDER;
}
+(NSDictionary *)defaultScriptOptions
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:FALSE],ROOT_KEY,
            [NSNumber numberWithBool:FALSE],WAIT_KEY,
            [NSNumber numberWithBool:FALSE],CUST_KEY,
            [NSNumber numberWithBool:FALSE],MAIN_KEY,
            nil];
}
+(void)runScript:(NSString *)path displayResult:(BOOL)display asRoot:(BOOL)root
{
    if (!root) {
        [SMNewScriptsMenu runScript:path displayResult:display];
    }
    else {
        NSString *str = [[SMHelper helperManager]runScriptWithReturn:path];
        NSString *the_text = [[[[@"Script Path:   " stringByAppendingString:path] 
                                stringByAppendingString:@"\n\n\n"] 
                               stringByAppendingString:@"Result:\n"] 
                              stringByAppendingString:str];
        
        BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
        [textControls setTitle:[path lastPathComponent]];
        [textControls setText:the_text];
        BRController *theController =  [BRController controllerWithContentControl:textControls];
        [textControls release];
        [[[BRApplicationStackManager singleton] stack] pushController:theController];
    }
    
}
+(void)runScript:(NSString *)path displayResult:(BOOL)display
{
    if (!display) 
    {
        [NSTask launchedTaskWithLaunchPath:@"/bin/bash/" arguments:[NSArray arrayWithObject:path]];
    }
    else
    {
        NSTask *task = [[NSTask alloc] init];
        NSArray *args = [NSArray arrayWithObjects:path,nil];
        [task setArguments:args];
        [task setLaunchPath:@"/bin/bash"];
        NSPipe *outPipe = [[NSPipe alloc] init];
        [task setStandardOutput:outPipe];
        [task setStandardError:outPipe];
        NSFileHandle *file;
        file = [outPipe fileHandleForReading];
        [task launch];
        NSData *data;
        data = [ file readDataToEndOfFile];
        NSString *string;
        string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSString *the_text = [[[[@"Script Path:   " stringByAppendingString:path] stringByAppendingString:@"\n\n\n"] stringByAppendingString:@"Result:\n"] stringByAppendingString:string];
        BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
        [textControls setTitle:[path lastPathComponent]];
        [textControls setText:the_text];
        BRController *theController =  [BRController controllerWithContentControl:textControls];
        [[[BRApplicationStackManager singleton] stack] pushController:theController];
        
        //Releasing Alloc'ed objects
        [outPipe release];
        [task release];
        [string release];
        [textControls release];
        
    }
    
}

-(id)previewControlForItem:(long)row
{
    if (row>[self itemCount]) {
        return nil;
    }
    if (row<[_items count]) {
        return [super previewControlForItem:row];
    }
    row-=[_items count];
    
    SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
    SMFBaseAsset *asset=[[SMFBaseAsset alloc] init];
    [asset setTitle:[[_scripts objectAtIndex:row] title]];
    //[asset setSummary:[settingDescriptions objectAtIndex:arg1]];
    [asset setCoverArt:[[BRThemeInfo sharedTheme] scriptImage]];
    [preview setAsset:asset];
    [asset release];
    return [preview autorelease];
}
-(id)init
{
    self=[super init];
    [[SMGeneralMethods sharedInstance]checkFolders];

    BRTextMenuItemLayer *item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"About",@"About")];
    [_items addObject:item];
    [_options addObject:[NSNumber numberWithInt:0]];
    
    item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"Reload",@"Reload")];
    [_items addObject:item];
    [_options addObject:[NSNumber numberWithInt:1]];
    [[self list] addDividerAtIndex:[_items count] withLabel:BRLocalizedString(@"Default Settings",@"Default Settings")];

    
    item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Run As Root",@"Run As Root")];
    if ([SMPreferences defaultScriptRunAsRoot]) {
        [item setRightJustifiedText:@"YES"];
    }
    else {
        [item setRightJustifiedText:@"NO"];
    }
    [_items addObject:item];
    [_options addObject:[NSNumber numberWithInt:2]];
    
    item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Run And Wait ",@"Run And Wait")];
    [_items addObject:item];
    if ([SMPreferences defaultScriptWait]) {
        [item setRightJustifiedText:@"YES"];
    }
    else {
        [item setRightJustifiedText:@"NO"];
    }
    [_options addObject:[NSNumber numberWithInt:3]];
    [[self list] addDividerAtIndex:[_items count] withLabel:BRLocalizedString(@"Scripts",@"Scripts")];

    
    [self everyLoad];
    return self;
}

-(void)everyLoad
{
    if (_scripts!=nil) {
        [_scripts release];
    }
    _scripts=[[NSMutableArray alloc] init];
    
    
    if (_scriptOptions!=nil) {
        [_scriptOptions release];
        _scriptOptions=nil;
    }
    if ([[NSFileManager defaultManager]fileExistsAtPath:[SMNewScriptsMenu scriptsPlistPath]]) {
        _scriptOptions=[[NSMutableDictionary dictionaryWithContentsOfFile:[SMNewScriptsMenu scriptsPlistPath]] retain];
    }
    else {
        _scriptOptions=[[NSMutableDictionary dictionary]retain];
    }

    NSFileManager *man=[NSFileManager defaultManager];
    NSArray *contents = [man directoryContentsAtPath:[SMNewScriptsMenu scriptsPath]];
    int i,count=[contents count];
    BOOL python=[SMGeneralMethods pythonIsInstalled];
    for (i=0; i<count; i++) {
        NSString *filename=[contents objectAtIndex:i];
        if ([[filename pathExtension] isEqualToString:@"sh"]||(python && [[filename pathExtension] isEqualToString:@"py"])) {
            BRTextMenuItemLayer *item=[BRTextMenuItemLayer menuItem];
            [item setRightJustifiedText:BRLocalizedString(@"Default",@"Default")];
            [item setTitle:filename];
            [_scripts addObject:item];
            if ([_scriptOptions objectForKey:filename]==nil) {
                NSLog(@"Setting Default Options for script: %@",filename);
                [_scriptOptions setObject:[SMNewScriptsMenu defaultScriptOptions] forKey:filename];
            }
        }
    }
    [self save];
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
        BRTextMenuItemLayer *item = [_scripts objectAtIndex:row];
        NSDictionary *dict= [_scriptOptions objectForKey:[item title]];
        
        if ([dict objectForKey:CUST_KEY]!=nil && [[dict objectForKey:CUST_KEY] boolValue]) {
            [item setRightJustifiedText:BRLocalizedString(@"Custom",@"Custom")];
        }
        else
            [item setRightJustifiedText:BRLocalizedString(@"Default",@"Default")];
        return [_scripts objectAtIndex:row];
    }
    return nil;
}
-(void)itemSelected:(long)row
{
    if (row<[_items count]) 
    {
        switch (row) 
        {
            case 0:
                break;
            case 1:
                break;
            case 2:
                [SMPreferences setDefaultScriptRunAsRoot:![SMPreferences defaultScriptRunAsRoot]];
                break;
            case 3:
                [SMPreferences setDefaultScriptWait:![SMPreferences defaultScriptWait]];
            default:
                break;
        }
    }
    else {
        row-=[_items count];
        NSString *filename=[[_scripts objectAtIndex:row] title];
        NSString *path = [SCRIPTS_FOLDER stringByAppendingPathComponent:filename];
        NSDictionary *infoDict=[_scriptOptions objectForKey:filename];
        if ([[filename pathExtension] isEqualToString:@"sh"]) {
            if ([[infoDict objectForKey:CUST_KEY]boolValue])
                [SMNewScriptsMenu runScript:path
                              displayResult:[[infoDict objectForKey:WAIT_KEY]boolValue] 
                                     asRoot:[[infoDict objectForKey:ROOT_KEY]boolValue]];
            else
                [SMNewScriptsMenu runScript:path
                              displayResult:[SMPreferences defaultScriptWait] 
                                     asRoot:[SMPreferences defaultScriptRunAsRoot]];
                
        }
    }

}
@end
@implementation SMNewScriptsMenu (Private)
-(void)save
{
    if (_scriptOptions!=nil) {
        [_scriptOptions writeToFile:[SMNewScriptsMenu scriptsPlistPath] atomically:YES];
    }
}
@end
