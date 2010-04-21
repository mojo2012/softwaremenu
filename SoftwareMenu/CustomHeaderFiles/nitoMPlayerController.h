/*
 *  nitoMPlayerController.h
 *  SoftwareMenu
 *
 *  Created by Thomas Cool on 4/16/10.
 *  Copyright 2010 Thomas Cool. All rights reserved.
 *
 */

@interface nitoMPlayerController : BRController
{
    
}
-(id)initWithFile:(NSString *)path playbackType:(int)arg1 titleNumber:(int)arg2 isShuffled:(BOOL)arg3 withRepeat:(int)arg4;

@end