//
//  SoftwareSettings.h
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
////#import <BackRow/BackRow.h>



@interface SoftwareSettings : BRMediaMenuController 
{
	int padding[16];
	NSString *	identifier;
	NSString *	name;
	NSString *	path;
	NSString *	urlstr;
	NSString *	version;
	
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	NSString	   *	_keypress;
	NSMutableDictionary *	_runoption;// = [NSMutableDictionary alloc] ;
	NSMutableDictionary *	_show_hide;
	NSFileHandle   *	log;
	
}

-(id)initWithIdentifier:(NSString *)initId;
-(int)getSelection;
-(long)getLongValue:(NSString *)jtwo;
-(void)modifyJ:(NSString *)changeValue;


// Data source methods:
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
@end