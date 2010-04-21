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
-(NSArray *)controls
{
    NSLog(@"calling controls from awesome menu");
    return [super controls];
}
//-(void)controlWasActivated
//{
//    BOOL parade=TRUE;
//    BOOL still=FALSE;
//    BOOL player=FALSE;
//    
//    NSLog(@"controls in activated: %@",[_browser controls]);
//    CGRect a= [[[[BRApplicationStackManager singleton]stack] rootController] frame];
//    id obj = [[self controls] objectAtIndex:0];
//    [obj _reload];
//    if (parade) {
//        //Media Parade
//        id  control = [[BRMediaParadeControl alloc] init];
//        id proxies = [SMImageReturns imageProxiesForPath:[SMPreferences photoFolderPath]];
//        [control setImageProxies:proxies];
//        [control setFrame:a];
//        [control setOpacity:0.3];
//        [obj insertControl:control atIndex:1];
//    }
//    else if(still)
//    {
//        //Still Image
//        id control = [[BRImageControl alloc]init];
//        [control setImage:[SMPhotoPreview firstPhotoForPath:[SMPreferences photoFolderPath]]];
//        [control setFrame:a];
//        [control setOpacity:0.4];
//        [obj insertControl:control atIndex:1];
//    }
//    else if(player)
//    {
//        //media player
//    }
//
//    
//    //changing Logo
//    id image=[[BRImageControl alloc] init];
//    a=[self frame];
//    a.origin.x=a.origin.x+a.size.width*0.82;
//    a.origin.y=a.origin.y+a.size.height*0.03;
//    a.size.width=a.size.width*0.13;
//    a.size.height=a.size.height*0.22;
//    [image setImage:[[SMThemeInfo sharedTheme] softwareMenuImage]];
//    [image setFrame:a];
//    [obj insertControl:image atIndex:6];
//    
//    
//    
//    [[[obj controls] objectAtIndex:0] removeFromParent];
//    
//    CGRect  frame=[[[obj controls] objectAtIndex:4]frame];
//    NSLog(@"frame of obj: %@, %lf, %lf",[[obj controls] objectAtIndex:4],frame.size.width,frame.size.height);
//    NSLog(@"controls in activated2: %@",[_browser controls]);
//
//    [obj layoutSubcontrols];
//    [super controlWasActivated];
//    [obj controlWasActivated];
//    //[obj layoutSubcontrols];
//     
//}
-(void)reloadMainMenu
{
    [super reloadMainMenu];
    
    id handler = [_browser selectionHandler];
    CGRect frame=[_browser frame];
    NSLog(@"handler: %@ %lf, %lf" ,handler,frame.size.width,frame.size.height);
    if (_browser!=nil) {
        [_browser removeFromParent];
    }
    [_browser autorelease];
    NSLog(@"browser controls: %@",[_browser controls]);
    SMMainMenuControl * a =[[SMMainMenuControl alloc]init];
    _browser=[a retain];
    [_browser setAcceptsFocus:YES];
    [_browser setAutoresizingMask:0];
    NSArray *controls=[NSArray arrayWithObject:a];
    [self setControls:controls];
//    SEL theSelector;
//    NSMethodSignature *aSignature;
//    //theSelector = NSSelectorFromString(selectorString);
//    aSignature = [[self class] instanceMethodSignatureForSelector:@selector(_browserItemSelected:)];
//    //id b =[BRInvocationSelectionHandler 
    id b = [BRInvocationSelectionHandler handlerWithTarget:self   selector:@selector(_browserItemSelected:)];
    [a setSelectionHandler:b];
    //[a setSelectionHandler:self];
    frame.size=[BRWindow maxBounds];
    [a setFrame:frame];
}
-(BOOL)handleSelectionForControl:(id)arg1
{
    [self _browserItemSelected:arg1];
    return YES;
}
@end
