/*
 *  SMSapphireHeaders.h
 *  SoftwareMenu
 *
 *  Created by Thomas Cool on 4/10/10.
 *  Copyright 2010 Thomas Cool. All rights reserved.
 *
 */
@interface SapphireApplianceController : BRBaseAppliance
+ (NSManagedObjectContext *)newManagedObjectContextForFile:(NSString *)storeFile withOptions:(NSDictionary *)storeOptions;
@end

#import "SapphireDirectoryMetaData.h"
#import "SapphireFileMetaData.h"
#import "SapphireDirectory.h"
#import "SapphireMovieDirectory.h"
#import "SapphireMedia.h"
#import "SapphireVideoPlayer.h"
#import "SapphireVideoPlayerController.h"
#import "SapphireEntityDirectory.h"
#import "SapphireTVDirectory.h"

#import "nitoMPlayerController.h"
