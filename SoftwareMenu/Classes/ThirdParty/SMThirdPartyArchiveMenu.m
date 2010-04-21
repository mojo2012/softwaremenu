//
//  SMThirdPartyArchiveMenu.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/24/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMThirdPartyArchiveMenu.h"


@implementation SMThirdPartyArchiveMenu
-(id)init
{
    self=[super init];
    BRTextMenuItemLayer *item = [BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"About",@"About")];
    [_items addObject:item];
    
    item=[BRTextMenuItemLayer folderMenuItem];
    [item setTitle:BRLocalizedString(@"Archives",@"Archives")];
    [_items addObject:item];
    [self setListTitle:BRLocalizedString(@"Archive Manager",@"Archive Manager")];
    return self;
}
@end
