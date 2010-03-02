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
#import "SMMedia.h"
#import <objc/objc-class.h>
@interface BRCoverArtImageLayer (compat)
-(id)texture;
@end

/*These interfaces are to access variables not available*/
@interface BRMetadataControl (protectedAccess)
- (NSArray *)gimmieMetadataObjs;
@end


/* There is no BRMetadataLayer class in ATV2.0 anymore, it seems to be BRMetadataControl now*/
/* So just do the same stuff as above, but for BRMetadataControl*/

@implementation BRMetadataControl (protectedAccess)
	-(NSArray *)gimmieMetadataObjs {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_metadataObjs");
	return *(NSArray * *)(((char *)self)+ret->ivar_offset);
}
@end


@interface BRMetadataPreviewControl (compat)
- (void)_populateMetadata;
- (void)_updateMetadataLayer;
- (id) _loadCoverArt;
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
	//[dirMeta release];
	[super dealloc];
}

- (void)setUtilityData:(NSMutableDictionary *)newMeta
{
	[meta release];
	meta=[newMeta retain];
	SMMedia *asset  =[SMMedia alloc];
	[asset setDefaultImage];
	[self setAsset:asset];

}

- (void)setMetaData:(NSMutableDictionary *)newMeta
{

	[meta release];

	meta = [newMeta retain];

	SMMedia *asset  =[[SMMedia alloc] initWithMediaURL];
	[asset setImagePath:[newMeta valueForKey:@"ImageURL"]];

}

/*!
 * @brief Search for cover art for the current metadata
 *
 * @return The path to the found cover art
 */
- (NSString *)coverArtForPath
{
	if([[NSFileManager defaultManager] fileExistsAtPath:[meta valueForKey:@"ImageURL"]])
		return [meta valueForKey:@"ImageURL"];
	return [[NSBundle bundleForClass:[self class]] pathForResource:@"softwaremenu" ofType:@"png"];
}

/*!
 * @brief Override the loading of the cover art method
 */

- (void)_loadCoverArt
{
    //NSLog(@"load covert Art");
	[super _loadCoverArt];
	
	/*See if it loaded something*/
	if([_coverArtLayer texture] != nil)
		return;
	
	/*Get our cover art*/
	NSString *path = [self coverArtForPath];
	//NSURL *url = [NSURL fileURLWithPath:path];
	{
		[_coverArtLayer setImage:[BRImage imageWithURL:path]];
		
	}	
}
- (void) populateMovieMetadataWith:(NSMutableDictionary*)allMeta
{
	/* Get the movie title */
	NSString *value=nil;
	value = [allMeta objectForKey:@"Name"];
	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
	
	/*Get the release date*/
	NSDate *releaseDate = [allMeta objectForKey:@"ReleaseDate"];
	if(releaseDate != nil)
	{
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateStyle:NSDateFormatterLongStyle];
		[format setTimeZone:NSDateFormatterNoStyle];
		value = [NSString stringWithFormat:@"Released: %@",[format stringFromDate:releaseDate]];
		[allMeta removeObjectForKey:@"ReleaseDate"];
		[allMeta removeObjectForKey:@"Name"];
	}
	/* No release date, sub in the movie title */
	[metaLayer setTitle:value];
	
	/* Display Online Version */
	value = nil;
	value = [allMeta objectForKey:@"OnlineVersion"];
	if(value != nil)
		[allMeta setObject:value forKey:@"Online"];
	
	/* Display Installed Version */
	value = nil;
	value = [allMeta objectForKey:@"InstalledVersion"];
	if(value != nil)
		[allMeta setObject:value forKey:@"InstalledVersion"];
	
	/*Get the movie plot*/
	value=nil;
	value = [allMeta objectForKey:@"ShortDescription"];
	if(value != nil)
		[metaLayer setSummary:value];
	
	NSArray *values=nil;
	/* Get genres */
	/* Get directors */
	values=nil;
	value=[NSString string];
	value=[allMeta objectForKey:@"Developer"];
	if(values!=nil)
	{
		[allMeta setObject:value forKey:@"Developer"];
	}
	/* Get cast */
	/* Get IMDB Stats */
	value=nil ;
}

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
	//if(![SapphireFrontRowCompat usingFrontRow])
		//return;
	[self doPopulation];
}

- (void)doPopulation
{
	
	//NSLog(@"Do Populations");
	NSMutableDictionary *allMeta = nil;
	allMeta = [self getMetaData];
	NSMutableArray *order = [allMeta valueForKey:@"OrderArray"];
	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
	NSMutableArray *values = [NSMutableArray array];
	NSMutableArray *keys = [NSMutableArray array];
	
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
    //NSLog(@"values : %@",values);
    //NSLog(@"keys : %@",keys);
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
-(NSMutableDictionary *)getMetaData
{
    //NSLog(@"reflection: %f %f",[_reflectionLayer reflectionAmount],[_reflectionLayer reflectionOffset]);
	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
	[metaLayer setTitle:[[self asset] title]];
	[metaLayer setSummary:[[self asset] mediaSummary]];
	NSMutableArray *orderedArray = [NSMutableArray arrayWithObjects:nil];
	NSMutableDictionary *metaData = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	NSString *value =nil;
	/*Check for Online Version Number*/
	value = [[self asset] onlineVersion];
	if(value != nil)
	{
		[metaData setValue:value forKey:@"Online" ];
		[orderedArray addObject:@"Online"];
	}
	value = nil;
	
	/*Check for Installed Version Number*/
	value = [[self asset] installedVersion];
	if(value != nil)
	{
		[metaData setValue:value forKey:@"Installed"];
		[orderedArray addObject:@"Installed"];
	}
	value = nil;
	
	/*Check for Developer Key*/
	value = [[self asset] developer];
	if(value != nil)
	{
		[metaData setValue:value forKey:@"Developer"];
		[orderedArray addObject:@"Developer"];
	}
	[metaData setValue:orderedArray forKey:@"OrderArray"];
	return metaData;
}

@end
