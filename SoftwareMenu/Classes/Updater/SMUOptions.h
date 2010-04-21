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
//#import "SMFMediaMenuController.h"

@interface SMUpdaterOptions : SMFMediaMenuController{

	NSMutableArray			*	_optionDescriptions;
	NSMutableArray			*	_optionNames;
	NSMutableArray			*	_optionKeys;
	NSMutableArray			*	_nonBuiltinFraps;
	NSMutableDictionary		*	_theDefaults;
	NSMutableDictionary		*	_optionDict;
//    NSMutableArray          *   _newOptionKeys;
	
}
-(id)initCustom;
//-(int)getSelection;
-(NSMutableDictionary *)getOptions;


@end
