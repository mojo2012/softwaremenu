//
//  SMFPreferences.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/20/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMFPreferences.h"


@implementation SMFPreferences
- (id) initWithPersistentDomainName:(NSString *)domainName
{
	if ((self = [super init]))
	{
		_applicationID = [domainName copy];
		_registrationDictionary = nil;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
	}
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[_applicationID release];
	[_registrationDictionary release];
	[super dealloc];
}


- (void) _applicationWillTerminate:(NSNotification *)notification
{
	[self synchronize];
}


- (id)objectForKey:(NSString *)defaultName
{
	id value = [(id)CFPreferencesCopyAppValue((CFStringRef)defaultName, (CFStringRef)_applicationID) autorelease];
	if (value == nil)
		value = [_registrationDictionary objectForKey:defaultName];
	return value;
}

- (void)setObject:(id)value forKey:(NSString *)defaultName
{
	CFPreferencesSetAppValue((CFStringRef)defaultName, (CFPropertyListRef)value, (CFStringRef)_applicationID);
    [self synchronize];
}
+ (void)setBool:(BOOL)inputBool forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithBool:inputBool], (CFStringRef)_applicationID);
	[self synchronize];
}

- (void)removeObjectForKey:(NSString *)defaultName
{
	CFPreferencesSetAppValue((CFStringRef)defaultName, NULL, (CFStringRef)_applicationID);
    [self synchronize];
}


- (void)registerDefaults:(NSDictionary *)registrationDictionary
{
	[_registrationDictionary release];
	_registrationDictionary = [registrationDictionary retain];
}


- (BOOL)synchronize
{
	return CFPreferencesSynchronize((CFStringRef)_applicationID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
}

@end
