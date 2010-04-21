//
//  SMMovieAsset.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/16/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMMovieAsset.h"


@implementation SMMovieAsset
- (id)initWithMediaURL:(NSURL *)url
{
	//This is here to fix 2.2
	self = [super initWithMediaProvider:nil];
    
	NSString *urlString = [url absoluteString];
	NSString *filename = [url path];
	[self setObject:[filename lastPathComponent] forKey:@"id"];
	[self setObject:[BRMediaType movie] forKey:@"mediaType"];
	[self setObject:urlString forKey:@"mediaURL"];
    [self setObject:@"." forKey:@"mediaSummary"];
    [self setObject:[filename lastPathComponent] forKey:@"title"];
    _image=[[BRThemeInfo sharedTheme]tvShowFeaturedPlaceholderImage];
    [_image retain];
	return self;
}
-(BRImage *)coverArt
{
    return _image;
}
- (BOOL)hasCoverArt
{
	return YES;
}
- (void)dealloc
{
	[_image release];
	[super dealloc];
}

- (void)setResumeTime:(unsigned int)time
{
	resumeTime = time;
}
-(unsigned int)resumeTime
{
    return resumeTime;
}
-(void)setCoverArtPath:(NSString *)path
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [_image release];
        _image=[[BRImage imageWithPath:path] retain];
    }
}
-(void)setMediaSummary:(NSString *)summary
{
    if (summary!=nil) {
        [self setObject:summary forKey:@"mediaSummary"];
    }
}
-(void)setTitle:(NSString *)title
{
   if (title!=nil) { 
       [self setObject:title forKey:@"title"];
   }
}
/* Overrides the bookmark time */
- (unsigned int)bookmarkTimeInSeconds
{
	/*Check for resume time and if none, return bookmark time*/
	if(time == 0)
		return [super bookmarkTimeInSeconds];
	/*return resume time*/
	return resumeTime;
}
-(id)mediaSummary
{
    return [_info objectForKey:@"mediaSummary"];
}
//-(id)mediaDescription
//{
//    return @"Hello";
//}
-(id)title
{
    return [_info objectForKey:@"title"];
}
@end
