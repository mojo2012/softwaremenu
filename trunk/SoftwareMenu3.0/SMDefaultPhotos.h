//
//  SMDefaultPhotos.h
//  SoftwareMenu
//
//  Created by Thomas on 4/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



/*@interface ATVDefaultPhotos
{
}

@end*/
@class BRIPhotoMediaCollection;


@interface SMDefaultPhotos : ATVDefaultPhotos {

}
+ (id)applePhotosForPath:(NSString *)thepath; //compat
+ (id)photosForPath:(NSString *)thepath;

@end
@interface SMDefaultPhotoCollection	: NSObject
{
	NSString *path;
}
-(id)initWithProvider:(id)provider dictionary:(NSDictionary *)dict path:(NSString *)thepath andPhotoConnection:(id)photoConnection;
- (void)setPath:(NSString *)thepath;
@end
@interface SMDefaultPhotosAsset : BRPhotoMediaAsset
- (id)dateTaken;
- (id)fullSizeArtID;
- (id)fullSizeArt;
- (id)description;

@end



