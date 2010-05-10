/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class NSMutableArray;

@interface BRControllerStack : BRControl
{
    NSMutableArray *_stack;
    NSMutableArray *_transactions;
    NSMutableArray *_currentStackPath;
    BOOL _processingTransactions;
    BOOL _dumpStack;
}

- (id)init;
- (void)dealloc;
- (void)layoutSubcontrols;
- (void)pushController:(id)arg1;
- (void)popController;
- (void)popToController:(id)arg1;
- (void)popToControllerOfClass:(Class)arg1;
- (void)popToControllerWithLabel:(id)arg1;
- (void)removeController:(id)arg1;
- (void)swapController:(id)arg1;
- (void)replaceAllControllersWithController:(id)arg1;
- (void)replaceControllersAboveLabel:(id)arg1 withController:(id)arg2;
- (id)peekController;
- (id)rootController;
- (id)controllers;
- (id)controllersLabeled:(id)arg1;
- (id)controllersOfClass:(Class)arg1;
- (int)count;
- (BOOL)brEventAction:(id)arg1;
- (id)stackPathForController:(id)arg1;

@end
