//
//  SMDownloaderUpdate.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/30/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//




@interface SMDownloaderUpdate : SMController {
    int                         _current;
    BOOL                        _forceDestination;
    BOOL                        _checkMD5;
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
    NSDate          *           _startTime;
    BRTextControl *             _timeControl;
    NSDate          *           _lastUpdate;
}   
-(id)initWithFiles:(NSArray *)links withImage:(BRImage *)image withTitle:(NSString *)title;
-(void)setmd5Array:(NSArray *)md5Array;
-(BOOL)checkMD5;
-(void)setCheckMD5:(BOOL)checkMD5;
-(void)setForceDestination:(BOOL)force;
-(BOOL)forceDestination;
-(void)setTitle:(NSString *)title;
-(NSString *)title;
-(void)setImage:(BRImage *)image;
-(BRImage *)image;
-(void)setLinks:(NSArray *)links;
-(NSArray *)links;
-(void)layoutSubcontrols;
-(void)setBoxText:(NSString*)text;
-(void)setText:(NSString *)text;
-(void)appendBoxText:(NSString *)append;
@end
