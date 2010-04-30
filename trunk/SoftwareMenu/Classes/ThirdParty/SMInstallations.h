//
//  SMInstallations.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/28/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef enum _SMInstall{
    SMInstallCheck  =-1,
    SMInstallNone   = 0,
    SMInstallPerian = 1,
    SMInstallPython = 2,
}SMInstall;

@interface SMInstallations : SMFMediaMenuController {
    SMInstall currentInstall;
}
-(void)downloadDidComplete:(NSArray *)files object:(SMFDelegatedDownloader *)cont;
-(NSXMLDocument *)fetchURL:(NSString *)urlString;
@end
