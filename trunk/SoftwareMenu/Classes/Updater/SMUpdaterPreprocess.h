//
//  SMUpdaterPreprocess.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 12/1/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//



@interface SMUpdaterPreprocess : SMFController {
//    BRWaitSpinnerControl *_spinner;
//    BRHeaderControl *_headerControl;
//    NSString *_title;
    NSDictionary *_infoDictionary;
    NSString *_version;
    NSMutableArray *_textControls;
    BRImageControl *_arrowControl;
//    BRImage *                   _image;
//    BRImageControl *            _imageControl;
}
-(void)SMLayoutSubcontrols;
-(id)initWithForVersionDictionary:(NSDictionary *)versionDict forVersion:(NSString *)version;
-(BOOL)checkmd5ForFile:(NSString *)path withExpectedmd5:(NSString *)md5;
-(BOOL)checkmd5ForURL:(NSString *)url withExpectedmd5:(NSString *)md5;
-(NSMutableArray *)getURLs;
-(NSMutableArray *)getMD5s;
-(void)addText:(NSString *)text;
-(void)setArrowForRect:(CGRect)frame;
@end
