//
//  SMDefaultPhotos.h
//  SoftwareMenu
//
//  Created by Thomas on 4/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>


@interface SMDefaultPhotos : ATVDefaultPhotos {

}
+ (id)applePhotosForPath:(NSString *)thepath;

@end
@interface SMDefaultPhotoCollection	: BRIPhotoMediaCollection
{
	NSString *path;
}
@end
@interface SMDefaultPhotosAsset : BRBackupPhotoAsset
- (id)dateTaken;
- (id)fullSizeArtID;
- (id)fullSizeArt;
- (id)description;

@end



