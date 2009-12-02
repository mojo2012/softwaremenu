//
//  SMUpdaterDownload.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 12/1/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMUpdaterDownload : SMDownloaderUpdate {
    NSString *          _version;
}
-(id)initWithFiles:(NSArray *)links withImage:(BRImage *)image withTitle:(NSString *)title withVersion:(NSString *)version;
@end
