//
//  SMNewUpdaterProcess.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/22/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMNewUpdaterProcess : SMController {

    NSString *                  _folder;
    NSString *                  _version;
    NSMutableArray *                   _textControls;
    NSArray *                   _md5Array;
    NSArray *                   _files;
    NSString *                  _title;
    BRImage *                   _image;
    BRHeaderControl *           _headerControl;
    BRScrollingTextControl *    _textBox;
    BRTextControl *             _textControl;
	BRImageControl *            _imageControl;
    SMProgressBarControl *      _progressBar;
    NSMutableString *			_boxText;
    NSURLDownload   *           _downloader;
    long long                   _totalLength;
    long long                   _gotLength;
    NSString        *           _outputPath;
    NSMutableArray  *           _outputPaths;
    BRImageControl  *           _arrowControl;
    BRWaitSpinnerControl *      _spinner;

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
