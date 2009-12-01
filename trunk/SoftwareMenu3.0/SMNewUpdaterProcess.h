//
//  SMNewUpdaterProcess.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/22/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMNewUpdaterProcess : BRController {
    int		padding[16];
    BRHeaderControl *       _header;
    BRScrollingTextBoxControl *         _sourceText;
	BRImageControl *		_sourceImage;
    SMProgressBarControl *  _progressBar;
	BRTextControl *			_step;
    NSURLDownload *         _downloader;
	BRWaitSpinnerControl *	_spinner;
    NSString *              _outputPath;
    long long               _totalLength;
    long long               _gotLength;
	NSMutableString *				_theSourceText;
	NSString *				_downloadURL;
	NSString *				_downloadTitle;
	NSString *				_downloadText;
	NSDictionary *			_updateData;
	NSString *				_previousText;
	int m_screen_saver_timeout;
}
-(void)processFiles;


- (id) init;

- (int)makeASRscan:(NSString *)drivepath;

// stack callbacks
- (BOOL) isNetworkDependent;
- (id)initCustom;
- (void)moveFiles2:(BOOL)original_status;
- (void)setUpdateData:(NSDictionary *)updatedata;
- (BOOL)returnBoolValue:(NSString *)thevalue;


- (void) setNumber:(int)step withSteps:(int)numberOfSteps;
- (void) setTitle: (NSString *) title;
- (NSString *) title;
- (void) setSourceImage:(NSString *)name;
- (id) sourceImage;
- (void) setSourceText: (NSMutableString *) text;
- (NSString *) sourceText;
- (NSMutableDictionary *)getOptions;
- (void) setTheText:(NSMutableString *)srcText;
- (void) cleanstuff;
- (void) appendSourceText:(NSString *)srcText;
- (void) appendSourceTextSpace:(NSString *)srcText;
- (void) startDownloadingURL;
@end
