//
//  BRDescriptionOverlayControl-SMExt.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/16/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "BRDescriptionOverlayControl-SMExt.h"


@implementation BRDescriptionOverlayControl (SMExtensions)
-(id)title
{
    //_title = [[NSAttributedString alloc]initWithString:@"Hello"];
    _title = [@"Hello" retain];
    return _title;
}
-(id)description;
{
    _description=[@"Hello" retain];
    return _description;
}
-(id)player
{
    return _player;
}
@end
