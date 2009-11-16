//
//  SMSubclasses.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/5/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

@class MEIPhotoMediaCollection;


@interface SMPhotoBrowserController : BRPhotoBrowserController 
{
    int		padding[32];
}
-(void)removeSButton;

@end

@interface SMPhotoCollectionProvider : BRPhotoDataStoreProvider
{
    int padding[32];
}
-(id)collection;
@end
@interface MEIPhotoMediaCollection
@end
@interface SMPhotoMediaCollection : BRPhotoMediaCollection
@end
@interface SMPhotoControlFactory : BRPhotoControlFactory
@end
