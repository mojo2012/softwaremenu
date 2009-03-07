//
//  SMTweaks.h
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import <SMDownloaderSTD.h>


@interface SMTweaks : BRMediaMenuController {
	int padding[16];
	NSString *	identifier;
	NSString *	name;
	NSString *	path;
	NSString *	urlstr;
	NSString *	version;
	
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	NSString	   *	_keypress;
	NSMutableDictionary *	_infoDict;// = [NSMutableDictionary alloc] ;
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
@interface SMDownloaderTweaks : SMDownloaderSTD
{
}

-(void)processdownload;

@end




