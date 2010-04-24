//
//  SMWeatherController.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/16/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMWeatherController.h"
#define smweatherDomain  (CFStringRef)@"org.tomcool.SoftwareMenu.SMWeather"  
#define BRLocalizedString(key, comment)								[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, tbl, comment)				[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(tbl)]
#define BRLocalizedStringFromTableInBundle(key, tbl, obj, comment)	[BRLocalizedStringManager appliance:(obj) localizedStringForKey:(key) inFile:(tbl)]
@interface SMFPasscodeController
+ (SMFPasscodeController *)passcodeWithTitle:(NSString *)title withDescription:(NSString *)description withBoxes:(int)boxes withDelegate:(id)delegate;
@end

@implementation SMWeatherController
- (float)heightForRow:(long)row				{ return 0.0f;}
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
//- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row];}
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title];}
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title];}
- (long)defaultIndex						{ return 0;}
//- (id)previewControlForItem:(long)row
//{
//    BRImage * image = [[BRThemeInfo sharedTheme] appleTVIcon];
//    BRImageAndSyncingPreviewController *preview = [[BRImageAndSyncingPreviewController alloc] init];
//    [preview setImage:image];
//	return preview;
//}
+ (void)setInteger:(int)theInt forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt], smweatherDomain);
	CFPreferencesAppSynchronize(smweatherDomain);
}
+ (int)integerForKey:(NSString *)theKey
{
	Boolean temp;
	
	int outInt = CFPreferencesGetAppIntegerValue((CFStringRef)theKey, smweatherDomain, &temp);
	return outInt;
	
}
+ (NSArray *)arrayForKey:(NSString *)theKey
{
    NSArray  *myArray = [(NSArray *)CFPreferencesCopyAppValue((CFStringRef)theKey, smweatherDomain) autorelease];
    if (myArray==nil) {
        return [NSArray array];
    }
    return (NSArray *)myArray;
}
+(NSString *)stringForKey:(NSString *)theKey
{
    CFPreferencesAppSynchronize(smweatherDomain);
    NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, smweatherDomain);
    return (NSString *)myString;
}
+(BOOL)boolForKey:(NSString *)theKey
{
	Boolean temp;
	Boolean outBool = CFPreferencesGetAppBooleanValue((CFStringRef)theKey, smweatherDomain, &temp);
	return outBool;
}
+ (void)setBool:(BOOL)inputBool forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithBool:inputBool], smweatherDomain);
	CFPreferencesAppSynchronize(smweatherDomain);
}
- (id)init
{
    self=[super init];
    [self setListTitle:@"Weather Plugin Options"];
    _items = [[NSMutableArray alloc]init];
    _options = [[NSMutableArray alloc] init];
    [self setUseCenteredLayout:YES];
    BRTextMenuItemLayer * item = [BRTextMenuItemLayer menuItem];
    [item setTitle:@"Units"];
    [_items addObject:item];
    
    item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:@"Yahoo Weather Code"];
    [_items addObject:item];
    
    
    item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:@"Refresh Time"];
    [_items addObject:item];
    
    item = [BRTextMenuItemLayer networkMenuItem];
    [item setTitle:@"Test Settings"];
    [_items addObject:item];
    
    [[self list] setDatasource:self];
    return self;
}
- (void)dealloc
{
	[_items release];
	[_options release];
	[super dealloc];
}
-(id)everyLoad
{
    return self;
}
-(int)getSelection
{
	BRListControl *list = [self list];
	int row;
	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(selection)];
	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
	[selInv setSelector:@selector(selection)];
	[selInv invokeWithTarget:list];
	if([signature methodReturnLength] == 8)
	{
		double retDoub = 0;
		[selInv getReturnValue:&retDoub];
		row = retDoub;
	}
	else
		[selInv getReturnValue:&row];
	return row;
}
-(void)controlWasActivated
{
    if([self respondsToSelector:@selector(everyLoad)])
        [self everyLoad];
    [super controlWasActivated];
}
-(id)itemForRow:(long)row
{
    //NSLog(@"row: %i %i",row,[_items count]);
    
    if (row<[_items count]) {
        BRTextMenuItemLayer *item = [_items objectAtIndex:row];
        switch (row) {
            case 0:
                [item setRightJustifiedText:([SMWeatherController boolForKey:@"USUnits"]?@"Fahrenheit":@"Celsius")];
                break;
            case 1:
            {
                int location=[SMWeatherController integerForKey:@"Location"];
                if (location==nil) {
                    location=615702;
                }
                [item setRightJustifiedText:[NSString stringWithFormat:@"%i", location]];
                break;
            }
            case 2:
            {
                int time=[SMWeatherController integerForKey:@"Time"];
                if (time==nil) {
                    time=60;
                }
                [item setRightJustifiedText:[NSString stringWithFormat:@"(%i minutes)",time,nil]];
                break;
            }
            default:
                break;
        }
        return item;
    }
    return nil;
}
-(void)itemSelected:(long)arg1
{
    switch (arg1) {
        case 0:
            [SMWeatherController setBool:![SMWeatherController boolForKey:@"USUnits"] forKey:@"USUnits"];
            break;
        case 1:
        {
            id controller = [SMFPasscodeController passcodeWithTitle:@"Yahoo Weather Code" 
                                                     withDescription:@"Please insert the appropriate yahoo weather code for the location you are looking for" 
                                                           withBoxes:8 
                                                        withDelegate:self];
            _current=1;
            [[self stack] pushController:controller];
            break;
        }

        case 2:
        {
            id controller=[SMFPasscodeController passcodeWithTitle:@"Refresh Time" 
                                     withDescription:@"Please set the refresh time in minutes" 
                                           withBoxes:3 
                                        withDelegate:self];
            [[self stack] pushController:controller];
            _current=2;
            break;
        }

        default:
            break;
    }
    [[self list] reload];
}
- (void)wasExhumedByPoppingController:(id)fp8	{[self wasExhumed];}
-(void)wasExhumed								{[[self list] reload];}
- (void) textDidChange: (id) sender
{
	//Do Nothing Now
}
- (void) textDidEndEditing: (id) sender
{
    [[self stack] popController];

    switch (_current) {
        case 1:
            [SMWeatherController setInteger:[[sender stringValue]intValue] forKey:@"Location"];
            break;
        case 2:
            [SMWeatherController setInteger:[[sender stringValue]intValue] forKey:@"Time"];
            break;
        default:
            break;
    }
	[[self list] reload];
}
@end
