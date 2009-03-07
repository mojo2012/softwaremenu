//
//  SMDownloaderController.h
//  SoftwareMenu
//
//  Created by Thomas on 3/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <BackRow/BRController.h>
#import <CoreData/CoreData.h>
#import <SMDownloaderSTD.h>

@class BRHeaderControl, BRTextControl,BRScrollingTextControl, BRImageControl, SMProgressBarControl;


@interface SMDownloaderController : SMDownloaderSTD 
{
	
}
-(void)processdownload;

@end
