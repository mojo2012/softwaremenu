//
//  SMWeatherSelector.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/24/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMWeatherSelector.h"
#import "SMWeatherController.h"

@interface SMGeneralMethods : NSObject
+(SMGeneralMethods *)sharedInstance;
-(void)popController:(BRController *)controller;

@end

@implementation SMWeatherSelector
-(id)init
{
    self = [super init];
    [self setListTitle:BRLocalizedString(@"Select Location",@"Select Location")];
    NSDictionary *locations = [SMWeatherController Locations];
    NSArray *keys = [locations allKeys];
    if ([keys count]==0) {
        BRAlertController *alertController = [BRAlertController alertOfType:0 
                                                                     titled:BRLocalizedString(@"No Locations Defined", @"No Locations Defined") 
                                                                primaryText:BRLocalizedString(@"Showing Paris as Default",@"Showing Paris as Default")
                                                              secondaryText:BRLocalizedString(@"Popping this Alert in 10 secs", @"secondary text when network mount fails")];
		[alertController retain];
        [[[BRApplicationStackManager singleton] stack] pushController:alertController];
		[[SMGeneralMethods sharedInstance] performSelector:@selector(popController:) withObject:alertController afterDelay:10.0];
        return nil;
    }
    int i,count = [keys count];

    BRTextMenuItemLayer *item;
    for(i=0;i<count;i++)
    {
        item = [BRTextMenuItemLayer folderMenuItem];
        NSString *location=[[locations objectForKey:[keys objectAtIndex:i]] objectForKey:@"city"];
        if(location == nil)
            location = [NSString stringWithFormat:@"%i",[[[locations objectForKey:[keys objectAtIndex:i]] objectForKey:@"code"]intValue]];
        if (location != nil) {
            NSLog(@"location: %@",location);
            [item setTitle:location];
            [_items addObject:item];
            [_options addObject:[[locations objectForKey:[keys objectAtIndex:i]] objectForKey:@"code"]];
        }
        
    }
    [self setPrimaryInfoText:BRLocalizedString(@"Please Select a Location",@"Please Select a Location")];
    return self;
    
}
-(void)itemSelected:(long)arg1
{
    int code = [[_options objectAtIndex:arg1] intValue];
    [SMWeatherController setYWeatherCode:code];
    [SMWeatherMext reload];
    [[self stack]popController];
}
@end
