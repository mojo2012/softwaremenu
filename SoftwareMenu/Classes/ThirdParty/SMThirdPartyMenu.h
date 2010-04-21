//
//  SoftwareMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//



@interface SMThirdPartyMenu : SMFMediaMenuController 
{
	NSMutableDictionary *	tempFrapsInfo;
	NSMutableDictionary *	tempFrapsInfo2;
    NSMutableArray      *   _itemsFraps;
    NSMutableArray      *   _optionsFraps;
	NSMutableArray * istrusted;
	NSFileManager *		_man;
	
	
}
-(void)updateFrapItems;



@end
