//
//  SMDefaultPhotos.m
//  SoftwareMenu
//
//  Created by Thomas on 4/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMDefaultPhotos.h"


@implementation SMDefaultPhotos
+ (id)applePhotosForPath:(NSString *)thepath
{
	return [SMDefaultPhotos photosForPath:thepath];
}
+ (id)applePhotosCollection
{
	return [[SMDefaultPhotos alloc] init];
}
+ (id)photosForPath:(NSString *)thepath
{
	NSArray *coverArtExtention = [[NSArray alloc] initWithObjects:
								  @"jpg",
								  @"JPG",
								  @"jpeg",
								  @"tif",
								  @"tiff",
								  @"png",
								  @"gif",
								  nil];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
	NSMutableArray *photos =[NSMutableArray arrayWithObjects:nil];
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
		{
			Class cls = NSClassFromString( @"BRPhotoMediaAsset" );
			id asset = [[cls alloc] init];
			//NSLog(@"%@",[thepath stringByAppendingPathComponent:idStr]);
			[asset setFullURL:[thepath stringByAppendingPathComponent:idStr]];
			[asset setThumbURL:[thepath stringByAppendingPathComponent:idStr]];
			[asset setCoverArtURL:[thepath stringByAppendingPathComponent:idStr]];
			//[asset setDateTaken:[NSDate dateWithString:@"2009-04-04T22:02:28Z"]];
			[asset setIsLocal:YES];
			[photos addObject:asset];
            NSLog(@"path: %@",[thepath stringByAppendingPathComponent:idStr]);
		}
		else 
		{
			//NSLog(@"idStr not added: %@",idStr);
		}
		
	}
	return (NSArray *)photos;
}
- (id)mediaAssets
{
    //NSMutableArray *a = [super mediaAssets];
    //NSArray *b= [NSArray arrayWithObject:[a objectAtIndex:0]];
    NSArray *hello = [SMDefaultPhotos photosForPath:@"/Users/frontrow/Pictures/"];//[SMGeneralMethods stringForKey:@"PhotoDirectory"]];
	return hello;//[hello autorelease];
}
@end

@implementation SMDefaultPhotoCollection
-(id)initWithProvider:(id)provider dictionary:(NSDictionary *)dict path:(NSString *)thepath andPhotoConnection:(id)photoConnection
{
	[self setPath:thepath];
	return @"";//[self initWithProvider:provider dictionary:dict andPhotoConnection:photoConnection];
}

- (id)collectionID
{
	return @"3178";
}

- (id)mediaAssets
{
	return [SMDefaultPhotos applePhotosForPath:path];
}
- (void)setPath:(NSString *)thepath
{
	[path release];
	path = thepath;
	[path retain];
}
- (id)displayName
{
	return @"Tom";
}
- (id)title
{
	return [path lastPathComponent];
}
- (int)numberOfPhotos
{
	return [[SMDefaultPhotos applePhotosForPath:path] count];
}
@end
@implementation  SMDefaultPhotosAsset 
-(id) dateTaken
{
	return [NSDate dateWithString:@"2009-04-04T22:02:28Z"];
}
- (id)fullSizeArtID
{
	return [self coverArtID];
}
-(id)fullSizeArt
{
	return [self coverArt];
}
-(id)title
{
	return @"Tom";
}
-(id)description
{
	NSLog(@"description");
	return @"";
}

/*- (id)assetID;
{
	NSLog(@"assetID");
	return @"tom";
}*/
- (id)thumbnailArtID;
{
	NSLog(@"thumbID");
	return [self coverArtID];
}
- (BOOL)hasCoverArt
{
	return YES;
}
- (id)thumbnailArt;
{
	NSLog(@"thumbnail");
	return [self coverArt];
}

@end