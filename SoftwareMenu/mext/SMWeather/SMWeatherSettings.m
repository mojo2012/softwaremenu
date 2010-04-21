//
//  SMWeatherSettings.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/15/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMWeatherSettings.h"
#define smweatherDomain  (CFStringRef)@"org.tomcool.SoftwareMenu.SMWeather"  
#define BRLocalizedString(key, comment)								[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, tbl, comment)				[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(tbl)]
#define BRLocalizedStringFromTableInBundle(key, tbl, obj, comment)	[BRLocalizedStringManager appliance:(obj) localizedStringForKey:(key) inFile:(tbl)]
@class SMPreferences;
@implementation SMWeatherSettings
-(id)init
{
    self = [super init];
    _items=[[NSMutableArray alloc]init];
    [_items retain];
    [self setListTitle:BRLocalizedString(@"Main Menu Settings bla",@"Main Menu Settings bla")];
    //[[self list] setDelegate:self];
    [[self list] setDatasource:self];
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
    NSLog(@"_items: %@",_items);
    return self;
}
-(id)itemForRow:(long)row
{
    NSLog(@"row: %i",row);
    return [_items objectAtIndex:row];
}
-(int)itemCount
{
    NSLog(@"itemcount");
    return [_items count];
}
//-(id)itemForRow:(long)row
//{
//    id item=[_items objectAtIndex:row];
//    switch (row) {
//        case 0:
//            ([SMPreferences customMainMenu]?[item setRightJustifiedText:@"YES"]:[item setRightJustifiedText:@"NO"]);
//            break;
//        case 1:
//            ([SMPreferences mainMenuBlockPreview]?[item setRightJustifiedText:@"YES"]:[item setRightJustifiedText:@"NO"]);
//            break;
//        case 2:
//            ([SMPreferences mainMenuEdgeFade]?[item setRightJustifiedText:@"YES"]:[item setRightJustifiedText:@"NO"]);
//            break;
//            
//        case 3:
//        {
//            NSString *sel=[SMPreferences selectedExtension];
//            if (sel==nil||[sel isEqualToString:@"None"]) {
//                [item setRightJustifiedText:@"None"];
//            }
//            else {                
//                [item setRightJustifiedText:[[sel lastPathComponent] stringByDeletingPathExtension]];
//            }
//            
//            break;
//        }
//        default:
//            break;
//    }
//    return item;
//}
//

//
//+ (NSArray *)arrayForKey:(NSString *)theKey
//{
//    NSArray  *myArray = [(NSArray *)CFPreferencesCopyAppValue((CFStringRef)theKey, smweatherDomain) autorelease];
//    if (myArray==nil) {
//        return [NSArray array];
//    }
//    return (NSArray *)myArray;
//}
//+(NSString *)stringForKey:(NSString *)theKey
//{
//    CFPreferencesAppSynchronize(smweatherDomain);
//    NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, smweatherDomain);
//    return (NSString *)myString;
//}
//+(BOOL)boolForKey:(NSString *)theKey
//{
//	Boolean temp;
//	Boolean outBool = CFPreferencesGetAppBooleanValue((CFStringRef)theKey, smweatherDomain, &temp);
//	return outBool;
//}
//-(id)init
//{
//    self=[super init];
//    _items = [[NSMutableArray alloc]init];
//    _options = [[NSMutableArray alloc] init];
//    [[self list] setDatasource:self];
//    [self setListTitle:BRLocalizedString(@"Weather Settings",@"Weather Settings")];
//    BRTextMenuItemLayer *item = [BRTextMenuItemLayer menuItem];
//    [item setTitle:@"Units"];//BRLocalizedString(@"Units",@"Units")];
//    [_items addObject:item];
//    
//    item =[BRTextMenuItemLayer folderMenuItem];
//    [item setTitle:@"Location"];//BRLocalizedString(@"Location",@"Location")];
//    [_items addObject:item];
//    
//    item =[BRTextMenuItemLayer folderMenuItem];
//    [item setTitle:@"Refresh"];//BRLocalizedString(@"Refresh Time",@"Refresh Time")];
//    [_items addObject:item];
//    [_items retain];
//    return self;
//}
//- (float)heightForRow:(long)row				{ return 0.0f;}
//- (BOOL)rowSelectable:(long)row				{ return YES;}
//- (long)itemCount							{ return (long)[_items count];}
////- (id)itemForRow:(long)row					
////{ 
////    NSLog(@"hello");
////    return [_items objectAtIndex:row];
////}
//- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title];}
//- (id)titleForRow:(long)row					{ 
//    NSLog(@"titleRow: %i %i %@",row,[_items count],[_items objectAtIndex:row]);return [[_items objectAtIndex:row] title];}
//- (long)defaultIndex						{ return 0;}
//
//- (void)dealloc
//{
//	[_items release];
//	[_options release];
//	[super dealloc];
//}
//-(int)getSelection
//{
//	BRListControl *list = [self list];
//	int row;
//	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(selection)];
//	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
//	[selInv setSelector:@selector(selection)];
//	[selInv invokeWithTarget:list];
//	if([signature methodReturnLength] == 8)
//	{
//		double retDoub = 0;
//		[selInv getReturnValue:&retDoub];
//		row = retDoub;
//	}
//	else
//		[selInv getReturnValue:&row];
//	return row;
//}
//-(void)controlWasActivated
//{
//    if([self respondsToSelector:@selector(everyLoad)])
//        [self everyLoad];
//    [super controlWasActivated];
//}
//- (void)wasExhumedByPoppingController:(id)fp8	{[self wasExhumed];}
//-(void)wasExhumed								{[[self list] reload];}
//-(id)everyLoad
//{
//    return nil;   
//}
//-(id)itemForRow:(long)row
//{
//    NSLog(@"row: %i %i",row,[_items count]);
//    
//    if (row<[_items count]) {
//        BRTextMenuItemLayer *item = [_items objectAtIndex:row];
//        switch (row) {
////            case 0:
////                //[item setRightJustifiedText:([SMWeatherSettings boolForKey:@"USUnits"]?@"Fahrenheit":@"Celsius")];
////                break;
//            case 1:
//            {
//                NSString *location=[SMWeatherSettings stringForKey:@"Location"];
//                if (location==nil) {
//                    location=@"615702";
//                }
//                [item setRightJustifiedText:location];
//                break;
//            }
//            case 2:
//            {
//                int time = 60;
//                [item setRightJustifiedText:[NSString stringWithFormat:@"%i",time,nil]];
//                break;
//            }
//            default:
//                break;
//        }
//        return item;
//    }
//    return nil;
//}
@end
