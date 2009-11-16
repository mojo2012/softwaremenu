//
//  SMBuiltInMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//




@interface SMBuiltInMenu : SMMediaMenuController
{
}
-(BOOL)checkExists:(NSString *)thename;
+(NSArray *)frapArrays;
@end
