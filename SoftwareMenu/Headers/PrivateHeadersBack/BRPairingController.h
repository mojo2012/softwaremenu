/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRController.h>

@class BRHeaderControl, BRPairingPinControl, BRTextControl, NSString;

@interface BRPairingController : BRController
{
    BRHeaderControl *_header;
    BRPairingPinControl *_pinControl;
    BRTextControl *_requirementText;
    NSString *_pin;
    NSString *_startNotificationName;
    NSString *_stopNotificationName;
    BOOL _pairingHappenedWhileBuried;
}

+ (id)iTunesPairingControllerForInitialSync;
+ (id)iTunesPairingControllerForSync;
+ (id)iTunesPairingControllerForChangingSyncHost;
+ (id)iTunesPairingControllerForStreaming;
- (void)dealloc;
- (void)wasPushed;
- (void)wasPopped;
- (void)wasExhumed;
- (BOOL)brEventAction:(id)arg1;
- (void)layoutSubcontrols;

@end

