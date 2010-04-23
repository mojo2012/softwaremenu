//
//  SMFMediaPreview.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 11/9/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//


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

@interface SMFMediaPreview (private)
- (void)doPopulation;
- (NSString *)coverArtForPath;
@end

@implementation SMFMediaPreview

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
    self=[super init];
    meta=[[NSMutableDictionary alloc] init];
    
    [meta setObject:@"No Title" forKey:METADATA_TITLE];
    image=[[SMFThemeInfo sharedTheme] notFoundImage];
    [image retain];
    return self;
}

- (void)dealloc
{
	[meta release];
    [coverArtExtentions release];
	//[dirMeta release];
	[super dealloc];
}

//- (void)setUtilityData:(NSMutableDictionary *)newMeta
//{
//	[meta release];
//	meta=[newMeta retain];
//	SMFMedia *asset  =[SMFMedia alloc];
//	[asset setDefaultImage];
//	[self setAsset:asset];
//
//}
//- (void)setCustomMetaData:(NSMutableDictionary *)customMeta
//{
//    MetaDataType=kMetaTypeCustom;
//    [meta release];
//    meta=[customMeta retain];
//    if(_asset==nil)
//    {
//        SMFMedia *asset = [SMFMedia alloc];
//        [self setAsset:asset]; 
//    }
//
//}
- (void)setImage:(BRImage *)currentImage
{
    [image release];
    image=[currentImage retain];
//    NSLog(@"%@",_asset);
//    [_asset setBRImage:image];
//    if (_asset!=nil && [_asset respondsToSelector:@selector(setBRImage:)])
//        [_asset setBRImage:image];
    [_coverArtLayer setImage:image];
//    [_reflectionLayer setImage:image];
//    [_reflectionLayer setReflectionAmount:0.337531];
}
- (void)setImagePath:(NSString *)path
{
    if([[NSFileManager defaultManager] fileExistsAtPath:path] && [coverArtExtentions containsObject:[path pathExtension]])
    {
        [self setImage:[BRImage imageWithPath:path]];
    }
    
}
//- (void)setPluginMetaData:(NSMutableDictionary *)customMeta
//{
//    MetaDataType=kMetaTypePlugin;
//    [meta release];
//	SMFMedia *asset  =[[SMFMedia alloc] initB];
//    if([[customMeta allKeys] containsObject:METADATA_IMAGE_URL])
//        [asset setImagePath:[customMeta valueForKey:METADATA_IMAGE_URL]];
//    [self setAsset:asset];
//}
//- (void)setSimpleMetaDataWithTitle:(NSString *)title andSummary:(NSString *)summary
//{
//    MetaDataType=kMetaTypeSimple;
//    NSLog(@" %@ %@",title,summary);
//    if (title!=nil)
//        [meta setObject:title forKey:METADATA_TITLE];
//    if (summary!=nil)
//        [meta setObject:summary forKey:METADATA_SUMMARY];
//    //[self setAsset:[SMFMedia alloc]];
//    if (_asset==nil) {
//        [self setAsset:[[SMFMedia alloc]initB]];
//        
//    }
//    
////    [self _updateMetadataLayer];
//}
- (void)setAsset:(id)asset
{
    //NSLog(@"assetMeta: %@",asset);
    MetaDataType=kMetaTypeAsset;
    [super setAsset:asset];
    [_reflectionLayer setImage:[asset coverArt]];
    [_reflectionLayer setReflectionAmount:0.337531];
    [_coverArtLayer setImage:[asset coverArt]];
    //NSLog(@"_asset: %@",_asset);
    
    //[self _updateMetadataLayer];
}
-(void)setAssetMeta:(id)asset
{
    [self setAsset:asset];
}




- (id)coverArtForPath
{
    if (image!=nil)
        return image;
    image=[_asset coverArt];
    if (image!=nil)
        return image;
    //NSLog(@"covertArtForPath");
//    if([[NSFileManager defaultManager] fileExistsAtPath:[meta valueForKey:METADATA_IMAGE_URL]])
//		return [BRImage imageWithPath:[meta valueForKey:METADATA_IMAGE_URL]];
	return [[SMFThemeInfo sharedTheme] notFoundImage];
}


- (void)_loadCoverArt
{
    //NSLog(@"loading cover art");
	[super _loadCoverArt];
	if([_coverArtLayer texture] != nil)
		return;
	id localImage = [self coverArtForPath];
    [_coverArtLayer setImage:localImage];
    [_reflectionLayer setImage:localImage];
    [_reflectionLayer setReflectionAmount:0.337531];
    
	
}
//- (void) populateMovieMetadataWith:(NSMutableDictionary*)allMeta
//{
//	/* Get the movie title */
//	NSString *value=nil;
//	value = [allMeta objectForKey:METADATA_TITLE];
//	BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
//	
//	/*Get the release date*/
//	NSDate *releaseDate = [allMeta objectForKey:@"ReleaseDate"];
//	if(releaseDate != nil)
//	{
//		NSDateFormatter *format = [[NSDateFormatter alloc] init];
//		[format setDateStyle:NSDateFormatterLongStyle];
//		[format setTimeZone:NSDateFormatterNoStyle];
//		value = [NSString stringWithFormat:@"Released: %@",[format stringFromDate:releaseDate]];
//		[allMeta removeObjectForKey:@"ReleaseDate"];
//		[allMeta removeObjectForKey:@"Name"];
//	}
//    
//	/* No release date, sub in the movie title */
//	[metaLayer setTitle:value];
//	
//	/* Display Online Version */
//	value = nil;
//	value = [allMeta objectForKey:@"OnlineVersion"];
//	if(value != nil)
//		[allMeta setObject:value forKey:@"Online"];
//	
//	/* Display Installed Version */
//	value = nil;
//	value = [allMeta objectForKey:@"InstalledVersion"];
//	if(value != nil)
//		[allMeta setObject:value forKey:@"InstalledVersion"];
//	
//	/*Get the movie plot*/
//	value=nil;
//	value = [allMeta objectForKey:@"ShortDescription"];
//	if(value != nil)
//		[metaLayer setSummary:value];
//	
//	NSArray *values=nil;
//
//	values=nil;
//	value=[NSString string];
//	value=[allMeta objectForKey:@"Developer"];
//	if(values!=nil)
//	{
//		[allMeta setObject:value forKey:@"Developer"];
//	}
//
//	value=nil ;
//}

- (void)_populateMetadata
{
    //NSLog(@"_populate");
	[super _populateMetadata];
	[self doPopulation];
}


- (void)_updateMetadataLayer
{
    //NSLog(@"update");
	[super _updateMetadataLayer];
	[self doPopulation];
}

- (void)doPopulation
{
    //NSLog(@"doPopulation");
    BRMetadataControl *metaLayer = [self gimmieMetadataLayer];
    switch (MetaDataType) {
        case kMetaTypeCustom:
        {
            [metaLayer setTitle:[meta objectForKey:METADATA_TITLE]];
            [metaLayer setSummary:[meta objectForKey:METADATA_SUMMARY]];
            if ([[meta allKeys] containsObject:METADATA_CUSTOM_KEYS] && [[meta allKeys] containsObject:METADATA_CUSTOM_OBJECTS]) {
                [metaLayer setMetadata:[meta objectForKey:METADATA_CUSTOM_OBJECTS] withLabels:[meta objectForKey:METADATA_CUSTOM_KEYS]];
            }
            break;  
        }
        case kMetaTypePlugin:
        {
            NSMutableDictionary *allMeta=[self getPluginMetaData];
            NSMutableArray *order = [allMeta valueForKey:METADATA_CUSTOM_KEYS];
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
            
            break;
        }
        case kMetaTypeSimple:
        {
            [metaLayer setTitle:[meta objectForKey:METADATA_TITLE]];
            [metaLayer setSummary:[meta objectForKey:METADATA_SUMMARY]];
            break;
        }
        case kMetaTypeAsset:
        {
            id asset = [self asset];
            if ([asset respondsToSelector:@selector(orderedDictionary)]) {
                NSDictionary *assetDict=[asset orderedDictionary];
                if([[assetDict allKeys] containsObject:METADATA_TITLE])
                    [metaLayer setTitle:[assetDict objectForKey:METADATA_TITLE]];
                if([[assetDict allKeys] containsObject:METADATA_SUMMARY])
                    [metaLayer setSummary:[assetDict objectForKey:METADATA_SUMMARY]];
                if([[assetDict allKeys] containsObject:METADATA_CUSTOM_KEYS])
                {
                    //NSLog(@"%@",[assetDict objectForKey:METADATA_CUSTOM_OBJECTS]);
                    //NSLog(@"%@",[assetDict objectForKey:METADATA_CUSTOM_KEYS]);
                    [metaLayer setMetadata:[assetDict objectForKey:METADATA_CUSTOM_OBJECTS] withLabels:[assetDict objectForKey:METADATA_CUSTOM_KEYS]];
                }
            }
            break;
        }
        default:
        {
            [metaLayer setTitle:[meta objectForKey:METADATA_TITLE]];
            [metaLayer setSummary:[meta objectForKey:METADATA_SUMMARY]];
            break;
        }
           
    }
    //`NSLog(@"donePopulating");
	
	

}


- (BOOL)_assetHasMetadata
{
	return YES;
}
-(NSMutableDictionary *)getPluginMetaData
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
	[metaData setValue:orderedArray forKey:METADATA_CUSTOM_KEYS];
	return metaData;
}

@end



