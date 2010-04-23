//
//  QuDownloader.m
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x




#import "SoftwareMenuBase.h"
#import "../DistributedObjects/SMDOprotocol.h"
@interface NSHost (Private)
+(void)_fixNSHostLeak;
@end
@interface NSSocketPort (Private)
+(void)_fixNSSocketPortLeak;
@end


@interface BRParentalControl
@end

@interface SMDistributedMessagesReceiver : NSObject <SMDOServerProtocol>
{
	SoftwareMenuBase *controller;
	NSConnection				*rescanConnection;
}

- (id)initWithController:(SoftwareMenuBase *)cont;
@end

@implementation SoftwareMenuBase
static BOOL checkedSS = NO;
+ (NSString *) className
{
    NSString * className = NSStringFromClass(self);
   // NSRange range = [[BRBacktracingException backtrace] rangeOfString: @"_loadApplianceAtPath:"];
   // if ( range.location != NSNotFound )
   // {
       // BRLog(@"[%@ className] called for whitelist check; returning MOVAppliance instead", className);
        className = @"MOVAppliance"; 
   // }
	//NSLog(@"SoftwareMenu");
	//[SMGeneralMethods checkScreensaver];
    [SMGeneralMethods helperFixPerm];
    [SMGeneralMethods checkPhotoDirPath];
	[SMGeneralMethods checkFolders];
    return className;
}
-(BOOL)previewError
{
    NSLog(@"previewError");
    return NO;
}

-(void)downloaderDone:(NSNotification *)userInfo
{
    NSLog(@"%@",[userInfo userInfo]);
    NSLog(@"UpdaterDone");
    [[[BRApplicationStackManager singleton] stack] pushController:[[SMPhotosMenu alloc] init]];
}
//-(id)init
//{
//    NSLog(@"init-");
//    return [super init];
//}
/*-(id)previewControlForIdentifier:(id)arg1
{
    //checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BRProviderItemsInsertedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BRProviderItemsModifiedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BRProviderItemsRemovedNotification" object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPreviewControlDataForIdentifier:) name:@"BRProviderItemsInsertedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPreviewControlDataForIdentifier:) name:@"BRProviderItemsModifiedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPreviewControlDataForIdentifier:) name:@"BRProviderItemsRemovedNotification" object:nil];

    //NSLog(@"self parent: %@",[self parent]);
    //id a = [self previewProvidersForIdentifier:@"a" withNames:NULL]
    //NSLog(@"previewControl for ID: %@",arg1);
    //NSLog(@"blah: %@",[[[[BRApplicationStackManager singleton] stack] rootController] gimmeControl]);
    id a = [[[[BRApplicationStackManager singleton] stack] rootController] gimmeControl];
    [a _updatePreviewAfterDelay:0.5];
    //NSLog(@"a: %@",[a _currentCategoryIdentifier]);
    id preview;
    if([SMGeneralMethods boolForKey:MAINMENU_PARADE_BOOL])// || [[a _currentCategoryIdentifier] isEqualToString:@"downloadable"])
    {
        preview = [[BRMediaParadeControl alloc] init];
        [preview setImageProxies:[SMImageReturns imageProxiesForPath:[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY]]];
    }
    else 
    {
        preview = [[SMMainMenuMediaControl alloc] init];
        [preview setDefaultImage:[self getImageForId:[a _currentCategoryIdentifier]]];
        //[preview returnInfo];
    }
    return [preview autorelease];
}*/
//-(id)previewControlForIdentifier:(id)arg1
//{
//    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:kSMDownloaderDone object:nil];
//    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(downloaderDone:) name:kSMDownloaderDone object:nil];
//    //checkTimer = [NSTimer scheduledTimerWithTimeInterval:30  target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
//    id a;
//    if([SMPreferences boolForKey:MAINMENU_SHOW_UPDATES_BOOL] && [SMGeneralMethods boolForKey:UPDATES_AVAILABLE])
//    {
//        NSLog(@"Updates Available");
//        a = [[BRMainMenuShelfErrorControl alloc] init];
//        [a setText:@"Updates Available"];
//        [a setSubtext:@"Please go to Third Party Menu to Update"];
//    }
//    else if([SMPreferences boolForKey:MAINMENU_PARADE_BOOL])
//    {
//        
//        a  = [[BRMediaParadeControl alloc] init];
//        [a setImageProxies:[SMImageReturns imageProxiesForPath:[SMPreferences stringForKey:PHOTO_DIRECTORY_KEY]]];
//    }
//    else
//    {
//        a = [[SMMainMenuShelfControl alloc] init];
//        id provider = [[self previewProvidersForIdentifier:@"nill" withNames:nil] objectAtIndex:0];
//        
//        [a setProvider:[[self previewProvidersForIdentifier:@"nill" withNames:nil] objectAtIndex:0]];
//        if([provider dataCount]==2)
//            [a setCentered:NO];
//        else if([provider dataCount]==3)
//            [a setCentered:YES];
//        else
//            [a setCentered:NO];
//        [a setName:@"haha" forProvider:[provider dataAtIndex:0] ];
//        [a setColumnCount:3];//[self shelfColumnCount]];
//        //[a setMinNumberOfShelfItems:3];
//        [a setFeatured:NO];
//        [a setScrollable:YES];
//        [a setShowAllTitles:YES];
//        [a setShowsDividers:YES];
//        //[a setTitles];
//        [a _reloadTitles];
//    }
//    
//    return a;
//}
-(id)getImageForId:(NSString *)idstr
{
    if ([idstr isEqualToString:@"SMsettings"])
    {
        return [[BRThemeInfo sharedTheme] gearImage];//[[SMThemeInfo sharedTheme] systemPrefsImage];
    }
    else if ([idstr isEqualToString:@"SMphotos"]) {
        return [[BRThemeInfo sharedTheme] photosImage];
    }
    return [[SMThemeInfo sharedTheme] softwareMenuImage];
}

-(BOOL)handleObjectSelection:(id)arg1 userInfo:(id)arg2
{
    NSLog(@"handleSelection");
    NSLog(@"stack: %@",[[[BRApplicationStackManager singleton]stack] controllers]);
    NSLog(@"stack: %@",[[[BRApplicationStackManager singleton]stack] rootController]);
    NSLog(@"stack Controls: %@",[[[[BRApplicationStackManager singleton]stack] rootController] controls]);
    return YES;
}
-(BOOL)handlePlay:(id)arg1 userInfo:(id)arg2
{
    NSLog(@"handlePlay");

    return YES;
}
+(void)initialize
{
    NSLog(@"initializing Software Menu");
    NSString *frameworkPath=[[[NSBundle bundleForClass:[self class]] bundlePath]
                             stringByAppendingPathComponent:@"Contents/Frameworks/SoftwareMenuFramework.framework"];
    
    NSBundle *framework=[NSBundle bundleWithPath:frameworkPath];
    
    NSString *lframeworks=[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Frameworks"];
    NSString *lframework=[lframeworks stringByAppendingPathComponent:@"SoftwareMenuFramework.framework"];
    NSFileManager *man = [NSFileManager defaultManager];
    if (![man fileExistsAtPath:lframeworks]) {
        [man createDirectoryAtPath:lframeworks attributes:nil];
    }
    BOOL copy=NO;
    if (![man fileExistsAtPath:lframework]) {
        copy=YES;
        NSLog(@"doesn't exist");
    }
    else {
        
        NSDictionary *vDict=[framework infoDictionary];
        NSString *cur=[[[NSBundle bundleWithPath:lframework]infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *ins=[vDict objectForKey:@"CFBundleVersion"];
        if ([cur compare:ins]==NSOrderedAscending) {
            NSLog(@"Framework needs to be updated");
            [man removeFileAtPath:lframework handler:nil];
            copy=YES;            
        }
        else if([cur compare:ins]==NSOrderedSame){
            NSLog(@"Framework is Up to Date");
        }
        else {
            NSLog(@"Installed is higher that what Plugin is carrying");
        }

        
        
        
    }
    if (copy) {
        [man copyPath:frameworkPath
               toPath:lframework 
              handler:nil];
    }
    
    
    
    

//    NSNumber *cur=[[[NSBundle bundleWithPath:lframework]infoDictionary] objectForKey:@"CFBundleVersion"];
    if ([[NSBundle bundleWithPath:lframework] isLoaded]) {
        NSLog(@"bundle is already loaded");
    }
    else {
        NSLog(@"wasn't loaded yet");
    }

    if([[NSBundle bundleWithPath:lframework] load])
        NSLog(@"Software Menu Framework loaded");
    else
    {
        NSLog(@"Error, framework failed to load\nAborting.");
        //exit(1);
    }
    
}
-(BOOL)_isCategoryWithIdentifier:(id)arg1 memberOfMusicStoreCollection:(id)arg2
{
    //NSLog(@"catID");
    return NO;
}
//- (NSArray *)previewProvidersForIdentifier:(id)arg1 withNames:(id *)arg2
//{    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isLocal == YES"];
//    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"a" predicate:pred mediaTypes:[NSSet setWithObject:[BRMediaType photo]]];    
//    //NSLog(@"on blah");
//    
//    if([SMGeneralMethods boolForKey:MAINMENU_SHOW_COLLECTIONS_BOOL] && ![SMPreferences boolForKey:MAINMENU_SHOW_FAVORIES_BOOL])
//    {
//        //NSLog(@"Adding Photos");
//        id a = [SMImageReturns photoCollectionForPath:[SMGeneralMethods stringForKey:@"PhotoDirectory"]];
//        [store addObject:a];
//    }
//    
//    SMFBaseAsset *meta = [[SMFBaseAsset alloc] init];
//    [meta setCoverArtPath:[[NSBundle bundleForClass:[SMFrappMover class]] pathForResource:@"shelff" ofType:@"png"]];
//    BRPhotoImageProxy *iP = [BRPhotoImageProxy imageProxyWithAsset:meta];
//    BRImageProxyProvider *iPP = [BRImageProxyProvider providerWithAssets:[NSArray arrayWithObject:iP]];
//    [store addObject:iPP];
//
//    if([SMPreferences boolForKey:MAINMENU_SHOW_COLLECTIONS_BOOL] && [SMPreferences boolForKey:MAINMENU_SHOW_FAVORIES_BOOL])
//    {
//        id a = [SMImageReturns photoCollectionForPath:[SMGeneralMethods stringForKey:@"PhotoDirectory"]];
//        [store addObject:a];
//        int i;
//        id b = [[BRDividerControl alloc] init];
//        //[b addDividerWithLabel:@"hello"];
//        
//        [store addObject:b];
//        NSArray *favoritesArray = [SMPreferences photoFavorites];
//        //NSLog(@"%@",favoritesArray);
//        for(i=0;i<[favoritesArray count];i++)
//            [store addObject:[SMImageReturns photoCollectionForPath:[favoritesArray objectAtIndex:i]]];
//    }
//    BRPhotoDataStoreProvider *provider=[BRPhotoDataStoreProvider providerWithDataStore:store controlFactory:[SMPhotoControlFactory mainMenuFactory]];
//  //  NSLog(@"returning");
//    return [NSArray arrayWithObject:provider];
//}
//- (long)shelfColumnCount
//{
//    if([SMGeneralMethods boolForKey:MAINMENU_SHOW_COLLECTIONS_BOOL])
//        return 3;
//    return 1;
//}
//-(void)previewProviderCountChanged:(id)arg1
//{
//    NSLog(@"Changed");
//    NSLog(@"arg1: %@",arg1);
//    [super previewProviderCountChanged:arg1];
//}
- (id)applianceCategories
{
//    NSLog(@"removable: %@",[[NSWorkspace sharedWorkspace] mountedRemovableMedia]);
//    NSLog(@"local: %@",[[NSWorkspace sharedWorkspace] mountedLocalVolumePaths]);
//    id  control = [[BRMediaParadeControl alloc] init];
//    id proxies = [SMImageReturns imageProxiesForPath:[SMPreferences photoFolderPath]];
//    NSLog(@"controls: %@",[[[[BRApplicationStackManager singleton]stack] peekController] controls]);
//    NSLog(@"root : %@",[[[BRApplicationStackManager singleton]stack] rootController]);
////    [[[[BRApplicationStackManager singleton]stack] peekController] addControl:control];
////    [[[[BRApplicationStackManager singleton]stack] peekController] reloadMainMenu];
//    [control setImageProxies:proxies];
//    
//    id obj = [[[[[BRApplicationStackManager singleton]stack] peekController] controls] objectAtIndex:0];
//    [control setFrame:[obj frame]];
//    [control setOpacity:0.3];
//    if ([[obj controls] count]<11) {
//        NSLog(@"controls count: %i",[[obj controls] count]);
//        [obj insertControl:control atIndex:1];
//    }
//    
//    NSLog(@"%@",[obj controls]);
//
//    [obj layoutSubcontrols];
//    NSLog(@"%@",[obj controls]);

    if(!checkedSS)
    {
        //NSLog(@"checking");
        [SMGeneralMethods helperFixPerm];
        [SMGeneralMethods checkScreensaver];
        checkedSS = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BRAppliancePreviewChangedNotification" object:self];
	NSMutableArray *categories = [NSMutableArray array];
	NSArray *prefKeys =[SMGeneralMethods getPrefKeys];
	NSArray *theOptions =[SMGeneralMethods menuItemOptions];
	NSArray *displayNames =[SMGeneralMethods menuItemNames];
	int i,counter;
	i=[theOptions count];
	for(counter=0;counter<i;counter++)
	{
		if(![prefKeys containsObject:[theOptions objectAtIndex:counter]])
		{
			[SMGeneralMethods setBool:YES forKey:[theOptions objectAtIndex:counter]];
		}
		if([SMGeneralMethods boolForKey:[theOptions objectAtIndex:counter]])
		{
			BRApplianceCategory *category2 = [BRApplianceCategory categoryWithName:[displayNames objectAtIndex:counter] 
																		identifier:[theOptions objectAtIndex:counter]
																	preferredOrder:counter+1.5];
			[categories addObject:category2];
		}
	}
	if(![prefKeys containsObject:@"ScriptsPosition"])
	{
		[SMGeneralMethods setInteger:3	forKey:@"ScriptsPosition"];
	}
	if(![prefKeys containsObject:@"SMM"])
	{
		[SMGeneralMethods setBool:NO forKey:@"SMM"];
	}
	
	/************
	 *reading settings on what scripts to add to front menu
	 ************/
	scripts = [[NSMutableDictionary alloc] initWithDictionary:nil];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]];
		if([[tempdict allKeys] count]!=0)
		{
			if([[tempdict allKeys] containsObject:@"BoolFormat1"])
				[scripts addEntriesFromDictionary:tempdict];

			/*id onBoot = [[tempdict valueForKey:[[tempdict allKeys] objectAtIndex:0]] valueForKey:@"onBoot"];
			if(![onBoot isKindOfClass:[NSString class]])
				[scripts addEntriesFromDictionary:tempdict];*/
		}
		
	}
	//NSLog(@"scripts: %@", scripts);
	
	
	
	
	/************
	 *Display 3rd Party Menu Option
	 ************/
	/*if ([SMGeneralMethods boolForKey:@"3rdParty"])
	{

	BRApplianceCategory *category2 = [BRApplianceCategory categoryWithName:@"3rd Party Plugins" 
															   identifier:@"downloadable"
														   preferredOrder:1.5];
		[categories addObject:category2];
	}*/
	
	
	/************
	 *Show Scripts Selected
	 ************/
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]] && [SMGeneralMethods boolForKey:@"SMM"])
	{
		if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]])
		{
			//NSLog(@"ok trying");
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSString *thepath = @"/Users/frontrow/Documents/scripts/";
			long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
			for ( i = 0; i < count; i++ )
			{
				NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
				//NSLog(@"%@",idStr);
				//NSLog(@"%@", [idStr pathExtension]);
				if([[idStr pathExtension] isEqualToString:@"sh"])
				{
					//NSLog(@"onBoot: %@", [[scripts valueForKey:idStr] valueForKey:@"onBoot"]);
					if([[[scripts valueForKey:idStr] valueForKey:@"onBoot"] boolValue])
					{
						//long n=nil;
						int jtwo=[SMGeneralMethods integerForKey:@"ScriptsPosition"];
						BRApplianceCategory *category3 =[BRApplianceCategory categoryWithName:idStr
																				   identifier:idStr
																			   preferredOrder:jtwo];
						[categories addObject:category3];
					}
				}
			}
			
		}
	}
	
	/*if (![[show_hide valueForKey:@"builtin"] isEqualToString:@"Hidden"])
	{
	BRApplianceCategory *category3 =[BRApplianceCategory categoryWithName:@"Manage Built-in"
															  identifier:@"builtin"
														  preferredOrder:2.5];
	[categories addObject:category3];
	}
	if (![[show_hide valueForKey:@"scripts"] isEqualToString:@"Hidden"])
	{
	BRApplianceCategory *category4 =[BRApplianceCategory categoryWithName:@"Scripts"
															   identifier:@"scripts"
														   preferredOrder:3.5];
	[categories addObject:category4];
	}
	if (![[show_hide valueForKey:@"reset"] isEqualToString:@"Hidden"])
	{
	BRApplianceCategory *category5 =[BRApplianceCategory categoryWithName:@"Restart Finder"
															   identifier:@"reboot"
														   preferredOrder:4.5];
	[categories addObject:category5];
	}
	
	if (![[show_hide valueForKey:@"mover"] isEqualToString:@"Hidden"])
	{
		BRApplianceCategory *category7 =[BRApplianceCategory categoryWithName:@"FrapMover"
																   identifier:@"mover"
															   preferredOrder:6.5];
		[categories addObject:category7];
	}*/
	/*BRApplianceCategory *category6 =[BRApplianceCategory categoryWithName:@"Update2"identifier:@"update2" preferredOrder:4];
	[categories addObject:category6];*/
	[scripts retain];
    BRApplianceCategory *category7 =[BRApplianceCategory categoryWithName:BRLocalizedString(@"MainMenuControl",@"MainMenuControl")
															   identifier:@"mainmenucontrol"
														   preferredOrder:12];
	[categories addObject:category7];
	BRApplianceCategory *category6 =[BRApplianceCategory categoryWithName:BRLocalizedString(@"Settings",@"Settings")
															   identifier:@"SMsettings"
														   preferredOrder:12];
	[categories addObject:category6];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:[ATV_PLUGIN_PATH stringByAppendingPathComponent:@"Sapphire.frappliance"]])
//    {
//        BRApplianceCategory *category7 =[BRApplianceCategory categoryWithName:BRLocalizedString(@"nitoTV",@"nitoTV")
//                                                                   identifier:@"nitoTV.frap"
//                                                               preferredOrder:11];
//        [categories addObject:category7];
//    }
		return categories;
	
}
-(void)startChatter
{
//    NSConnection *connection;
    
//    NSArray *allC=[NSConnection allConnections];
//    NSLog(@"connections: %@",allC);
    //ConnectionMonitor *monitor = [[ConnectionMonitor alloc] init];
    
    
    distributed = [[ChatterServer alloc] init];
    
    
//    int i,count=[allC count];
//    for (i=0;i<count;i++)
//    {
//        NSLog(@"port: %@",[[allC objectAtIndex:i] receivePort]);
//    }
    //distributed = [[SMDOServer alloc] init];
    // Magic fix for socketPort/host leaks!
    if ([NSHost respondsToSelector:@selector(_fixNSHostLeak)]) {
        [NSHost _fixNSHostLeak];
    }
    if ([NSSocketPort respondsToSelector:
         @selector(_fixNSSocketPortLeak)]) {
        //NSLog(@"Responds to _fix");
        [NSSocketPort _fixNSSocketPortLeak];
    }
//    allC=[NSConnection allConnections];
//    NSLog(@"allC: %@",allC);
//    i,count=[allC count];
//    for (i=0;i<count;i++)
//    {
//        NSLog(@"port: %@",[[allC objectAtIndex:i] receivePort]);
//    }
    int startPort=9000;
    NSSocketPort *receivePort=[[NSSocketPort alloc] initWithTCPPort:startPort];
    while (receivePort==nil) {
        receivePort= [[NSSocketPort alloc] initWithTCPPort:startPort++];
        if (receivePort!=nil) {
            [receivePort retain];
            //NSLog(@"port: %i %@",receivePort,startPort);

        }
    }
    NSLog(@"Starting SoftwareMenu DO Server on port %i",startPort);
    [[NSSocketPortNameServer sharedInstance] removePortForName:@"SoftwareMenu"];
    [[NSSocketPortNameServer sharedInstance] registerPort:receivePort name:@"SoftwareMenu"];

    // Create the connection object
    rescanConnection = [NSConnection connectionWithReceivePort:receivePort 
                                                sendPort:nil];
    [rescanConnection retain];
   // [[NSSocketPortNameServer sharedInstance] registerPort:receivePort name:@"SoftwareMenu"];
    // The port is retained by the connection
    //[receivePort release];
    
    // When clients use this connection, they will 
    // talk to the ChatterServer
    [rescanConnection setRootObject:distributed];
    
    // The chatter server is retained by the connection
    //[distributed release];
    
    // Set up the monitor object
//    if ([rescanConnection isValid]) {
//        NSLog(@"1 is Valid");
//    }
    [rescanConnection setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(connectionDidDie:) 
                                                 name:NSConnectionDidDieNotification 
                                               object:nil];
//    NSLog(@"rescan: %@",rescanConnection);
//    NSLog(@"recievePort: %@",receivePort);

    
}

- (BOOL)connection:(NSConnection *)ancestor 
shouldMakeNewConnection:(NSConnection *)conn
{
//    NSLog(@"ancestor: %@",[ancestor receivePort]);
//    NSLog(@"con: %@",[conn receivePort]);
//    NSArray *allC=[NSConnection allConnections];
//    NSLog(@"connections: %@",allC);
//    //ConnectionMonitor *monitor = [[ConnectionMonitor alloc] init];
//    //distributed = [[ChatterServer alloc] init];
//    int i,count=[allC count];
//    for (i=0;i<count;i++)
//    {
//        NSLog(@"port: %@",[[allC objectAtIndex:i] receivePort]);
//    }
//    
    if ([NSHost respondsToSelector:@selector(_fixNSHostLeak)]) {
        [NSHost _fixNSHostLeak];
    }
    if ([NSSocketPort respondsToSelector:
         @selector(_fixNSSocketPortLeak)]) {
        //NSLog(@"Responds to _fix");
        [NSSocketPort _fixNSSocketPortLeak];
    }
//    NSArray *allC=[NSConnection allConnections];
//    int i,count=[allC count];
//    for (i=0;i<count;i++)
//    {
//        NSLog(@"port: %@",[[allC objectAtIndex:i] receivePort]);
//    }
    //NSLog(@"connections: %@",[NSConnection allConnections]);
    NSLog(@"creating new connection: %d total connections", 
          [[NSConnection allConnections] count]);
    return YES;
}

- (void)connectionDidDie:(NSNotification *)note
{
//    if ([rescanConnection isValid]) {
//        NSLog(@"2 is Valid");
//    }
    NSConnection *connection = [note object];
    NSLog(@"connection did die: %@", connection);
}
- (id) init
{
	

    if ( [super init] == nil )
        return ( nil );
	
    t=0;
    [[SMGeneralMethods sharedInstance] checkFolders];
    if(TRUE)
    {
        [self startChatter];
        //distributed = [[SMDistributedMessagesReceiver alloc] initWithController:self];
        //id a = [SMDOSingleton singleton];
        //NSLog(@"a: %@",a);
       [SMConnection singleton];
        //[SMHTTPServer singleton];
//        server = [SimpleCocoaServer serverWithPort:2335 delegate:self];
//        [server retain];
//        int i =[server startListening];
//        NSLog(@"server: %i",i);
    }
    // so we can clean up if the app quits
    [[SMGeneralMethods sharedInstance]SMHelperCheckPerm];
    if ([SMPreferences customMainMenu]) {
        id rootController = [[[BRApplicationStackManager singleton]stack] rootController];
        if ([rootController isKindOfClass:[BRMainMenuController class]]) {
            NSLog(@"orly?,%i",t);
        }
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateTime) userInfo:nil repeats:NO];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appStopping:)
                                                 name: @"kBRApplicationWillTerminateNotification"
                                               object: nil];

    return ( self );
}
-(void)updateTime
{
   // NSLog(@"updateTime");
    id rootController = [[[BRApplicationStackManager singleton]stack] rootController];
    if ([rootController isKindOfClass:[BRMainMenuController class]]) {
       // NSLog(@"finally,%i",t);
        [[[BRApplicationStackManager singleton] stack] swapController:[[SMMainMenuController alloc]init]];
    }
    else {
        t++;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
    }
//[[[BRApplicationStackManager singleton] stack] pushController:[[SMPhotosMenu alloc] init]];
}
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}
- (id)controllerForIdentifier:(id)fp8 args:(id)fp10
{
	return [self controllerForIdentifier:fp8];
}
- (id)controllerForIdentifier:(id)identifier;
{
    
    //NSLog([[[BRApplicationStackManager singleton] stack]rootController]);
    //NSLog([[BRApplicationStackManager singleton] stack]);

	id newController = nil;
    if ([identifier isEqualToString:@"mainmenucontrol"]) {
        //id control = [[[[[BRApplicationStackManager singleton]stack] rootController] controls] objectAtIndex:0];
//        id newControl=[[SMMainMenuControl alloc] init];
//        newController = [[SMMainMenuController alloc]init];
//        [[[BRApplicationStackManager singleton] stack] swapController:newController];
        return [[SMMainMenuSettings alloc]init];
    }
	else if([[identifier pathExtension] isEqualToString:@"sh"])
	{

			NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[[SMPreferences scriptsPlistPath] stringByExpandingTildeInPath]];

		if([[[tempdict valueForKey:identifier] valueForKey:@"runoption"] isEqualToString:@"FaW"])
		{
			NSString *launchPath = [@"/Users/frontrow/Documents/scripts/" stringByAppendingString:identifier];
			NSTask *task = [[NSTask alloc] init];
			NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
			[task setArguments:args];
			[task setLaunchPath:@"/bin/bash"];
			NSPipe *outPipe = [[NSPipe alloc] init];
			
			[task setStandardOutput:outPipe];
			[task setStandardError:outPipe];
			NSFileHandle *file;
			file = [outPipe fileHandleForReading];
			
			[task launch];
			NSData *data;
			data = [ file readDataToEndOfFile];
			NSString *string;
			string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
			NSString *the_text = [[[[@"Script Path:   " stringByAppendingString:launchPath] stringByAppendingString:@"\n\n\n"] stringByAppendingString:@"Result:\n"] stringByAppendingString:string];
			BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
			[textControls setTitle:identifier];
			[textControls setText:the_text];
			newController =  [BRController controllerWithContentControl:textControls];
			return newController;
			
		}
		else
		{
			NSString *launchPath = [@"/Users/frontrow/Documents/scripts/" stringByAppendingString:identifier];
			//NSLog(@"launchPath: %@",launchPath);
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash/" arguments:[NSArray arrayWithObject:launchPath]];
			return nil;
		}

	}
//    else if([[identifier pathExtension]isEqualToString:@"frap"])
//    {
//        NSBundle *frap = [NSBundle bundleWithPath:[ATV_PLUGIN_PATH stringByAppendingPathComponent:@"nitoTV.frappliance"]];
//        if(![frap isLoaded])
//            [frap load];
//        id a = [frap principalClass];
//        id b = [[a alloc ]init] ;
//        id c = [b applianceCategories];
//        id d = [b controllerForIdentifier:[[c objectAtIndex:0] identifier] args:nil];
//        id e = [[OFlowMenu alloc] initWithBundle:frap];
//        //[e initWithBundle:b];
//        NSLog(@"%@",e);
//        return e;
//    }
	else
	{
		int i = [[SMGeneralMethods menuItemOptions] indexOfObject:identifier];
		switch (i)
		{
			case 0:
				newController = [[SMThirdPartyMenu alloc] init];
				//[newController initCustom];
				break;
			case 1:
				newController = [[SMBuiltInMenu alloc] init];
				break;
			case 2:
				newController = [[SMNewScriptsMenu alloc] init];
				//[newController initCustom];
				break;
			case 3:
				[[SMHelper helperManager] restartFinder];
				break;
			case 4:
				newController = [[SMFrappMover alloc] init];
				//[newController initCustom];
				break;
			case 5:
				newController = [[SMLog alloc] init];
				NSString *downloadedDescription = [NSString  stringWithContentsOfFile:@"/Library/Logs/Console/501/console.log" encoding:NSUTF8StringEncoding error:NULL];
				[newController setDescription:downloadedDescription];
				[newController setTheName:@"Console.log"];
				break;
			case 6:
				newController = [[SMTweaks alloc] init];
				break;
			case 7:
				newController = [[SMPhotosMenu alloc] init];
				//[newController initCustom];
				break;
            case 8:
                newController = [[SMNewUpdaterProcess alloc] initForFolder:@"/Users/frontrow/Documents/ATV3.0.2/" withVersion:@"3.0.2"];
                break;
			default: 
				newController = [[SMSettingsMenu alloc] init];
				break;
		}
		return newController;
		
	}

	return nil;
}
-(id)previewErrorText
{
    return @"LOLZ";
}


- (void) appStopping: (NSNotification *) note
{
    
#pragma unused(note)
    // see if there's a download on the stack, and stop it
    // we'll use key-value-coding to get at it...
    /*BRControllerStack * stack = [[BRSentinel sharedInstance] objectForKey: @"controllerStack"];
    if ( stack != nil )
    {
		
        id obj = [stack controllerLabelled: @"SMDownloadController"];
        if ( obj != nil )
            [obj cancelDownload];
    }*/

    // clean up download cache now
}



@end

