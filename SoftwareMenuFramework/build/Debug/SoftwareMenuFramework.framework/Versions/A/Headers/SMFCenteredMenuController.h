//
//  SMFCenteredMediaMenuController.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/25/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMFMediaMenuController;
@interface SMFCenteredMenuController : BRMenuController {
	int padding[128];
	NSMutableArray *	_items;
	NSMutableArray *	_options;
}
    -(float)heightForRow:(long)row;
    -(BOOL)rowSelectable:(long)row;
    -(long)itemCount;
    -(id)itemForRow:(long)row;
    -(long)rowForTitle:(id)title;
    -(id)titleForRow:(long)row;
    -(int)getSelection;
    -(id)everyLoad;
    

@end
