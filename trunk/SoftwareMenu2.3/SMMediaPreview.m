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
	//NSLog(@"SetMetaData");
	[meta release];
	/*NSString *path = [newMeta objectForKey:@"path"];
	if(path == nil)
	{
		meta = nil;
		return;
	}*/
	meta = [newMeta retain];
	//NSLog(@"newMeta: %@",newMeta);
	//[dirMeta release];
	//dirMeta = [dir retain];
	/*Now that we know the file, set the asset*/
	//NSURL *url = [NSURL fileURLWithPath:[meta path]];
	SMMedia *asset  =[[SMMedia alloc] initWithMediaURL];
	[asset setImagePath:[newMeta valueForKey:@"ImageURL"]];
	//[self setAsset:asset];
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


/*!
 * @brief populate metadata for TV Shows
 */
/*- (void) populateTVShowMetadataWith:(NSMutableDictionary*)allMeta
{
	NSString *value = [allMeta objectForKey:META_TITLE_KEY];
	BRMetadataLayer *metaLayer = [self gimmieMetadataLayer];
	if(value != nil)
	{
		/*If there is an air date, put it in the title
		NSDate *airDate = [allMeta objectForKey:META_SHOW_AIR_DATE];
		if(airDate != nil)
		{
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateStyle:NSDateFormatterShortStyle];
			[format setTimeZone:NSDateFormatterNoStyle];
			value = [[format stringFromDate:airDate]stringByAppendingFormat:@" - %@", value];
		}
		[metaLayer setTitle:value];
	}
	
	/*Get the rating
	value = [allMeta objectForKey:META_RATING_KEY];
	if(value != nil)
		[metaLayer setRating:value];
	
	/*Get the description
	value = [allMeta objectForKey:META_DESCRIPTION_KEY];
	if(value != nil)
		if([[SapphireSettings sharedSettings] displaySpoilers])
			[metaLayer setSummary:value];
	
	/*Get the copyright
	value = [allMeta objectForKey:META_COPYRIGHT_KEY];
	if(value != nil)
		[metaLayer setCopyright:value];
	
	/*Get the season and epsiodes
	value = [allMeta objectForKey:META_EPISODE_AND_SEASON_KEY];
	if(value != nil)
	{
		/*Remove the individuals so we don't display them
		[allMeta removeObjectForKey:META_EPISODE_NUMBER_KEY];
		[allMeta removeObjectForKey:META_EPISODE_2_NUMBER_KEY];
		[allMeta removeObjectForKey:META_SEASON_NUMBER_KEY];
	}
}

/*!
 * @brief populate metadata for Movies
 */
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

/*!
 * @brief populate utility data
 */
/*- (void)populateUtilityDataWith:(NSMutableDictionary *)allMeta
{
	BRMetadataLayer *metaLayer = [self gimmieMetadataLayer];
	/* Get the setting name 
	NSString *value = [allMeta objectForKey:META_TITLE_KEY];
	if(value != nil)
		[metaLayer setTitle:value];
	/*Get the setting description
	value = [allMeta objectForKey:META_DESCRIPTION_KEY];
	if(value != nil)
			[metaLayer setSummary:value];
}

/*!
 * @brief populate generic file data
 */
/*- (void)populateGenericMetadataWith:(NSMutableDictionary *)allMeta
{
	NSString *value = [allMeta objectForKey:META_TITLE_KEY];
	BRMetadataLayer *metaLayer = [self gimmieMetadataLayer];
	if(value != nil)
		[metaLayer setTitle:value];
	
	/*Get the rating*
	value = [allMeta objectForKey:META_RATING_KEY];
	if(value != nil)
		[metaLayer setRating:value];
	
	/*Get the description*
	value = [allMeta objectForKey:META_DESCRIPTION_KEY];
	if(value != nil)
		if([[SapphireSettings sharedSettings] displaySpoilers])
			[metaLayer setSummary:value];
	
	/*Get the copyright*
	value = [allMeta objectForKey:META_COPYRIGHT_KEY];
	if(value != nil)
		[metaLayer setCopyright:value];
	
	/*Get the rating*
	value=nil;
	value = [allMeta objectForKey:META_MOVIE_MPAA_RATING_KEY];
	if(value != nil)
		[metaLayer setRating:value];
	/*Get the movie plot*
	value=nil;
	value = [allMeta objectForKey:META_MOVIE_PLOT_KEY];
	if(value != nil)
		if([[SapphireSettings sharedSettings] displaySpoilers])
			[metaLayer setSummary:value];
	
	NSArray *values=nil;
	/* Get genres *
	values=[allMeta objectForKey:META_MOVIE_GENRES_KEY];
	value=[NSString string];
	if(values!=nil)
	{
		NSEnumerator *valuesEnum = [values objectEnumerator] ;
		NSString *aValue=nil;
		while((aValue = [valuesEnum nextObject]) !=nil)
		{
			value=[value stringByAppendingString:[NSString stringWithFormat:@"%@, ",aValue]];
		}
		/* get rid of the extra comma *
		value=[value substringToIndex:[value length]-2];
		/* sub the array for a formatted string *
		[allMeta setObject:value forKey:META_MOVIE_GENRES_KEY];
	}
	/* Get directors *
	values=nil;
	values=[allMeta objectForKey:META_MOVIE_DIRECTOR_KEY];
	value=[NSString string];
	if(values!=nil)
	{
		NSEnumerator *valuesEnum = [values objectEnumerator] ;
		NSString *aValue=nil;
		while((aValue = [valuesEnum nextObject]) !=nil)
		{
			value=[value stringByAppendingString:[NSString stringWithFormat:@"%@, ",aValue]];
		}
		/* get rid of the extra comma *
		value=[value substringToIndex:[value length]-2];
		/* sub the array for a formatted string *
		[allMeta setObject:value forKey:META_MOVIE_DIRECTOR_KEY];
	}
	/* Get cast *
	values=nil;
	values=[allMeta objectForKey:META_MOVIE_CAST_KEY];
	value=[NSString string];
	if(values!=nil)
	{
		NSEnumerator *valuesEnum = [values objectEnumerator] ;
		NSString *aValue=nil;
		NSString *lastToAdd = nil;
		if([values count]>2)
			lastToAdd=[values objectAtIndex:2] ;
		while((aValue = [valuesEnum nextObject]) !=nil)
		{
			value=[value stringByAppendingString:[NSString stringWithFormat:@"%@, ",aValue]];
			if([aValue isEqualToString:lastToAdd])break;
		}
		/* get rid of the extra comma *
		value=[value substringToIndex:[value length]-2];
		/* sub the array for a formatted string *
		[allMeta setObject:value forKey:META_MOVIE_CAST_KEY];
	}	
}

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
