//
//  SoftwareManualInfo.h
//  SoftwareMenu
//
//  Created by Thomas on 11/15/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BackRow/BackRow.h>


@interface SoftwareManualInfo : BRMenuController {
	int padding[16];
	NSString *	identifier;
	NSString *	name;
	NSString *	path;
	NSString *	urlstr;
	NSString *	version;
	NSString * Type;
	
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	NSFileHandle   *	log;
	
}

//-(void)writeToLog:(NSString *)strLog;
-(id)initWithIdentifier:(NSString *)initId;
-(BOOL)checkExists:(NSString *)thename;


// Data source methods:
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;


@end
