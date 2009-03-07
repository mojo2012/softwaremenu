/*
 * SapphireMediaPreview.h
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

//@class SapphireMetaData, SapphireDirectoryMetaData;
//#import <BackRow/BackRow.h>
#import <BRMetadataPreviewController.h>
#import <BackRow/BackRow.h>

//#typedef enum {       FILE_CLASS_UTILITY= -2} FileClass;
#define META_TITLE_KEY                                  @"Title"
#define FILE_CLASS_KEY                                  @"File Class"
#define META_DESCRIPTION_KEY                    @"Show Description"

/*!
 * @brief A subclass of BRMetadataPreviewController for our own preview
 *
 * This class provides a means by which our custom metadata can be displayed.  From the metadata and its containing metadata, all the information can be gathered to construct the preview.
 *
 * The directory may not always be the parent of the metadata. In the case of virtual directories, the parent is a virtual directory while the metadata is the actual file located elsewhere.
 */
@interface SMMediaPreview : BRMetadataPreviewControl{
	char		padding[128];	/*!< @brief The classes are of different sizes.  This padding prevents a class compiled with one size to overlap when used with a class of a different size*/	
	NSDictionary			*meta;			/*!< @brief The metadata to display in the preview*/
	NSString	*dirMeta;		/*!< @brief The directory containing the metadata*/
}
- (BRMetadataControl *)gimmieMetadataLayer;
/*!
 * @brief Set the File information
 *
 * Set the metadata information for the preview.  This provides the necessary information for the preview to display all the information about the file
 *
 * @param newMeta The metadata for the file or directory
 * @param dir The directory which contains this metadata
 */
//- (void)setMetaData:(NSDictionary *)newMeta inMetaData:(SapphireDirectoryMetaData *)dir;
- (void)setUtilityData:(NSMutableDictionary *)newMeta;

@end
