/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRMediaMenuController.h"

#import "BRTextFieldDelegate-Protocol.h"

@class ATVFlickrProvider, ATVFlickrSearchAgent, NSString;

@interface ATVFlickrMainMenuController : BRMediaMenuController <BRTextFieldDelegate>
{
    BOOL _isScreenSaverMenu;
    ATVFlickrSearchAgent *_searchAgent;
    BOOL _searching;
    NSString *_activeSearchTerm;
    ATVFlickrProvider *_persistentAccountProvider;
}

+ (id)menuController;
+ (id)screenSaverMenuController;
- (id)init;
- (id)initForScreenSaver:(BOOL)arg1;
- (void)dealloc;
- (long)defaultIndex;
- (void)textDidChange:(id)arg1;
- (void)textDidEndEditing:(id)arg1;
- (BOOL)isNetworkDependent;

@end

