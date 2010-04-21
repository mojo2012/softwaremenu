//
//  SMHTTPServer.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/10/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SimpleHTTPServer.h"
#import "SimpleHTTPConnection.h"

@interface SMHTTPServer : NSObject {
    SimpleHTTPServer *_server;
}
+ (SMHTTPServer*)singleton;
-(void)stopProcessing;
-(void)processURL:(NSString *)url connection:(SimpleHTTPConnection *)con;
@end
