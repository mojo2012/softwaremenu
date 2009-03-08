/*
 * BRMetadataPreviewController.h
 * Sapphire
 *
 * Created by Eric Steirl III on Feb. 14, 2008.
 * Copyright 2008 Sapphire Development Team and/or www.nanopi.net
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
//#import <Cocoa/Cocoa.h>
//#import <BackRow/BRControl.h>
////#import <BackRow/BackRow.h>

/*!
 * @brief Not a really a class
 *
 * This class is only here to make the compiler shut up.  It is never used.  The only time the BRMetdataPreviewController is ever loaded is on ATV2.
 */
/*@interface BRMetadataPreviewControl : BRControl {
}
@end*/

/*!
 * @brief Provide a BRLayerController for frontrow
 *
 * ATV2 doesn't have a BRMetadataPreviewController, but it has BRMetadataPreviewControl.  Use that one instead.
 */
@interface BRMetadataPreviewController : BRMetadataPreviewControl {
	int		padding[16];
}

@end

