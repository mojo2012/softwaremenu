/*
 *  SMCommonHeader.h
 *  
 *
 *  Created by Thomas Cool on 4/24/10.
 *  Copyright 2010 Thomas Cool. All rights reserved.
 *
 */

#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) do {} while (0)
#endif
#define ALog(...) NSLog(__VA_ARGS__)

#define smweatherDomain  (CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu.SMWeather" 
#define BRLocalizedString(key, comment)								[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, tbl, comment)				[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(tbl)]
#define BRLocalizedStringFromTableInBundle(key, tbl, obj, comment)	[BRLocalizedStringManager appliance:(obj) localizedStringForKey:(key) inFile:(tbl)]