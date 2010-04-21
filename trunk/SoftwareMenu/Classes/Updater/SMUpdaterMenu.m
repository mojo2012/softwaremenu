//
//  SMUpdaterMenu.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 12/4/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMUpdaterMenu.h"

#define UDISPLAY @"display"

@implementation SMUpdaterMenu
-(id)init
{
    self=[super init];
    
    _options=[[NSMutableArray alloc] initWithArray:[self getChoices:UPDATE_URL]];
    int i;
    sel_version=-1;
    if ([_options count]!=0) {
        for(i=0;i<[_options count];i++)
            if([[[_options objectAtIndex:i] objectForKey:UDISPLAY] isEqualToString:[SMPreferences appleTVVersion]])
                sel_version=i;
        if(sel_version=-1)
            sel_version=[_options count]-1;
                
    }
        [_options retain];
    _names = [NSArray arrayWithObjects:BRLocalizedString(@"ReadMe",@"ReadMe"),
              BRLocalizedString(@"Prepare OS version:",@"Prepare OS version:"),
              BRLocalizedString(@"Launch Update Tool",@"Launch Update Tool"),
              BRLocalizedString(@"Options",@"Options"),nil];
    [_names retain];
    [_options retain];
    _items = [[NSMutableArray alloc] init];
    NSEnumerator * enume = [_names objectEnumerator];
    id obj;
    while (obj=[enume nextObject]) {
        BRTextMenuItemLayer *item = [BRTextMenuItemLayer menuItem];
        [item setTitle:obj];
        [_items addObject:item];
    }
    [_items retain];
    [self setListTitle: BRLocalizedString(@"Updater",@"Updater")];
    [[self list]setDatasource:self];
    [[self list]addDividerAtIndex:1 withLabel:BRLocalizedString(@"Step 1",@"Step 1")];
    [[self list]addDividerAtIndex:2 withLabel:BRLocalizedString(@"Step 2",@"Step 2")];
    [[self list]addDividerAtIndex:3 withLabel:BRLocalizedString(@"Options",@"Options")];

    return self;
}
-(id)itemForRow:(long)row
{
    if (row>=[_items count])
        return nil;
    BRTextMenuItemLayer *item = [_items objectAtIndex:row];
    switch (row) {
        case 2:
        {
            NSFileManager *man = [NSFileManager defaultManager];
            BOOL isDir;
            NSString *updateDir=[@"~/Updates" stringByExpandingTildeInPath];
            if ([man fileExistsAtPath:updateDir isDirectory:&isDir]&&
                isDir&&
                [man fileExistsAtPath:[updateDir stringByAppendingPathComponent:@"final.dmg"]])
                [item setDimmed:NO];
            else
                [item setDimmed:YES];
            break;
        }
        case 1:
        {
            if([_options count]!=0)
               {
                   [item setRightJustifiedText:[[_options objectAtIndex:sel_version]objectForKey:UDISPLAY]];
                   [item setDimmed:NO];
               }
            else {
                [item setDimmed:YES];
            }


        }
        default:
            break;
    }
    return item;
}
- (BOOL)brEventAction:(BREvent *)event
{
	int remoteAction =[SMGeneralMethods remoteActionForBREvent:event];
	
	if ([(BRControllerStack *)[self stack] peekController] != self)
		return [super brEventAction:event];
	if([event value] == 0)
		return [super brEventAction:event];
//	if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] && remoteAction>1)
//		remoteAction ++;
	long row = [self getSelection];

	switch (remoteAction)
	{
        case kBREventRemoteActionSwipeUp:
            break;
		case kBREventRemoteActionUp:  // tap up
			break;
		case kBREventRemoteActionDown:  // tap down
			break;
        case kBREventRemoteActionSwipeDown:
            break;
        case kBREventRemoteActionSwipeLeft:
		case kBREventRemoteActionLeft:  // tap left
        {
            if(row==1&&![[self itemForRow:row] dimmed])
            {
                sel_version--;
                if (sel_version<0) 
                    sel_version=[_options count]-1;
            }
            [[self list]reload];
            break;
        }
        case kBREventRemoteActionSwipeRight:
        case kBREventRemoteActionRight:
        {
            if(row==1&&![[self itemForRow:row] dimmed])
            {
                sel_version++;
                if (sel_version==[_options count]) 
                    sel_version=0;
            }
            [[self list]reload];
            break;
            
        }

		case kBREventRemoteActionPlay: 
            break;
        case kBREventRemoteActionPlayHold:
        {
            [[self stack]pushController:[[SMUpdaterMenu alloc]init]];
            break;
        }
	}
	return [super brEventAction:event];
}

-(void)itemSelected:(long)arg1
{
    if (arg1==0) 
    {
        NSString *downloadedDescription = [NSString  stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"readmeupd" ofType:@"txt"] encoding:NSUTF8StringEncoding error:NULL];
		SMInfo* newController=[[SMInfo alloc] init];
		[newController setDescription:downloadedDescription];
		[newController setTheName:@"README"];
		[[self stack] pushController:newController];
    }
    else if (arg1==1&& ![[self itemForRow:arg1] dimmed]) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:[[_options objectAtIndex:sel_version] objectForKey:@"xml_location"]]];
        [[self stack]pushController:[[SMUpdaterPreprocess alloc]initWithForVersionDictionary:dict forVersion:[[_options objectAtIndex:sel_version] objectForKey:UDISPLAY]]];
    }
    else if (arg1==1&& [[self itemForRow:arg1] dimmed])
    {
        [[self stack]pushController:[BRAlertController alertOfType:1 titled:@"No Updates" primaryText:@"No Updates were found" secondaryText:@"is your appletv connected to the internet?"]];
    }
    else if(arg1==2 && ![[self itemForRow:arg1] dimmed])
	{
//		NSTask *task7 = [[NSTask alloc] init];
//		NSArray *args7 = [NSArray arrayWithObjects:@"-osupdate",@"0",@"0",nil];
//		[task7 setArguments:args7];
//		[task7 setLaunchPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""]];
//		[task7 launch];
//		[task7 waitUntilExit];
        [[SMHelper helperManager]launchUpdateWithFolder:@"/Users/frontrow/Updates"];
	}
    else if(arg1==3)
    {
        SMUpdaterOptions *newController2 = [[SMUpdaterOptions alloc] init];
		[newController2 initCustom];
		[[self stack] pushController:newController2];
        
    }
    [[self list]reload];
}
-(id)getChoices:(NSString *)URL
{
	
	NSData *outData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
	NSString *error;
	NSPropertyListFormat format;
	id vDict;
	vDict = [NSPropertyListSerialization propertyListFromData:outData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	return vDict;
}
@end
