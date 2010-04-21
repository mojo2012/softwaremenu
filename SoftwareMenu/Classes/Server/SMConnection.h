//
//  SMConnection.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/7/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMConnection : NSObject {
    SimpleCocoaServer *server;
        id                      _moc;
}
+ (SMConnection*)singleton;
- (void)sendPlist:(NSDictionary *)output toConnection:(SimpleCocoaConnection *)con;
- (void)sendMessage:(NSString *)message toConnection:(SimpleCocoaConnection *)con;
- (void)remoteEvent:(NSDictionary *)dict fromConnection:(SimpleCocoaConnection *)con;
- (void)processMessage:(NSString *)message orData:(NSData *)data  fromConnection:(SimpleCocoaConnection *)con;
@end
