//
//  SMDOprotocol.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol SMDOClientProtocol
/*
 *  Send Messages that go to the log
 */
- (oneway void)sendMessage:(in bycopy NSString *)message;

/*
 *  Send Dictionaries with Information
 */
- (oneway void)sendPlist:(in bycopy NSDictionary *)plist;


/*
 * Send ImageData
 */
- (oneway void)sendImage:(in bycopy NSData *)image;

@end

@protocol SMDOServerProtocol
/*
 *  Send Request Dictionary
 */
-(oneway void)sendRequest:(in bycopy NSDictionary *)plist fromClient:(in byref id <SMDOClientProtocol>)client;

/*
 * Connect Client to Server
 */
- (BOOL)subscribeClient:(in byref id <SMDOClientProtocol>)newClient;


/*
 * Disconnect Client
 */
- (void)unsubscribeClient:(in byref id <SMDOClientProtocol>)client;
@end