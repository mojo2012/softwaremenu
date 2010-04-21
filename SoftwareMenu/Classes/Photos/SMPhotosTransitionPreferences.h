//
//  SMSlideShowTransitionPreferences.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/3/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SMPhotosTransitionPreferences : SMFMediaMenuController {
    BOOL _screensaver;
    NSArray *transitions;
}
//-(id)initCustom;
+(SMPhotosTransitionPreferences *)screensaverTransitionPreferences;
+(SMPhotosTransitionPreferences *)slideshowTransitionPreferences;
-(id)initForScreenSaver:(BOOL)val;
@end
@interface SMSlideShowPlaylistPreferences : SMPhotosTransitionPreferences
@end