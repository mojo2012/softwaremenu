//
//  SMNewUpdaterProcess.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/22/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMNewUpdaterProcess : SMFController {

    NSString *                  _folder;
    NSString *                  _version;
    NSMutableArray *            _textControls;
    NSArray *                   _md5Array;
    NSArray *                   _files;
//    NSString *                  _title;
//    BRImage *                   _image;
//    BRHeaderControl *           _headerControl;
    BRScrollingTextControl *    _textBox;
    BRTextControl *             _textControl;
//	BRImageControl *            _imageControl;
    SMFProgressBarControl *      _progressBar;
    NSMutableString *			_boxText;
    NSURLDownload   *           _downloader;
    long long                   _totalLength;
    long long                   _gotLength;
    NSString        *           _outputPath;
    NSMutableArray  *           _outputPaths;
    BRImageControl  *           _arrowControl;
 //   BRWaitSpinnerControl *      _spinner;

}


-(id)initForFolder:(NSString *)folder withVersion:(NSString *)Version;
- (int)makeASRscan:(NSString *)drivepath;

// stack callbacks
- (void)moveFiles2:(BOOL)original_status;




- (NSMutableDictionary *)getOptions;
- (void) cleanstuff;
- (void) startDownloadingURL;
@end
