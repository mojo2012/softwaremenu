/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRController.h>

@class BRMainMenuControl;

@interface BRMainMenuController : BRController
{
    BRMainMenuControl *_browser;
    BOOL _enabled;
    BOOL _handlingMainMenuEvent;
}

+ (void)highlightApplianceWithKey:(id)arg1 andCategoryWithIdentifier:(id)arg2;
+ (BOOL)handlingMainMenuEvent;
+ (void)setHandlingMainMenuEvent:(BOOL)arg1;
- (id)init;
- (void)dealloc;
- (BOOL)canBeRemovedFromStack;
- (void)enable;
- (void)reloadMainMenu;
- (void)clearRemembery;

@end

