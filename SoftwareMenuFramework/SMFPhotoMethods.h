//
//  SMFPhotoMethods.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/25/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface SMFPhotoMethods : NSObject {

}
+(NSArray *)mediaAssetsForPath:(id)path;
+(NSArray *)photoPathsForPath:(id)path;
+(NSArray *)imageProxiesForPath:(NSString *)path;
+(NSMutableArray *)loadImagePathsForPath:(NSString *)path;
+(id)firstPhotoForPath:(NSString *)path;
+(id)photoCollectionForPath:(NSString *)path;
+(BRDataStore *)dataStoreForAssets:(NSArray *)assets;
+(BRDataStore *)dataStoreForPath:(NSString *)path;
+(NSArray *)imageProxiesForPath:(NSString *)path nbImages:(long)nb;
@end

/*
 *  Convenience Collection Method for Photos (does most of the work)
 */
@interface SMFPhotoMediaCollection : BRPhotoMediaCollection
@end

@interface SMFPhotoControlFactory : BRPhotoControlFactory
{
    BOOL _mainmenu;
}
@end

@interface SMFPhotoCollectionProvider : BRPhotoDataStoreProvider
{
    int padding[32];
}
@end