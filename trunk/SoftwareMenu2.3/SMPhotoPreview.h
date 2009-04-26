//
//  SMPhotoPreview.h
//  SoftwareMenu
//
//  Created by Thomas on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMMediaMenuController.h"

@interface SMPhotoPreview : SMMediaMenuController 	{
	NSString *	name;
	NSString *	path;
	
	NSMutableArray *	_paths;
	NSFileManager   *	_man;
	
}
+(id)firstPhotoForPath:(NSString *)thepath;
+(id)numberOfPhotosForPath:(NSString *)thepath;
+(NSDictionary *)numberOfInterestingFilesForPath:(NSString *)thepath;

-(id)initCustom;


// Data source methods:
- (void)setPath:(NSString *)thePath;
@end
