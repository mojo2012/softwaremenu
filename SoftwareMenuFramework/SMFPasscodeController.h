//
//  QuDownloadController.h
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

#import <Foundation/Foundation.h>
//#import <BackRow/BRController.h>
#import <CoreData/CoreData.h>
#define DESCRIPTION_KEY			@"description"
#define TITLE_KEY				@"title"
#define NUMBER_BOXES_KEY		@"numberOfBoxes"
#define KEY_KEY					@"key"
#define DOMAIN_KEY              @"domain"
#define DEFAULT_KEY				@"defaults"
@class BRHeaderControl, BRTextControl,BRScrollingTextControl, BRImageControl, BRPasscodeEntryControl, BRDisplayManager;

@interface SMFPasscodeController : BRController
{
	int							padding[16];
	NSMutableDictionary *		_passData;
	BRPasscodeEntryControl *	_entryControl;
	BRHeaderControl *			_header;
	BRTextControl *				_firstText;
	BRImage				*		_image;
    NSString        *           _domain;
    id                          _delegate;
}
- (id)initWithTitle:(NSString *)title withDescription:(NSString *)description withBoxes:(int)boxes withKey:(NSString *)key withDomain:(NSString *)domain;
- (id)initWithTitle:(NSString *)title withDescription:(NSString *)description withBoxes:(int)boxes withKey:(NSString *)key;
+ (SMFPasscodeController *)passcodeWithTitle:(NSString *)title withDescription:(NSString *)description withBoxes:(int)boxes withDelegate:(id)delegate;
//- (id)initWithTitle:(NSString *)title withDescription:(NSString *)description withBoxes:(int)boxes withKey:(NSString *)key withDefaultValue:(int)value;
- (CGSize)sizeFor1080i;
- (void)setDescription:(NSString *)description;
- (void)setTitle:(NSString *)title;
- (void)setNumberOfBoxes:(int)boxes;
- (void)setKey:(NSString *)key;
- (void)setBRImage:(BRImage *)image;
- (void)setWriteToDefault:(BOOL)defaults;
- (void)setInitialValue:(int)value;
- (BOOL)is1080i;
- (void)setDelegate:(id)delegate;
- (void) textDidChange: (id) sender;
- (void) textDidEndEditing: (id) sender;
- (NSString *)getTitle;
- (NSString *)getKey;
- (BOOL)defaults;
- (int)getNumberOfBoxes;
- (NSString *)getDescription;
-(NSString *)getChangePath;
- (void)setChangeOrder:(NSString *)path;
+ (int)latestSavedValue;

-(id) init;
-(void) drawSelf;

@end

