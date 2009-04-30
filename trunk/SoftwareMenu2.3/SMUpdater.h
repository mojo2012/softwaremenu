//
//  SMUpdater.h
//  SoftwareMenu
//

//  Created by Thomas on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMMediaMenuController.h"
@interface SMUpdater : SMMediaMenuController {
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
-(NSMutableDictionary *)getOptions;



@end
