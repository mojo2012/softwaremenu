//
//  SoftwareFrappMover.h
//  SoftwareMenu
//
//  Created by Thomas on 2/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface SMFrappMover : SMFMediaMenuController 
{
    NSString *_selected;
}

-(id)initCustom;
-(NSArray *)frapOrderDict:(NSArray *)theFrapList;
-(NSArray *)frapEnumerator;


@end
