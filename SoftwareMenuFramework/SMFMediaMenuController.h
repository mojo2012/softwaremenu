//
//  SMMediaMenuController.h
//  SoftwareMenuFramework
//
//  Created by Thomas on 4/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BRMediaMenuController;
@interface SMFMediaMenuController : BRMediaMenuController {
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

- (void)setSelection:(int)sel;
/*
 *  Action Called Every Time someone Presses on Left Arrow
 */
-(void)leftActionForRow:(long)row;

/*
 *  Action Called Every Time someone Presses on Right Arrow
 */
-(void)rightActionForRow:(long)row;


@end
