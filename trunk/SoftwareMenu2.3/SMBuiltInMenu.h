//
//  SMBuiltInMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
////#import <BackRow/BackRow.h>
#import "SMMediaMenuController.h"


@interface SMBuiltInMenu : SMMediaMenuController
{
}
-(BOOL)checkExists:(NSString *)thename;

@end
