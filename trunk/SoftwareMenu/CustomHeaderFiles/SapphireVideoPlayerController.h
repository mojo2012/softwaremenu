/*
 * SapphireVideoPlayerController.h
 * Sapphire
 *
 * Created by pnmerrill on Apr. 26, 2008.
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
@interface BRVideoPlayerController:NSObject
-(void)setAllowsResume:(BOOL)resume;
@end

@class SapphireFileMetaData, SapphireVideoPlayer;

/*!
 * @brief A subclass of BRVideoPlayerController for setting up AC3 passthrough and resume support
 *
 * This class is designed to setup and teardown perian's AC3 passthrough hack for video files containing AC3 data.  In addition, it also provides marking the resume point in files.
 */
@interface SapphireVideoPlayerController : BRVideoPlayerController {
	int						padding[32];		/*!< @brief The classes are of different sizes.  This padding prevents a class compiled with one size to overlap when used with a class of a different size*/
	SapphireFileMetaData	*currentPlayFile;	/*!< @brief The file we are playing*/
	int						soundState;			/*!< @brief Sound state before we played the current file*/
}

/*!
 * @brief Creates the controller for a player
 *
 * @param scene The scene
 * @param player The player
 * @return the controller
 */
- (id)initWithScene:(id)scene player:(SapphireVideoPlayer *)player;

/*!
 * @brief Set the currently playing file metadata
 *
 * @param file The file's metadata
 */
- (void)setPlayFile:(SapphireFileMetaData *)file;

@end

int enablePassthrough(SapphireFileMetaData *currentPlayFile);
void teardownPassthrough(int soundState);
