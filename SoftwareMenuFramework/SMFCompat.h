//
//  SMFCompat.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/22/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMFCompat : NSObject {

}
+ (BOOL)greaterThanVersion:(NSString *)version;
+ (BOOL)twoPointThreeOrGreater;
+ (BOOL)threePointZeroOrGreater;
+ (BOOL)versionEqual:(NSString *)version;
+ (BOOL)usingTwoPointThree;
@end
static inline void SMFLoadFramework(NSString *frameworkPath)
{
	CFStringRef preferencesDomain = CFSTR("com.apple.frontrow.appliance.SMFramework");
	CFStringRef loadPathKey = CFSTR("loadPath");
	CFPreferencesAppSynchronize(preferencesDomain);
	CFPropertyListRef loadPathProperty = CFPreferencesCopyAppValue(loadPathKey, preferencesDomain);
	CFStringRef loadPath = nil;
	if(loadPathProperty != nil && CFGetTypeID(loadPathProperty) == CFStringGetTypeID())
		loadPath = (CFStringRef)loadPathProperty;
	
	NSString *compatPath = [frameworkPath stringByAppendingPathComponent:@"SoftwareMenuFramework.framework"];
	NSBundle *compat = [NSBundle bundleWithPath:compatPath];
	
	if(NSClassFromString(@"SMFCompat") == nil)
	{
		if(loadPath != nil)
		{
			NSBundle *otherBundle = [NSBundle bundleWithPath:(NSString *)loadPath];
			NSString *myVersion = [compat objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
			NSString *otherVersion = [otherBundle objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
			
			if(otherVersion != nil && [myVersion compare:otherVersion] == NSOrderedAscending)
				compat = otherBundle;
		}
		
		if( ![compat load]){ 
			@throw [NSException exceptionWithName:@"FileNotFoundException" reason:[NSString stringWithFormat:@"SoftwareMenuFramework could not be loaded from path %@", compatPath] userInfo:nil];
		}
//		if([SapphireFrontRowCompat usingLeopardOrATypeOfTakeTwo])
//		{
//			compatPath = [frameworkPath stringByAppendingPathComponent:@"SapphireLeopardCompatClasses.framework"];
//			compat = [NSBundle bundleWithPath:compatPath];
//			if( ![compat load]){ 
//				@throw [NSException exceptionWithName:@"FileNotFoundException" reason:[NSString stringWithFormat:@"SapphireLeopardCompatClasses could not be loaded from path %@", compatPath] userInfo:nil];
//			}
//		}
//		// ATV2
//		if([SapphireFrontRowCompat usingATypeOfTakeTwo])
//		{
//			compatPath = [frameworkPath stringByAppendingPathComponent:@"SapphireTakeTwoCompatClasses.framework"];
//			compat = [NSBundle bundleWithPath:compatPath];
//			if( ![compat load]){ 
//				@throw [NSException exceptionWithName:@"FileNotFoundException" reason:[NSString stringWithFormat:@"SapphireTakeTwoCompatClasses could not be loaded from path %@", compatPath] userInfo:nil];
//			}
//		}
//		//ATV2.2
//		if([SapphireFrontRowCompat atvVersion] >= SapphireFrontRowCompatATVVersion2Dot2)
//		{
//			compatPath = [frameworkPath stringByAppendingPathComponent:@"SapphireTakeTwoPointTwoCompatClasses.framework"];
//			compat = [NSBundle bundleWithPath:compatPath];
//			if( ![compat load]){ 
//				@throw [NSException exceptionWithName:@"FileNotFoundException" reason:[NSString stringWithFormat:@"SapphireTakeTwoPointTwoCompatClasses could not be loaded from path %@", compatPath] userInfo:nil];
//			}
//		}
//		//ATV3
//		if([SapphireFrontRowCompat atvVersion] >= SapphireFrontRowCompatATVVersion3)
//		{
//			compatPath = [frameworkPath stringByAppendingPathComponent:@"SapphireTakeThreeCompatClasses.framework"];
//			compat = [NSBundle bundleWithPath:compatPath];
//			if( ![compat load]){ 
//				@throw [NSException exceptionWithName:@"FileNotFoundException" reason:[NSString stringWithFormat:@"SapphireTakeThreeCompatClasses could not be loaded from path %@", compatPath] userInfo:nil];
//			}
//		}
	}
	else
	{
		//Check to see if we are later and mark it in preferences
		NSBundle *loadedBundle = [NSBundle bundleForClass:NSClassFromString(@"SMFCompat")];
		NSString *loadedVersion = [loadedBundle objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
		NSString *myVersion = [compat objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
		
		if([loadedVersion compare:myVersion] == NSOrderedAscending)
		{
			//Check the one in the prefs too
			NSBundle *otherBundle = [NSBundle bundleWithPath:(NSString *)loadPath];
			NSString *otherVersion = [otherBundle objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
			if(otherVersion == nil || [otherVersion compare:myVersion] == NSOrderedAscending)
			{
				CFPreferencesSetAppValue(loadPathKey, (CFStringRef)compatPath, preferencesDomain);
				CFPreferencesAppSynchronize(preferencesDomain);
				//Likely need to restart Finder here (delayed) or something because the next time around, the newer framework will be loaded.
			}
		}
	}
	if(loadPathProperty)
		CFRelease(loadPathProperty);
}
