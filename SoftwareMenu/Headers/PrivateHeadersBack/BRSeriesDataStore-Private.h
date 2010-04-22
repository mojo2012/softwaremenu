/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRSeriesDataStore.h>

@interface BRSeriesDataStore (Private)
- (id)_initWithSeriesTypes:(id)arg1 seriesName:(id)arg2 dataStoreType:(int)arg3;
- (id)_aggregateSeries:(id)arg1 aggregate:(id)arg2 sortByDate:(BOOL)arg3;
- (id)_mediaTypePredicate;
- (id)_seriesPredicate;
- (id)_labelForSeason:(int)arg1;
- (id)_sortResultsByDate:(id)arg1;
- (id)_filteredSeriesFrom:(id)arg1;
- (id)_groupEpisodesIntoSeries:(id)arg1 filterOutWatched:(BOOL)arg2 sortByDate:(BOOL)arg3;
- (id)_groupSeriesIntoSeasons:(id)arg1 filterOutWatched:(BOOL)arg2;
- (id)_primaryCollectionTitlesFromData:(id)arg1;
- (void)_handleObjectModifiedForMostRecentUnwatchedDataStore:(id)arg1;
- (void)_postInsertionRemovalNotifcationsComparingOldData:(id)arg1 withNewData:(id)arg2;
@end
