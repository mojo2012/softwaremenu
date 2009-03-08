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

#import "SapphireMediaPreview.h"
#import "SapphireMedia.h"
#import "SapphireSettings.h"
#import <objc/objc-class.h>
#import <SapphireCompatClasses/SapphireFrontRowCompat.h>

/*These interfaces are to access variables not available*/
@interface BRMetadataLayer (protectedAccess)
- (NSArray *)gimmieMetadataObjs;
@end

@implementation BRMetadataLayer (protectedAccess)
- (NSArray *)gimmieMetadataObjs
{
	Class myClass = [self class];
	Ivar ret = class_getInstanceVariable(myClass,"_metadataLabels");
	
	return *(NSArray * *)(((char *)self)+ret->ivar_offset);
}
@end

/* There is no BRMetadataLayer class in ATV2.0 anymore, it seems to be BRMetadataControl now*/
/* So just do the same stuff as above, but for BRMetadataControl*/
@interface BRMetadataControl : NSObject
@end

@implementation BRMetadataControl (protectedAccess)
	-(NSArray *)gimmieMetadataObjs {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_metadataObjs");
	return *(NSArray * *)(((char *)self)+ret->ivar_offset);
}
@end


@interface BRMetadataPreviewController (compat)
- (void)_updateMetadataLayer;
@end

@interface BRMetadataPreviewController (protectedAccess)
- (BRMetadataLayer *)gimmieMetadataLayer;
@end

@implementation BRMetadataPreviewController (protectedAccess)
- (BRMetadataLayer *)gimmieMetadataLayer
{
	Class myClass = [self class];
	Ivar ret = class_getInstanceVariable(myClass,"_metadataLayer");
	
	return *(BRMetadataLayer * *)(((char *)self)+ret->ivar_offset);
}
@end

@interface SapphireMediaPreview (private)
- (void)doPopulation;
- (NSString *)coverArtForPath;
@end

@implementation SapphireMediaPreview

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

- (id)initWithScene:(BRRenderScene *)scene
{
	if([[BRMetadataPreviewController class] instancesRespondToSelector:@selector(initWithScene:)])
		return [super initWithScene:scene];
	else
		return [super init];
}

- (void)dealloc
{
	[meta release];
	[dirMeta release];
	[super dealloc];
}

- (void)setUtilityData:(NSMutableDictionary *)newMeta
{
	[meta release];
	meta=[newMeta retain];
	SapphireMedia *asset  =[SapphireMedia alloc];
	[asset setImagePath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DefaultPreview" ofType:@"png"]];
	[self setAsset:asset];

}



/*!
 * @brief Search for cover art for the current metadata
 *
 * @return The path to the found cover art
 */
- (NSString *)coverArtForPath
{
	/*See if this is a directory*/
	if([meta isKindOfClass:[SapphireDirectoryMetaData class]])
	{
		NSString *ret = [(SapphireDirectoryMetaData *)meta coverArtPath];
		if(ret != nil)
			return ret;
	} else {
		NSString *ret = [(SapphireFileMetaData *)meta coverArtPath];
		if(ret != nil)
			return ret;
		else if ((ret = [dirMeta coverArtPath]) != nil)
			return ret;
	}
	/*Fallback to default*/
	return [[NSBundle bundleForClass:[self class]] pathForResource:@"SoftwareMenu" ofType:@"png"];
}

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

/*!
 * @brief populate metadata for Movies
 */

/*!
 * @brief populate utility data
 */
- (void)populateUtilityDataWith:(NSMutableDictionary *)allMeta
{
	BRMetadataLayer *metaLayer = [self gimmieMetadataLayer];
	/* Get the setting name */
	NSString *value = [allMeta objectForKey:META_TITLE_KEY];
	if(value != nil)
		[metaLayer setTitle:value];
	/*Get the setting description*/
	value = [allMeta objectForKey:META_DESCRIPTION_KEY];
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
	if(![SapphireFrontRowCompat usingFrontRow])
		return;
	[self doPopulation];
}

- (void)doPopulation
{
	/*Get our data then*/
	NSArray *order = nil;
	NSMutableDictionary *allMeta = nil;
	FileClass fileClass=FILE_CLASS_UNKNOWN ;
	if([meta respondsToSelector:@selector(getDisplayedMetaDataInOrder:)])
	{
		allMeta=[meta getDisplayedMetaDataInOrder:&order];
		if([meta isKindOfClass:[SapphireDirectoryMetaData class]])
			fileClass=FILE_CLASS_NOT_FILE;
		else
			fileClass=(FileClass)[(SapphireFileMetaData *) meta fileClass];
	}
	if(!allMeta)
		fileClass=FILE_CLASS_UTILITY;
		
	BRMetadataLayer *metaLayer = [self gimmieMetadataLayer];
	/* TV Show Preview Handeling */
	if(fileClass==FILE_CLASS_TV_SHOW)
	{
		[self  populateTVShowMetadataWith:allMeta];
	}
	/* Movie Preview Handeling */
	else if(fileClass==FILE_CLASS_MOVIE)
	{
		[self populateMovieMetadataWith:allMeta];
	}
	/* Utility Preview Handeling */
	else if(fileClass == FILE_CLASS_UTILITY)
	{
		[self populateUtilityDataWith:(NSMutableDictionary *)meta];
	}
	else if(fileClass != FILE_CLASS_NOT_FILE)
	{
		[self populateGenericMetadataWith:allMeta];
	}
	/* Directory Preview Handeling */
	else
	{
		NSString *value = [allMeta objectForKey:META_TITLE_KEY];
		if(value != nil)
			[metaLayer setTitle:value];
	}
	
	/* Show / Hide perian info */
	if(![[SapphireSettings sharedSettings] displayAudio])
	{
		[allMeta removeObjectForKey:AUDIO_DESC_LABEL_KEY];
		[allMeta removeObjectForKey:SUBTITLE_LABEL_KEY];        
	}
	if(![[SapphireSettings sharedSettings] displayVideo])
		[allMeta removeObjectForKey:VIDEO_DESC_LABEL_KEY];
	
	NSMutableArray *values = [NSMutableArray array];
	NSMutableArray *keys = [NSMutableArray array];
	
	/*Put the metadata in order*/
	NSEnumerator *keyEnum = [order objectEnumerator];
	NSString *key = nil;
	while((key = [keyEnum nextObject]) != nil)
	{
		NSString *value = [allMeta objectForKey:key];
		if(value != nil)
		{
			[values addObject:value];
			[keys addObject:key];
		}
	}
	
	/*And set it*/
	[metaLayer setMetadata:values withLabels:keys];

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
