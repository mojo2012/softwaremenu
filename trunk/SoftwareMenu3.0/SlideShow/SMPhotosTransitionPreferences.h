//
//  SMSlideShowTransitionPreferences.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/3/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SMPhotosTransitionPreferences : SMMediaMenuController {
    NSArray *transitions;
}
-(id)initCustom;
@end
@interface SMSlideShowPlaylistPreferences : SMPhotosTransitionPreferences
@end