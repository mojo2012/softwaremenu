//
//  SMWeatherBaseController.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/24/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMWeatherBaseController.h"
#import "SMWeatherController.h"


@implementation SMWeatherBaseController

-(id)init
{
    self=[super init];
//    if (_locations!=nil) {
//        [_locations release];
//    }
//    _locations=[[SMWeatherController Locations] mutableCopy];
//    [_locations retain];
    [self setListTitle:BRLocalizedString(@"Weather",@"Weather")];
    BRTextMenuItemLayer *item=[BRTextMenuItemLayer menuItem];
    [item setTitle:BRLocalizedString(@"Units",@"Units")];
    [_items addObject:item];
    [_options addObject:@""];
    
    item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"Refresh Time",@"Refresh Time")];
    [_items addObject:item];
    [_options addObject:@""];
    
    item=[BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"New Location",@"New Location")];
    [_items addObject:item];
    [_options addObject:@""];
    

    

    _notLocs=[_items count];
    [[self list] addDividerAtIndex:[_items count] withLabel:BRLocalizedString(@"Locations",@"Locations")];
    [self loadLocations];
//    NSLog(@"locations: %@",_locations);
//    for(i=0;i<count;i++)
//    {
//        item = [BRTextMenuItemLayer folderMenuItem];
//        NSString *location=[[_locations objectForKey:[keys objectAtIndex:i]] objectForKey:@"city"];
//        if(location == nil)
//            location = [NSString stringWithFormat:@"%i",[[[_locations objectForKey:[keys objectAtIndex:i]] objectForKey:@"code"]intValue]];
//        if (location != nil) {
//            NSLog(@"location: %@",location);
//            [item setTitle:location];
//            [_items addObject:item];
//        }
//        
//    }
    return self;
}
-(void)loadLocations
{
    NSLog(@"range: %i %i",_notLocs,[_items count]-_notLocs);

    [_items removeObjectsInRange:NSMakeRange(_notLocs, [_items count]-_notLocs)];
    NSLog(@"_items: %@",_items);
    if (_locations!=nil) {
        [_locations release];
    }
    _locations=[[SMWeatherController Locations] mutableCopy];
    [_locations retain];
    NSArray *keys = [_locations allKeys];
    int i,count=[keys count];
    BRTextMenuItemLayer *item;
    for(i=0;i<count;i++)
    {
        item = [BRTextMenuItemLayer folderMenuItem];
        NSString *location=[[_locations objectForKey:[keys objectAtIndex:i]] objectForKey:@"city"];
        if(location == nil)
            location = [NSString stringWithFormat:@"%i",[[[_locations objectForKey:[keys objectAtIndex:i]] objectForKey:@"code"]intValue]];
        if (location != nil) {
            NSLog(@"location: %@",location);
            [item setTitle:location];
            [_items addObject:item];
            [_options addObject:[[_locations objectForKey:[keys objectAtIndex:i]] objectForKey:@"code"]];
        }
        
    }
    
}
-(id)itemForRow:(long)row
{
    BRTextMenuItemLayer *item = [_items objectAtIndex:row];
    if (row==0) {
        [item setRightJustifiedText:([SMWeatherController USUnits]?@"Fahrenheit":@"Celsius")];
    }
    if (row==1) {
        int time=[SMWeatherController refreshMinutes];
        [item setRightJustifiedText:[NSString stringWithFormat:@"(%i minutes)",time,nil]];
    }
    if (row<[_items count]) {
        
    }
    return item;
}
-(void)itemSelected:(long)row
{
    if(row==0)
    {
        [SMWeatherController setUSUnits:![SMWeatherController USUnits]];
    }
    else if(row==1){
        id controller=[SMFPasscodeController passcodeWithTitle:@"Refresh Time" 
                                               withDescription:@"Please set the refresh time in minutes" 
                                                     withBoxes:3 
                                                  withDelegate:self];
        [[self stack] pushController:controller];
        _current=2;
        
    }

    else if(row==2)
    {
        id controller = [SMFPasscodeController passcodeWithTitle:@"Yahoo Weather Code" 
                                                 withDescription:@"Please insert the appropriate yahoo weather code for the location you are looking for" 
                                                       withBoxes:8 
                                                    withDelegate:self];
        _current=1;
        [[self stack] pushController:controller];
    }
    else {
        NSArray *timeZones=[NSTimeZone knownTimeZoneNames];
        NSMutableArray *invocations=[[NSMutableArray alloc] init];
        int i,count=[timeZones count];
        for(i=0;i<count;i++)
        {
            id anInvocation = [SMFInvocationCenteredMenuController invocationsForObject:self
                                                                        withSelectorVal:@"setTimeZone:forCode:"
                                                                          withArguments:[NSArray arrayWithObjects:[timeZones objectAtIndex:i],[_options objectAtIndex:row],nil]];
            [invocations addObject:anInvocation];
        }
        id a =[[SMFInvocationCenteredMenuController alloc]initWithTitles:timeZones
                                                         withInvocations:invocations 
                                                               withTitle:[NSString stringWithFormat:@"Select Time Zone for: %@",[[_items objectAtIndex:row]title],nil] 
                                                         withDescription:@"Please select a time zone"];
        [[self stack]pushController:a];
        [a release];
//        NSArray *titles=[NSArray arrayWithObjects:
//                         BRLocalizedString(@"Remove",@"Remove"),
//                         BRLocalizedString(@"Do Not Remove",@"Do Not Remove"),
//                         nil];
//        id anInvocation = [SMFInvocationCenteredMenuController invocationsForObject:self
//                                                                    withSelectorVal:@"remove:"
//                                                                      withArguments:[NSArray arrayWithObject:[_options objectAtIndex:row]]];
//        NSArray *invocations = [NSMutableArray arrayWithObjects:anInvocation,@"b",nil];
//        id a= [[SMFInvocationCenteredMenuController alloc] initWithTitles:titles
//                                                          withInvocations:invocations
//                                                                withTitle:BRLocalizedString(@"Remove?",@"Remove")
//                                                          withDescription:BRLocalizedString(@"This will permanently remove the selected city",@"This will permanently remove the selected city")];
//        
//        [[self stack] pushController:a];
//        [a release];
    }

    
    [[self list] reload];
}
- (void) textDidChange: (id) sender
{
	//Do Nothing Now
}
- (void) textDidEndEditing: (id) sender
{
    [[self stack] popController];
    
    switch (_current) {
        case 1:
        {
            int code=[[sender stringValue]intValue];
            NSDictionary *dict=[SMWeatherMext loadDictionaryForCode:code];
            if([[dict allKeys] count]!=0)
            {
                NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:code],@"code",
                                          [dict objectForKey:@"city"],@"city",
                                          nil];
                [_locations setObject:infoDict forKey:[NSString stringWithFormat:@"%i",code,nil]];
                [SMWeatherController setLocations:_locations];
                [self loadLocations];
            }
            break;
            
        }
        case 2:
            [SMWeatherController setRefreshMinutes:[[sender stringValue]intValue]];
            break;
        default:
            break;
    }
	[[self list] reload];
}
-(void)setTimeZone:(NSString *)tz forCode:(NSNumber *)code
{
    if ([[_locations allKeys] containsObject:[code stringValue]]) {
        NSMutableDictionary *obj=[[_locations objectForKey:[code stringValue]]mutableCopy];
        NSLog(@"obj: %@",obj);
        [obj setObject:tz forKey:@"timeZone"];
        [_locations setObject:obj forKey:[code stringValue]];
        [SMWeatherController setLocations:_locations];
        
    }
}
-(void)remove:(NSNumber *)code
{
    [_locations removeObjectForKey:[code stringValue]];
    [SMWeatherController setLocations:_locations];
    if ([SMWeatherController yWeatherCode]==[code intValue]) {
        NSArray *keys = [_locations allKeys];
        if ([keys count]==0) {
            [SMWeatherController setDefaultYWeatherCode];
        }
        else {
            [SMWeatherController setYWeatherCode:[[keys objectAtIndex:0] intValue]];
        }
    }
}
@end
