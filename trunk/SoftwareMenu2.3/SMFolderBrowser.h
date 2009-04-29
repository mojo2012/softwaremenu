//
//  SMFolderBrowser.h
//  SoftwareMenu
//
//  Created by Thomas on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMMediaMenuController.h"

@interface SMFolderBrowser : SMMediaMenuController 
	{

		NSString *	path;
		NSMutableArray *	_paths;
		NSFileManager   *	_man;
		
	}
-(id)initCustom;
-(BOOL)usingTakeTwoDotThree;	
-(void)setPath:(NSString *)thePath;
@end
