//
//  SMFolderBrowser.h
//  SoftwareMenu
//
//  Created by Thomas on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



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
