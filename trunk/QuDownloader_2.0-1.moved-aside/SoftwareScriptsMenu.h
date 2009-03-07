//
//  SoftwareScriptsMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <BackRow/BackRow.h>


@interface SodtwareScriptsMenu : BRMenuController 
{
	int padding[16];
	NSString *	identifier;
	NSString *	name;
	NSString *	path;
	NSString *	urlstr;
	NSString *	version;
	
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	NSFileHandle   *	log;
	
}

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
