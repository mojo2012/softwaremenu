//
//  SMWeatherSettings.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/15/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
@interface SMFMediaMenuController : BRMediaMenuController 	
{
    int padding[64];
    
    NSMutableArray *	_items;
    NSMutableArray *	_options;
}

-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
-(int)getSelection;
-(id)everyLoad;
@end
@interface SMWeatherSettings : SMFMediaMenuController 	

@end