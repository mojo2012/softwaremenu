//
//  SMFDelegatedDownloader.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/28/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMFDelegatedDownloader : SMFDownloaderUpdate {
    id _delegate;
}
-(void)setDelegate:(id)delegate;
-(id)delegate;
@end
