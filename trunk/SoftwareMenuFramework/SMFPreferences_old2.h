//
//  SMFPreferences.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/20/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMFPreferences : NSUserDefaults {
	NSString * _applicationID;
	NSDictionary * _registrationDictionary;
}

- (id) initWithPersistentDomainName:(NSString *)domainName;

@end


@interface NSUserDefaultsController (SetDefaults)
- (void) _setDefaults:(NSUserDefaults *)defaults;
@end
