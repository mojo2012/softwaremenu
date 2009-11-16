//
//  SMPreviewControlReturns.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/5/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface SMImageReturns : NSObject {
}
+(NSArray *)imageProxiesForPath:(NSString *)path;
+(NSArray *)imageProxiesForPath:(NSString *)path nbImages:(long)nb;
+(NSArray *)mediaAssetsForPath:(id)path;
+(id)photoCollectionForPath:(NSString *)path;
+(id)dataStoreForPath:(NSString *)path;
+(id)dataStoreForAssets:(NSArray*)assets;
@end
