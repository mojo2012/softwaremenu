//
//  SoftwareFrappMover.h
//  SoftwareMenu
//
//  Created by Thomas on 2/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <BackRow/BackRow.h>
#import <Cocoa/Cocoa.h>

@interface SMFrappMover : BRMediaMenuController 
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
	NSFileHandle   *	log;
	
}

-(void)writeToLog:(NSString *)strLog;
-(id)initWithIdentifier:(NSString *)initId;
-(BOOL)checkExists:(NSString *)thename;
-(NSArray *)frapOrderDict:(NSArray *)theFrapList;
-(NSArray *)frapEnumerator;


// Data source methods:
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
@end
