/*
 * SapphireMedia.m
 * Sapphire
 *
 * Created by Graham Booker on Jun. 25, 2007.
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

#import <SMMedia.h>
//#import "BackRowUtilstwo.h"
//#import <SapphireCompatClasses/SapphireFrontRowCompat.h>
//#typedef enum {       FILE_CLASS_UTILITY= -2} FileClass;
#define META_TITLE_KEY                                  @"Title"
#define FILE_CLASS_KEY                                  @"File Class"
#define META_DESCRIPTION_KEY                    @"Show Description"

@implementation SMMedia

/*- (id)initWithMediaURL:(NSURL *)url
{
	//This is here to fix 2.2
	self = [super initWithMediaProvider:nil];
	NSString *urlString = [url absoluteString];
	NSString *filename = [url path];
	[self setObject:[filename lastPathComponent] forKey:@"id"];
	[self setObject:[BRMediaType movie] forKey:@"mediaType"];
	[self setObject:urlString forKey:@"mediaURL"];
	
	return self;
}*/

- (void)dealloc
{
	[imagePath release];
	[theSetDescription release];
	[theSetDescription release];
	[theDev release];
	[super dealloc];
}
-(id)assetID
{
	return @"hello";
}
/*- (void)setResumeTime:(unsigned int)time
{
	resumeTime = time;
}

/* Overrides the bookmark time */
//- (unsigned int)bookmarkTimeInSeconds
//{
	/*Check for resume time and if none, return bookmark time*/
//	if(time == 0)
//		return [super bookmarkTimeInSeconds];
	/*return resume time*/
//	return resumeTime;
//}

- (void)setImagePath:(NSString *)path
{
	//path=@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/SoftwareMenu.png";
	[imagePath release];
	imagePath = [path retain];
}
- (void)setDefaultImage
{
	NSString *path=@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/SoftwareMenu.png";
	[imagePath release];
	imagePath = [path retain];
}
-(void)setDescription:(NSString *)description
{
	[theSetDescription release];
	theSetDescription=[description retain];
}
-(void)setTitle:(NSString *)title
{
	[theSetTitle release];
	theSetTitle=[title retain];
}
-(void)setDev:(NSString *)devName
{
	[theDev release];
	theDev=[devName retain];
}
-(id)description
{
	NSString *hellotoo = [[NSString alloc] init];
	hellotoo=@"hello";
	return hellotoo;
}
-(id)title
{
	
	NSString *hello = [[NSString alloc] init];
	hello=@"Setting";
	return theSetTitle;
}

-(id)mediaSummary
{
	return theSetDescription;
}
- (id)mediaType
{

		return [BRMediaType movie];
}

- (BOOL)hasCoverArt
{
	return YES;
}

- (id)coverArt
{
	id coverArt=[BRImage imageWithPath:imagePath];
	return coverArt;
}
-(id)directors
{
	NSLog(@"directors: %@",theDev);
	return [NSArray arrayWithObjects:theDev,nil];
}
/*-(id)artist
{
	NSLog(@"artist: %@",theDev);
	return [NSArray arrayWithObjects:theDev,nil];
}*/
/*-(id)composer
{
	NSLog(@"composer: %@",theDev);
	return theDev;
}
-(id)dateCreated
{
	NSLog(@"date: %@",[NSDate date]);
	return [NSDate date];
}
-(id)datePublished
{
	NSLog(@"date: %@",[NSDate date]);
	return [NSDate date];
}*/
-(id)imageAtPath:(NSString *)path
{
	
	// this returns a CGImageRef
	id sp= [BRImage imageWithPath:imagePath];
	return [sp autorelease];
}
/*-(id)genres
{
	return [NSArray arrayWithObjects:@"date"];
}*/


@end
