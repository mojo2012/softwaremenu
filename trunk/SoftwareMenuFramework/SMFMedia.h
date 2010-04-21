//
//  SMFMedia.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 11/9/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

typedef enum{
	kSMMPhotos = 1,
	kSMMDefault = 0,
	kSMMPhotosSettings = 2,
	kSMMImaged = 3,
	kSMMOther = 10,
}SSMType;
@interface SMFMedia : BRXMLMediaAsset {
	unsigned int		resumeTime;		/*!< @brief The resume time to use, 0 to use super*/
	NSString			*imagePath;		/*!< @brief The cover art path to use, nil to use super*/
	NSString			*theSetTitle;
	NSString			*theSetDescription;
	NSString			*theDev;
	NSString			*installedVersion;
	NSString			*onlineVersion;
	NSString			*changeLog;
	id					bRImage;
	unsigned int		type;
}

/*!
 * @brief Creates a media with a URL. Compatibility with old calling mechanism
 *
 * @param url The url to use for this media.
 * @return The media
 */
//- (id)initWithMediaURL:(NSURL *)url;

/*!
 * @brief Set the resume time for the media
 *
 * @param time the time at which to resume
 */
//- (void)setResumeTime:(unsigned int)time;

/*!
 * @brief Sets the image path for cover art so it can be displayed
 *
 * param path The path to the cover art
 */
- (id)initB;
- (void)setImagePath:(NSString *)path;
- (void)setDescription:(NSString *)description;
- (void)setTitle:(NSString *)title;
- (void)setDev:(NSString *)devName;
- (void)setOnlineVersion:(NSString *)onlineVersion;
- (void)setInstalledVersion:(NSString *)installedVersion;
- (void)setDefaultImage;
- (void)setPhotosImage;
- (void)setPhotosSettingsImage;
- (void)setBRImage:(id)Image;
- (id)installedVersion;
- (id)onlineVersion;
- (id)developer;
- (NSString *)stringReturn:(NSString *)theString;

@end
