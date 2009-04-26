//
//  SMMediaMenuController.m
//  SoftwareMenu
//
//  Created by Thomas on 4/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMMediaMenuController.h"
#import "SMMedia.h"
#import "SMMediaPreview.h"


@implementation SMMediaMenuController
- (float)heightForRow:(long)row				{ return 0.0f;}
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row];}
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title];}
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title];}
- (long)defaultIndex						{ return 0;}
- (id)previewControlForItem:(long)row
{
	if(row>=[_items count])
		return nil;
	SMMedia *meta = [[SMMedia alloc] init];
	[meta setTitle:[[_items objectAtIndex:row] title]];
	[meta setDefaultImage];
	SMMediaPreview *preview = [[SMMediaPreview alloc] init];
	[preview setAsset:meta];
	return [preview autorelease];
}
- (void)dealloc
{
	[_items release];
	[_options release];
	[super dealloc];
}
-(int)getSelection
{
	BRListControl *list = [self list];
	int row;
	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(selection)];
	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
	[selInv setSelector:@selector(selection)];
	[selInv invokeWithTarget:list];
	if([signature methodReturnLength] == 8)
	{
		double retDoub = 0;
		[selInv getReturnValue:&retDoub];
		row = retDoub;
	}
	else
		[selInv getReturnValue:&row];
	return row;
}
@end
