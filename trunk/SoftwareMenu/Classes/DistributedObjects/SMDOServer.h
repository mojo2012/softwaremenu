//
//  SMDOServer.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMDOprotocol.h"

@interface SMDOServer : NSObject<SMDOServerProtocol>{
NSMutableArray *clients;
}


@end
