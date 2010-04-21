//
//  SMMainMenuSettings.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//




@implementation SMMainMenuSettings
-(id)init
{
    self = [super init];
    [self setListTitle:BRLocalizedString(@"Main Menu Settings",@"Main Menu Settings")];
    BRTextMenuItemLayer *item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Custom Menu State",@"Custom Menu State")];
    [_items addObject:item];
    
    item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Block Preview",@"Block Preview")];
    [_items addObject:item];
    
    item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Black Edge Fade",@"Black Edge Fade")];
    [_items addObject:item];
    
    item =[BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"Select Extension",@"Select Extension")];
    [_items addObject:item];
    
    item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"Extension Options",@"Extension Options")];
    [_items addObject:item];
    
    item = [BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Apply Now",@"Apply Now")];
    [_items addObject:item];
    return self;
}
-(id)itemForRow:(long)row
{
    id item=[_items objectAtIndex:row];
    switch (row) {
        case 0:
            ([SMPreferences customMainMenu]?[item setRightJustifiedText:@"YES"]:[item setRightJustifiedText:@"NO"]);
            break;
        case 1:
            ([SMPreferences mainMenuBlockPreview]?[item setRightJustifiedText:@"YES"]:[item setRightJustifiedText:@"NO"]);
            break;
        case 2:
            ([SMPreferences mainMenuEdgeFade]?[item setRightJustifiedText:@"YES"]:[item setRightJustifiedText:@"NO"]);
            break;
            
        case 3:
        {
            NSString *sel=[SMPreferences selectedExtension];
            if (sel==nil||[sel isEqualToString:@"None"]) {
                [item setRightJustifiedText:@"None"];
            }
            else {                
                [item setRightJustifiedText:[[sel lastPathComponent] stringByDeletingPathExtension]];
            }

            break;
        }
        default:
            break;
    }
    return item;
}
-(void)itemSelected:(long)arg1
{
    switch (arg1) {
        case 0:
        {
            [SMPreferences setCustomMainMenu:![SMPreferences customMainMenu]];
            
            //[[[BRApplicationStackManager singleton] stack] swapController:newController];
            
           break; 
        }
        case 1:
        {
            [SMPreferences setMainMenuBlockPreview:![SMPreferences mainMenuBlockPreview]];
            
            //[[[BRApplicationStackManager singleton] stack] swapController:newController];
            
            break; 
        }
        case 2:
        {
            [SMPreferences setMainMenuEdgeFade:![SMPreferences mainMenuEdgeFade]];
            
            //[[[BRApplicationStackManager singleton] stack] swapController:newController];
            
            break; 
        }
        case 3:
        {
            id a =[[SMMainMenuSelection alloc]init];
            [[self stack]pushController:a];
            [a release];
            break;
        }
        case 4:
        {
            NSBundle *controlBundle = [[NSBundle bundleWithPath:[SMPreferences selectedExtension]]retain];
            NSLog(@"found Bundle");
            [controlBundle load];
            id<SMMextProtocol> pc=[[[controlBundle principalClass] alloc]init];
            NSLog(@"loaded principal class");
            NSLog(@"control: %@",[pc backgroundControl]);
            NSLog(@"controller: %@",[pc ioptions]);
            [[self stack]pushController:[pc ioptions]];
            
//            if (![bundle isLoaded]) {
//                [bundle load];
//            }
//            NSLog(@"bundlePath: %@",[SMPreferences selectedExtension]);
//            if ([[bundle principalClass] hasPluginSpecificOptions]) {
//                NSLog(@"hasOptions");
//                id ctrl= [[[bundle principalClass] alloc] init];
//                [ctrl controller];
                //NSLog(@"controller: %@",ctrl2);
                //[[self stack]pushController:[ctrl2 retain]];
//                [controller release];
//                
//
//                
//            }
            break;
        }
        case 5:
        {
            if ([SMPreferences customMainMenu]) {
                id newController = [[SMMainMenuController alloc]init];
                [[[BRApplicationStackManager singleton] stack] replaceAllControllersWithController:newController];
            }
            else {
                id newController = [[BRMainMenuController alloc]init];
                [[[BRApplicationStackManager singleton] stack] replaceAllControllersWithController:newController];
            }
            break;

        }
            
        default:
            break;
    }
    [[self list] reload];
}
@end
