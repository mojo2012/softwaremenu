//
//  SMFolderBrowser.h
//  SoftwareMenuFramework
//
//  Created by Thomas on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



@interface SMFFolderBrowser : SMFMediaMenuController 
	{

		NSString *	path;
		NSMutableArray *	_paths;
		NSFileManager   *	_man;
		
	}
-(id)initCustom;
-(void)setPath:(NSString *)thePath;
@end
