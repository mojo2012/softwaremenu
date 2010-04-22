/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRSingleton.h>

@class NSDictionary;

@interface BRFontCache : BRSingleton
{
    struct CGSize _displaySize;
    NSDictionary *_cache;
}

+ (id)singleton;
+ (void)setSingleton:(id)arg1;
- (id)init;
- (void)dealloc;
- (id)addRealFontsToAttributedString:(id)arg1;
- (struct __CTFont *)createFontForRowHeight:(float)arg1 fontName:(id)arg2;
- (void)setDisplaySize:(struct CGSize)arg1;

@end
