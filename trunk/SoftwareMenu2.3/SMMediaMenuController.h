//
//  SMMediaMenuController.h
//  SoftwareMenu
//
//  Created by Thomas on 4/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface SMMediaMenuController : BRMediaMenuController {
	int padding[16];
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


@end
