//
//  SoftwareSettings.h
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BackRow/BackRow.h>



@interface SoftwareUntrusted : BRMenuController 
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

-(void)writeToLog:(NSString *)strLog;
-(id)initWithIdentifier:(NSString *)initId withURL:(NSString *)initName;
-(BOOL)checkExists:(NSString *)thename;


// Data source methods:
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
@end