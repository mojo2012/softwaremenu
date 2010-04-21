/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRSingleton.h>

@class NSMutableArray;

@interface BRApplianceManager : BRSingleton
{
    NSMutableArray *_applianceList;
}

+ (id)singleton;
+ (void)setSingleton:(id)arg1;
+ (void)showMainMenu;
- (id)init;
- (void)dealloc;
- (void)loadAppliances;
- (id)applianceInfoList;
- (id)applianceForInfo:(id)arg1;
- (id)controllerForApplianceInfo:(id)arg1 identifier:(id)arg2 args:(id)arg3;
- (id)controllerForApplianceKey:(id)arg1 identifier:(id)arg2 args:(id)arg3;
- (id)controllerForContentAlias:(id)arg1;
- (BOOL)handleObjectSelection:(id)arg1 userInfo:(id)arg2;
- (BOOL)handlePlay:(id)arg1 userInfo:(id)arg2;

@end

