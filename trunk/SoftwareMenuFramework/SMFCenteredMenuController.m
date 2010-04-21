//
//  SMFCenteredMediaMenuController.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/25/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//



@implementation SMFCenteredMenuController
- (float)heightForRow:(long)row				{ return 0.0f;}
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row];}
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title];}
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title];}
- (long)defaultIndex						{ return 0;}
//- (id)previewControlForItem:(long)row
//{
////    BRImage * image = [[BRThemeInfo sharedTheme] appleTVIcon];
////    BRImageAndSyncingPreviewController *preview = [[BRImageAndSyncingPreviewController alloc] init];
////    [preview setImage:image];
////	return preview;
//    return nil;
//}
- (id)init
{
    self=[super init];
    _items = [[NSMutableArray alloc]init];
    _options = [[NSMutableArray alloc] init];
    [[self list] setDatasource:self];
     [self setUseCenteredLayout:YES];
     return self;
}
- (void)dealloc
{
	[_items release];
	[_options release];
	[super dealloc];
}
-(id)everyLoad
{
    return self;
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
-(void)controlWasActivated
{
    if([self respondsToSelector:@selector(everyLoad)])
        [self everyLoad];
    [super controlWasActivated];
}
- (void)wasExhumedByPoppingController:(id)fp8	{[self wasExhumed];}
-(void)wasExhumed								{[[self list] reload];}
//-(id)init
//{
//    self=[super init];
//    [self setUseCenteredLayout:YES];
//    return self;
//}
@end
