//
//  SMUpdaterOptions.h
//  SoftwareMenu
//
//  Created by Thomas on 3/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <BackRow.h>


@interface SMUpdaterOptionss : BRMediaMenuController {
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	int padding[32];
}
-(id)initCustom;
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
@end
