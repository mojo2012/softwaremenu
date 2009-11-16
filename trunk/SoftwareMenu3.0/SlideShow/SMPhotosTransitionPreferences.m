//
//  SMSlideShowTransitionPreferences.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/3/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//




@implementation SMPhotosTransitionPreferences
-(id)init
{
    self=[super init];
    [[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Transitions",@"Transitions")];
    [self setListIcon:[[BRThemeInfo sharedTheme] photoSettingsImage] horizontalOffset:0.5f kerningFactor:0.2f];
    transitions=[[BRSettingsFacade singleton] slideshowTransitionNames];
    [transitions retain];
    _items = [[NSMutableArray alloc] initWithObjects:nil];
    //NSLog(@"%@",transitions);
    [self initCustom];
    return self;
}
-(id)initCustom
{
	[_items removeAllObjects];
	int i,counter;
	i=[transitions count];
	for(counter=0;counter<i;counter++)
	{
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc]init];
		[item setTitle:[transitions objectAtIndex:counter]];
		[_items addObject:item];
		
	}
	id list = [self list];
	[list setDatasource: self];
    //[[self list] reload];
	return self;
}
-(void)itemSelected:(long)row
{
    [[BRSettingsFacade singleton] setSlideshowSelectedTransitionName:[transitions objectAtIndex:row]];
}
-(void)dealloc
{
    [transitions release];
    [_items release];
    [super dealloc];
}
-(void)controlWasActivated
{
    [self initCustom];
    [super controlWasActivated];
}
@end
@implementation SMSlideShowPlaylistPreferences
-(id)init
{
    self=[super init];
	[self setListTitle: BRLocalizedString(@"Playlists",@"Playlists")];
    [transitions release];
    transitions=[[BRSettingsFacade singleton] slideshowPlaylists];
    [transitions retain];
    [self initCustom];
    return self;
}
-(void)itemSelected:(long)row
{
    [[BRSettingsFacade singleton] setSlideshowSelectedPlaylistName:[transitions objectAtIndex:row]];
}
@end