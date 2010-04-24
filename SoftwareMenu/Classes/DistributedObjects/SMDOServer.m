//
//  SMDOServer.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMDOServer.h"


@implementation SMDOServer
- (id)init
{
    if (self = [super init]) {
        clients = [[NSMutableArray alloc] init];
    }
    NSLog(@"Starting DO server");
    return self;
}




/*
 *Called By Client
 */
- (BOOL)subscribeClient:(in byref id <SMDOClientProtocol>)newClient
{

    NSLog(@"adding client");
//    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"one.plist"]];
//    NSLog(@"dict: %@",dict);
    [clients addObject:newClient];
//    [newClient sendPlist:dict];
    return YES;
}
-(oneway void)sendRequest:(in bycopy NSDictionary *)plist fromClient:(in byref id <SMDOClientProtocol>)client
{
    [client sendMessage:@"Request Acknowledged"];
}
-(void)unsubscribeClient:(identifier identifier id SMDOClientProtocol)client
{
    
}
@end
