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

@interface SMUpdater : BRCenteredMenuController {
	int padding[16];
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	NSMutableArray *	_dlinks;
	NSMutableArray *	_dlinks2;
	NSMutableArray *	_md5s;
	NSString	   *	_displays;
	int					_downloadnumber;
	NSMutableArray *	_builtinfraps;

}
-(int)getValueMinusOne;
-(void)moveFiles;
-(void)patchOSdmg;
-(BOOL)checkmd5:(NSString *)path withmd5:(NSString *)md5;
-(void)start_updating:(NSString *)xml_location;
-(void)downloadthemalready;
-(id)initCustom;
-(int)getSelection;
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;


@end
