//
//  SMPhotoPreview.h
//  SoftwareMenuFramework
//
//  Created by Thomas on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface SMFPhotoPreview : SMFMediaMenuController 	{
	NSString *	name;
	NSString *	path;
	
	NSMutableArray *	_paths;
	NSFileManager   *	_man;
	
}
+(id)firstPhotoForPath:(NSString *)thepath;
+(id)numberOfPhotosForPath:(NSString *)thepath;
+(NSDictionary *)numberOfInterestingFilesForPath:(NSString *)thepath;
//-(id)initWithPath;
-(id)initCustom;


// Data source methods:
- (void)setPath:(NSString *)thePath;
@end
