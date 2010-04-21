/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject-Protocol.h"

@protocol BRFocusContainer <NSObject>
- (id)focusCandidates;
- (struct CGPoint)positionForFocusCandidate:(id)arg1;
- (struct CGSize)boundsForFocusCandidate:(id)arg1;
- (BOOL)eligibilityForFocusCandidate:(id)arg1;
- (id)debugDescriptionForFocusCandidate:(id)arg1;
@end

