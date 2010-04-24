//
//  SMMainMenuController.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//




@implementation SMMainMenuController
-(id)init
{
    self=[super init];
    NSLog(@"init awesome");
    NSLog(@"self controls: %@",[self controls]);
    return self;
}
//-(void)reloadMainMenu
//{
//    [super reloadMainMenu];
//
////    NSLog(@"control controls: %@",[obj controls]);
//}


-(void)reloadMainMenu
{
    [super reloadMainMenu];
    
//    id handler = [_browser selectionHandler];
    CGRect frame=[_browser frame];
    
    //Release original Control (we have to be nice)
    if (_browser!=nil) {
        [_browser removeFromParent];
    }
    [_browser autorelease];
    
    //Create our own Control
    SMMainMenuControl * control =[[SMMainMenuControl alloc]init];
    _browser=[control retain];
    [_browser setAcceptsFocus:YES];
    [_browser setAutoresizingMask:0];
    
    //Insert it in controls array
    NSArray *controls=[NSArray arrayWithObject:control];
    [self setControls:controls];
    
    //Set the selection Handler so it know what to do when item is selected
    BRInvocationSelectionHandler * selHandler = [BRInvocationSelectionHandler handlerWithTarget:self   selector:@selector(_browserItemSelected:)];
    
    [control setSelectionHandler:selHandler];
    frame.size=[BRWindow maxBounds];
    [control setFrame:frame];
}
-(BOOL)handleSelectionForControl:(id)arg1
{
    [self _browserItemSelected:arg1];
    return YES;
}
-(BOOL)SMMainMenu
{
    return YES;
}
@end
