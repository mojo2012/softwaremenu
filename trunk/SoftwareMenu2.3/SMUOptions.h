//
//  SMUpdater.h
//  SoftwareMenu
//

//  Created by Thomas on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
////#import <BackRow/BackRow.h>
#import <Foundation/Foundation.h>

@interface SMUOptions : BRMediaMenuController {
	int padding[16];
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	
}
-(id)initCustom;
-(int)getSelection;
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;


@end
