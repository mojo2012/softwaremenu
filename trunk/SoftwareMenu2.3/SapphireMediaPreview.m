/*
 * SapphireMediaPreview.m
 * Sapphire
 *
 * Created by Graham Booker on Jun. 26, 2007.
 * Copyright 2007 Sapphire Development Team and/or www.nanopi.net
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify it under the terms of the GNU
 * General Public License as published by the Free Software Foundation; either version 3 of the License,
 * or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
 * the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
 * Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with this program; if not,
 * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

#import "SMMMediaPreview.h"
#import "SMMedia.h"
#import <objc/objc-class.h>

/*These interfaces are to access variables not available*/
@interface BRMetadataControl (protectedAccess)
- (NSArray *)gimmieMetadataObjs;
@end

@implementation BRMetadataControl (protectedAccess)
- (NSArray *)gimmieMetadataObjs
{
	Class myClass = [self class];
	Ivar ret = class_getInstanceVariable(myClass,"_metadataLabels");
	
	return *(NSArray * *)(((char *)self)+ret->ivar_offset);
}
@end

/* There is no BRMetadataLayer class in ATV2.0 anymore, it seems to be BRMetadataControl now*/
/* So just do the same stuff as above, but for BRMetadataControl*/
/*@interface BRMetadataControl : NSObject
@end*/




@interface BRMetadataPreviewController (compat)
- (void)_updateMetadataLayer;
@end

@interface BRMetadataPreviewController (protectedAccess)
- (BRMetadataControl *)gimmieMetadataLayer;
@end

@implementation BRMetadataPreviewController (protectedAccess)
- (BRMetadataControl *)gimmieMetadataLayer
{
	Class myClass = [self class];
	Ivar ret = class_getInstanceVariable(myClass,"_metadataLayer");
	
	return *(BRMetadataControl * *)(((char *)self)+ret->ivar_offset);
}
@end

@interface SMMMediaPreview (private)
- (void)doPopulation;
- (NSString *)coverArtForPath;
@end

@implementation SMMMediaPreview

/*List of extensions to look for cover art*/
static NSSet *coverArtExtentions = nil;

+ (void)initialize
{
	/*Initialize the set of cover art extensions*/
	coverArtExtentions = [[NSSet alloc] initWithObjects:
		@"jpg",
		@"jpeg",
		@"tif",
		@"tiff",
		@"png",
		@"gif",
		nil];
}

- (id)init
{
		return [super init];
}

- (void)dealloc
{
	[super dealloc];
}

- (void)setUtilityData:(NSMutableDictionary *)newMeta
{
	SMMedia *asset  =[SMMedia alloc];
	[asset setImagePath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DefaultPreview" ofType:@"png"]];
	[self setAsset:asset];

}


/*!
 * @brief Search for cover art for the current metadata
 *
 * @return The path to the found cover art
 */

/*!
 * @brief Override the loading of the cover art method
 */
- (void)_loadCoverArt
{
	[super _loadCoverArt];
	
	/*See if it loaded something*/
	if([_coverArtLayer texture] != nil)
		return;
	
	/*Get our cover art*/
	NSString *path = [self coverArtForPath];
	NSURL *url = [NSURL fileURLWithPath:path];
	/*Create an image source*/;
    CGImageSourceRef  sourceRef;
	CGImageRef        imageRef = NULL;
	sourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
	if(sourceRef) {
        imageRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
        CFRelease(sourceRef);
    }
	if(imageRef)
	{
		[_coverArtLayer setImage:imageRef];
		CFRelease(imageRef);
	}	
}

/*!
 * @brief populate metadata for TV Shows
 */
- (void)populateUtilityDataWith:(NSMutableDictionary *)allMeta
{
	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
	/* Get the setting name */
	NSString *value = @"hello";
	if(value != nil)
		[metaLayer setTitle:value];
	/*Get the setting description*/
	value = @"hello";
	if(value != nil)
			[metaLayer setSummary:value];
}

/*!
 * @brief populate generic file data
 */

/*!
 * @brief populate metadata for media files
 */
- (void)_populateMetadata
{
	[super _populateMetadata];
	[self doPopulation];
}

/*!
 * @brief populate metadata for media files
 */
- (void)_updateMetadataLayer
{
	[super _updateMetadataLayer];
	/*See if it loaded anything*/
	[self doPopulation];
}

- (void)doPopulation
{
	/*Get our data then*/
	NSArray *order = nil;
	NSMutableDictionary *allMeta = nil;
	//FileClass fileClass=FILE_CLASS_UNKNOWN ;

	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
	
	/* TV Show Preview Handeling */
	/* Utility Preview Handeling */

		[self populateUtilityDataWith:(NSMutableDictionary *)allMeta];
}

/*!
 * @brief Override the info about whether it has metadata
 *
 * @return We always have metadata
 */
- (BOOL)_assetHasMetadata
{
	return YES;
}

@end
