//
//  SMDOSingleton.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMDOServer.h"

@interface SMDOSingleton : NSObject {
    SMDOServer *_doServer;
    NSConnection *_connection;
}
+ (SMDOSingleton*)singleton;
@end
