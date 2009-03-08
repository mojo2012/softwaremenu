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

#import "SMMediaPreview.h"
//#import "SapphireMetaData.h"
#import "SMMedia.h"
#import "BackRowUtilstwo.h"
//#import "BackRow/BRMetadataControl.h"
//#import "SapphireSettings.h"
#import <objc/objc-class.h>
//#import <SapphireCompatClasses/SapphireFrontRowCompat.h>

/*These interfaces are to access variables not available*/
/*@interface BRMetadataLayer (protectedAccess)
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
/*@interface BRMetadataControl : NSObject
@end*/
#define META_TITLE_KEY                                  @"Title"
#define FILE_CLASS_KEY                                  @"File Class"
#define META_DESCRIPTION_KEY                    @"Show Description"


@implementation BRMetadataControl (protectedAccess)
	-(NSArray *)gimmieMetadataObjs {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_metadataObjs");
	return *(NSArray * *)(((char *)self)+ret->ivar_offset);
}
-(NSArray *)gimmieMetadataLabels {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_metadataLabels");
	return *(NSArray * *)(((char *)self)+ret->ivar_offset);
}

@end

@interface BRMetadataPreviewControl (compat)
- (void)_updateMetadataLayer;
@end

@interface BRMetadataPreviewControl (protectedAccess)
- (BRMetadataControl *)gimmieMetadataLayer;
@end

@implementation BRMetadataPreviewControl (protectedAccess)
- (BRMetadataControl *)gimmieMetadataLayer
{
	Class myClass = [self class];
	Ivar ret = class_getInstanceVariable(myClass,"_metadataLayer");
	
	return *(BRMetadataControl * *)(((char *)self)+ret->ivar_offset);
}
@end


@interface SMMediaPreview (private)
- (void)doPopulation;
- (NSString *)coverArtForPath;
@end

@implementation SMMediaPreview

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


- (void)dealloc
{
	[meta release];
	[dirMeta release];
	[super dealloc];
}

- (void)setUtilityData:(NSMutableDictionary *)newMeta
{
	/*NSArray *thelabels =[self gimmieMetadataLabels];
	NSLog(@"populateutility:%@",thelabels);*/
	NSLog(@"newmeta:%@",newMeta);
	[meta release];
	meta=[newMeta retain];
	NSLog(@"meta:%@",meta);
	SMMedia *asset  =[SMMedia alloc];
	[asset setImagePath:[[NSBundle bundleForClass:[self class]] pathForResource:@"SoftwarMenu" ofType:@"png"]];
	[self setAsset:asset];

}
/*- (void)setUtilityData:(NSMutableDictionary *)newMeta
{
	[meta release];
	meta=[newMeta retain];
	SMMedia *asset  =[SMMedia alloc];
	[asset setImagePath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DefaultPreview" ofType:@"png"]];
	[self setAsset:asset];
	
}*/

/*- (void)setMetaData:(SapphireMetaData *)newMeta inMetaData:(SapphireDirectoryMetaData *)dir
{
	[meta release];
	NSString *path = [newMeta path];
	if(path == nil)
	{
		meta = nil;
		return;
	}
	meta = [newMeta retain];
	[dirMeta release];
	dirMeta = [dir retain];
	/*Now that we know the file, set the asset
	NSURL *url = [NSURL fileURLWithPath:[meta path]];
	SapphireMedia *asset  =[[SapphireMedia alloc] initWithMediaURL:url];
	[asset setImagePath:[self coverArtForPath]];
	[self setAsset:asset];
}*/

/*!
 * @brief Search for cover art for the current metadata
 *
 * @return The path to the found cover art
 */
- (NSString *)coverArtForPath
{
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
	{
		[_coverArtLayer setImage:[BRImage imageWithURL:path]];
		
	}	
}
/*- (BRMetadataControl *)gimmieMetadataLayer
{
	Class myClass = [self class];
	Ivar ret = class_getInstanceVariable(myClass,"_metadataLayer");
	
	return *(BRMetadataControl * *)(((char *)self)+ret->ivar_offset);
}*/

/*!
 * @brief populate utility data
 */
/*- (void)populateUtilityDataWith:
{
	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
	/* Get the setting name *
	NSString *value = [BRLocalizedStringManager appliance:self localizedStringForKey:@"hello" inFile:nil];
	if(value != nil)
		[metaLayer setTitle:[BRLocalizedStringManager appliance:self localizedStringForKey:@"hello" inFile:nil]];
	/*Get the setting description
	value = BRLocalizedString(@" Fetch Movie Data", @"Fetch Movie Data menu item");
	if(value != nil)
			[metaLayer setSummary:value];
}*/
- (void)populateUtilityDataWith:(NSMutableDictionary *)allMeta
{
	//NSArray *thelabels =[self gimmieMetadataLabels];
	//NSLog(@"populateutility:%@",thelabels);
	NSLog(@"in populateUtility:%@",allMeta);
	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
	/* Get the setting name */
	NSString *value = [allMeta objectForKey:META_TITLE_KEY];
	if(value != nil)
		[metaLayer setTitle:value];
	NSLog(@"value:%@",value);
	/*Get the setting description*/
	value = [allMeta objectForKey:META_DESCRIPTION_KEY];
	NSLog(@"value:%@",value);
	if(value != nil)
		[metaLayer setSummary:value];
}

/*!
 * @brief populate metadata for media files
 */
- (void)_populateMetadata
{
	NSLog(@"_populateMeta");
	[super _populateMetadata];
	[self doPopulation];
}

/*!
 * @brief populate metadata for media files
 */
- (void)_updateMetadataLayer
{
	NSLog(@"_updateMetaLayer");
	[super _updateMetadataLayer];
	/*See if it loaded anything*/
	
}

/*- (void)doPopulation
{
	/*Get our data then*
	NSArray *order = nil;
	NSMutableDictionary *allMeta = nil;

	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
		[self populateUtilityDataWith:(NSMutableDictionary *)meta];
	/* Show / Hide perian info *

	NSMutableArray *values = [NSMutableArray array];
	NSMutableArray *keys = [NSMutableArray array];
	
	/*Put the metadata in order*
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
	
	/*And set it*
	[metaLayer setMetadata:values withLabels:keys];

}*/
- (void)doPopulation
{
	NSLog(@"do Population");
	/*Get our data then*/
	NSLog(@"Meta in do population:%@",meta);
	NSArray *order = nil;
	NSMutableDictionary *allMeta = nil;
	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
	
	//NSArray *hellotoo=[self gimmieMetadataObjs];
	//NSLog(@"metadataObjs:%@",hellotoo);
	/* TV Show Preview Handeling */

		[self populateUtilityDataWith:meta];
	
	/* Show / Hide perian info */
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
	NSLog(@"keys",keys);
	//[metaLayer setTitle:@"hello"];
	NSArray *valuestoo=[NSArray arrayWithObjects:@"Hello",@"Hello",nil];
	NSArray *keystoo=[NSArray arrayWithObjects:META_TITLE_KEY,META_DESCRIPTION_KEY,nil];
	//[metaLayer setMetadata:valuestoo withLabels:keystoo];
	
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
