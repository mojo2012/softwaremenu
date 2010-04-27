//
//  SMFSpinnerMenu.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/27/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMFSpinnerMenu.h"


@implementation SMFSpinnerMenu

-(void)textDidChange:(NSString *)string
{
//    if (_ctrl ==nil) {
//        _ctrl = [[BRAutoScrollingTextControl alloc] init];
//        //NSAttributedString *str = [[NSAttributedString alloc] initWithString:string attributes:[[SMFThemeInfo sharedTheme]leftJustifiedTitleTextAttributess]];
//        [_ctrl setText:string withAttributes:[[BRThemeInfo sharedTheme]metadataTitleAttributes]];
//        CGSize max=[BRWindow maxBounds];
//        
//        CGRect frame = CGRectMake(max.width*0.05f, max.height*0.05f, max.width*0.9f, max.height*0.3f);
//        [_ctrl setFrame:frame];
//        [self addControl:_ctrl];
//    }
//    else {
//        NSLog(@"oldstring: %@",[_ctrl attributedString]);
//        //[_ctrl setText:[[[_ctrl text] string] stringByAppendingString:string] ];
//    }
//    NSLog(@"%@",[[[[self controls] objectAtIndex:0]controls] objectAtIndex:0]);
//
//
//    NSLog(@"pt changed string: %@",string);
}
-(void)textDidEndEditing:(NSString *)string
{
    [[self stack] popController];
}
@end
