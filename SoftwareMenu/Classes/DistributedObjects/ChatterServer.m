#import "ChatterServer.h"
#import "../Player/BRMediaPlayerController (SMExtensions).h"
#import "../Player/BRDescriptionOverlayControl-SMExt.h"
typedef enum _smRemoteTypes{
    kSMSRemote=0,
    kSMSSystem=1,
    kSMSPhotos=2,
    kSMSScripts=3,
    kSMSMainMenu=4,
    kSMSSapphire=5,
    kSMSMessage=6,
}smRemoteTypes;
#define WELCOME_MSG  0
#define ECHO_MSG     1
#define WARNING_MSG  2

#define READ_TIMEOUT 15.0
#define READ_TIMEOUT_EXTENSION 10.0

#define kSMSTYPE        @"Type"
#define kSMSACTION      @"Action"
#define kSMSMESSAGE     @"Message"
#define kSMSRETURN      @"Return"
#define kSMSTARGET      @"Target"


#define kSMSSCRIPTS     @"Scripts"
#define kSMSPHOTOS      @"Photos"
@class SapphireTVDirectory,nitoMPlayerController;
@implementation ChatterServer
- (id)init
{
    if (self = [super init]) {
        clients = [[NSMutableArray alloc] init];
        [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(check) userInfo:nil repeats:NO];
		connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];

        //NSLog(@"starting Check Timer");
    }
    return self;
}

-(void)check
{
   // NSLog(@"checking");
    int i,count=[clients count];
    for(i=0;i<count;i++)
    {
        id<ChatterUsing> cl = [clients objectAtIndex:i];
        @try {
            [cl test];
            //NSLog(@"client: %@ OK!",cl);
        }
        @catch (NSException * e) {
            NSLog(@"problem: %@",e);
            [self unsubscribeClient:cl];
        }
        @finally {
            
        }
        
    }
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(check) userInfo:nil repeats:NO];

}
-(BOOL)test
{
    return YES;
}
// Private method
- (id)clientWithNickname:(NSString *)string
{
    id currentClient;
    NSEnumerator *enumerator;
    enumerator = [clients objectEnumerator];
    while (currentClient = [enumerator nextObject]) {
        if ([[currentClient nickname] isEqual:string]) {
            return currentClient;
        }
    }
    return nil;
}

// Methods called by clients
- (oneway void)sendMessage:(in bycopy NSString *)message 
    fromClient:(in byref id <ChatterUsing>)client
{
    NSString *senderNickname;
    id currentClient;
    NSEnumerator *enumerator;
    senderNickname = [client nickname];
    enumerator = [clients objectEnumerator];
    NSLog(@"from %@: %@", senderNickname, message);
    while (currentClient = [enumerator nextObject]) {
        [currentClient showMessage:message fromNickname:senderNickname];
        NSLog(@"curr client: %@",currentClient);
        //[currentClient sendPlist:dict];
    }
}
- (oneway void)sendRequest:(in bycopy NSDictionary *)request fromClient:(in byref id<ChatterUsing>)client;
{
    NSLog(@"Request: %@",request);
    
    switch ([[request objectForKey:kSMSTYPE] intValue]) {
        case kSMSRemote:
            [self remoteEvent:request fromClient:client];
            break;
//        case kSMSScripts:
//            [self scriptEvent:inputDict fromConnection:con];
//            break;
//        case kSMSSystem:
//            [self systemEvent:inputDict fromConnection:con];
//            break;
//        case kSMSMainMenu:
//            [self mamenuEvent:inputDict fromConnection:con];
//            break;
        case kSMSSapphire:
            [self sapphireEvent:request fromClient:client];
            break;
        case kSMSMessage:
        {
            NSLog(@"Message");
            NSString *message= [request objectForKey:@"Message"];
            BRController * ctrl=[[[BRApplicationStackManager singleton ]stack]peekController];
            int i,count=[[ctrl controls] count];
            NSArray *controls = [ctrl controls];
            for(i=0;i<count;i++)
            {
                NSLog(@"control: %@",[controls objectAtIndex:i]);
                if ([[controls objectAtIndex:i] respondsToSelector:@selector(textField)]) {
                    NSLog(@"sending Message");
                    BRTextFieldControl *field = [(BRTextEntryControl *)[controls objectAtIndex:i]textField];
                    [field setString:message];
                    if ([[request objectForKey:@"Done"] boolValue]) {
                        [[field delegate] textDidEndEditing:field];
                    }

                    
                }
            }
            break;
        }
        case 35:
        {
            NSLog(@"test case");
            BRController * ctrl=[[[BRApplicationStackManager singleton ]stack]peekController];
            int i,count=[[ctrl controls] count];
            NSArray *controls = [ctrl controls];

            for(i=0;i<count;i++)
            {
                
                if ([[controls objectAtIndex:i] respondsToSelector:@selector(textField)]) {
                    NSLog(@"Setting text");
                    BRTextFieldControl *field = [(BRTextEntryControl *)[controls objectAtIndex:i]textField];
                    [field setString:@"hello"];
                    NSLog(@"field delegate: %@",[field delegate]);
                    [[field delegate] textDidEndEditing:field];
                }
            }
            
//            NSMutableDictionary *dict = [request mutableCopy];
//            [dict setObject:[NSNumber numberWithInt:35] forKey:kSMSACTION];
//            [self sapphireEvent:dict fromClient:client];
            break;

        }
        default:
            [client sendPlist:request];
    }
            
}
- (BOOL)subscribeClient:(in byref id <ChatterUsing>)newClient
{
    //NSString *newNickname = [newClient nickname];

    // Is this nickname taken?
    
//    if ([self clientWithNickname:newNickname]) {
//        [self unsubscribeClient:[self clientWithNickname:[newClient nickname]]];
//    }
//    NSLog(@"adding client");
//    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"one.plist"]];
//    NSLog(@"dict: %@",dict);
    NSDistantObject *clientProxy = (NSDistantObject *)newClient;
    NSConnection *connection = [clientProxy connectionForProxy];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionDidDie:)
                                                 name:NSConnectionDidDieNotification
                                               object:connection];
    [clients addObject:newClient];
    //[newClient sendPlist:dict];
    return YES;
}
- (void)remoteEvent:(NSDictionary *)dict fromClient:(id<ChatterUsing>)client
{
    int i=[[dict objectForKey:kSMSACTION]intValue];
    //    NSArray *values = [NSArray arrayWithObjects:
    //                       [NSNumber numberWithInt:kBREventRemoteActionDown],
    //                       [NSNumber numberWithInt:kBREventRemoteActionLeft],
    //                       [NSNumber numberWithInt:kBREventRemoteActionRight],
    //                       [NSNumber numberWithInt:kBREventRemoteActionPlay],
    //                       [NSNumber numberWithInt:kBREventRemoteActionMenu],
    //                       [NSNumber numberWithInt:kBREventRemoteActionUp],
    //                       nil
    //                       ];
    NSString *message=@"";
    switch (i) 
    {
        case 1:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapDown value:1];
            [[BREventManager sharedManager]postEvent:event];
            event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapDown value:0];
            [[BREventManager sharedManager]postEvent:event];
            //event=[BRHIDEvent eventWithPage:0 usage:kBREventActionTapDown value:0];
            //[[BREventManager sharedManager]postEvent:event];
            
            break;
        }
        case 6:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapUp value:1];
            [[BREventManager sharedManager]postEvent:event];
            event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapUp value:0];
            [[BREventManager sharedManager]postEvent:event];
            break;
        }
        case 2:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapLeft value:1];
            [[BREventManager sharedManager]postEvent:event];
            event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapLeft value:0];
            [[BREventManager sharedManager]postEvent:event];
            break;
        }  
        case 3:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapRight value:1];
            [[BREventManager sharedManager]postEvent:event];
            event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapRight value:0];
            [[BREventManager sharedManager]postEvent:event];
            break;
        }
        case 4:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapPlay value:1];
            [[BREventManager sharedManager]postEvent:event];
            //event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapPlay value:0];
            //[[BREventManager sharedManager]postEvent:event];
            break;
        }
        case 5:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapMenu value:1];
            [[BREventManager sharedManager]postEvent:event];
            //event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapMenu value:0];
            //[[BREventManager sharedManager]postEvent:event];
            break;
        }
        default:
            message=@"Remote Event not Recognized";
            
    }
}
#pragma mark IMAGE
- (bycopy NSData *)imageDataForPath:(NSString *)filepath
{
   return [NSData dataWithContentsOfFile:filepath]; 
}
#pragma mark SAPPHIRE
- (bycopy NSData *)sapphireImageDataForFile:(NSString *)filepath;
{
    if ([self sapphireIsInstalled]) {
        [self sapphireLoadMoc];
        SapphireFileMetaData *a =[SapphireFileMetaData fileWithPath:filepath inContext:_moc];
        NSString *coverPath = [a coverArtPath];
        if (coverPath!=nil) {
            return [NSData dataWithContentsOfFile:coverPath];
        }
        else {
            return nil;
        }
    }
    return nil;
}
- (bycopy NSDictionary *)sapphireTVDictionary
{
    if ([self sapphireIsInstalled]) {
        [self sapphireLoadMoc];
        
        id a = [[SapphireTVDirectory alloc] initWithContext:_moc];
        [a reloadDirectoryContents];
        NSArray *dir = [a directories];
        NSMutableDictionary *shows=[[NSMutableDictionary alloc]init];
        int i,j,k,count1,count2,count3=0;
        if ([dir count]!=0) 
        {
            count1=[dir count];
            for(i=0;i<count1;i++)
            {
                NSMutableDictionary *showDict=[[NSMutableDictionary alloc]init];
                id b= [a metaDataForDirectory:[dir objectAtIndex:i]];
                [b reloadDirectoryContents];
                NSArray *seasons = [b directories];
                if ([seasons count]!=0) 
                {
                    count2=[seasons count];
                    for(j=0;j<count2;j++)
                    {
                        NSMutableDictionary *seasonsDict = [[NSMutableDictionary alloc] init];
                        
                        id c = [b metaDataForDirectory:[seasons objectAtIndex:j]];
                        [c reloadDirectoryContents];
                        NSArray *files = [c files];
                        if ([files count]!=0) {
                            count3 = [files count];
                            NSMutableArray *filesA=[[NSMutableArray alloc]init];
                            for(k=0;k<count3;k++)
                            {
                                NSArray *array;
                                SapphireFileMetaData *f = [SapphireFileMetaData fileWithPath:[files objectAtIndex:k] inContext:_moc];
                                NSDictionary *dd=[f getDisplayedMetaDataInOrder:&array];
                                [filesA addObject:dd];
                                [dd release];
                            }
                            [seasonsDict setObject:filesA forKey:@"episodes"];
                        }
                        [seasonsDict setObject:files forKey:@"files"];
                        [showDict setObject:seasonsDict forKey:[seasons objectAtIndex:j]];
                        [seasonsDict release];
                    }
                }
                [shows setObject:showDict forKey:[dir objectAtIndex:i]];
                [showDict release];
            }
            
        }
        
        return [shows autorelease];
    }
    return [NSDictionary dictionary];
    
}
- (bycopy NSArray *)shows
{
    if ([self sapphireIsInstalled]) {
        [self sapphireLoadMoc];
        
        id a = [[SapphireTVDirectory alloc] initWithContext:_moc];
        [a reloadDirectoryContents];
        NSArray *dirs = [a directories];
        return dirs;
    }
    return [NSArray array];
}
- (bycopy NSArray *)seasonsForShow:(in bycopy NSString *)show
{
    if ([self sapphireIsInstalled]) {
        [self sapphireLoadMoc];
        
        id a = [[SapphireTVDirectory alloc] initWithContext:_moc];
        [a reloadDirectoryContents];
        NSArray *dirs = [a directories];
        int index = [dirs indexOfObject:show];
        if (index!=NSNotFound) {
            id c = [a metaDataForDirectory:show];
            dirs=[c directories];
            return dirs;
        }
    }
    return [NSArray array];
}
- (bycopy NSDictionary *)episodesForShow:(in bycopy NSString *)show forSeason:(in bycopy NSString *)season
{
    NSLog(@"episodesForShow:forSeason: not implemented yet");
    return nil;
}
- (bycopy NSDictionary *)sapphireMoviesList
{
    if ([self sapphireIsInstalled]) {
        
        [self sapphireLoadMoc];
        SapphireMovieDirectory *dir=[[SapphireMovieDirectory alloc] initWithContext:_moc];
        NSArray *files=[dir metaFiles];
        NSMutableArray *names = [[NSMutableArray alloc] init];
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        if ([files count]>0) {
            int i,ct=[files count];
            for(i=0;i<ct;i++)
            {   
                [names addObject:[[files objectAtIndex:i] prettyName]];
                [paths addObject:[[files objectAtIndex:i] path]];
            }
            
        }
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:names,@"names",paths,@"paths",nil];
        [names release];
        [paths release];
        return dict;
    }
    return [NSDictionary dictionary];
}
- (bycopy NSDictionary *)sapphireMoviesDictionary
{
    if ([self sapphireIsInstalled]) {
        [self sapphireLoadMoc];
        SapphireMovieDirectory *dir=[[SapphireMovieDirectory alloc] initWithContext:_moc];
        NSArray *files=[dir metaFiles];
        NSMutableArray *names = [[NSMutableArray alloc] init];
        NSMutableArray *paths = [[NSMutableArray alloc] init];
        NSMutableArray *dicts=[[NSMutableArray alloc]init];
        if ([files count]>0) {
            int i,ct=[files count];
            for(i=0;i<ct;i++)
            {   
                NSArray *array;
                NSDictionary *dd=[(SapphireFileMetaData *)[files objectAtIndex:i] getDisplayedMetaDataInOrder:&array];
                [names addObject:[[files objectAtIndex:i] prettyName]];
                [paths addObject:[[files objectAtIndex:i] path]];
                [dicts addObject:dd];            
            }
            
        }
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:dicts,@"Movies",names,@"names",paths,@"paths",nil];
        [dicts release];
        [names release];
        [paths release];
        return dict;
    }
    return [NSDictionary dictionary];

}
- (bycopy NSDictionary *)sapphireMovieInfoForPath:(NSString *)path
{
    return [NSDictionary dictionary];
}
- (bycopy NSDictionary *)sapphireInfoForMovie:(NSString *)movie
{
    return [NSDictionary dictionary];
}
- (void)sapphireLoadMoc
{
    if([self sapphireIsInstalled])
    {
        if (_moc == nil) {
            NSDictionary *storeOptions =[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], NSReadOnlyPersistentStoreOption, nil];
            _moc = [SapphireApplianceController newManagedObjectContextForFile:nil withOptions:nil];
            [storeOptions release]; 
            [_moc retain];
        }  
    }

}
- (void)sapphireEvent:(NSDictionary *)inputDict fromClient:(id<ChatterUsing>)client
{
    if (_moc == nil) {
        NSDictionary *storeOptions =[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], NSReadOnlyPersistentStoreOption, nil];
        _moc = [SapphireApplianceController newManagedObjectContextForFile:nil withOptions:nil];
        [storeOptions release]; 
        [_moc retain];
    }
    NSLog(@"input:%@",inputDict);
    [client showMessage:[NSString stringWithFormat:@"%@",inputDict,nil] fromNickname:@"hello"];
    switch ([[inputDict objectForKey:kSMSACTION]intValue]) {
        case 1:
        {
            SapphireMovieDirectory *dir=[[SapphireMovieDirectory alloc] initWithContext:_moc];
            NSArray *files=[dir metaFiles];
            NSMutableArray *names = [[NSMutableArray alloc] init];
            NSMutableArray *paths = [[NSMutableArray alloc] init];
            NSMutableDictionary *rdict=[[NSMutableDictionary alloc]init];
            NSMutableArray *dicts=[[NSMutableArray alloc]init];
            if ([files count]>0) {
                int i,ct=[files count];
                for(i=0;i<ct;i++)
                {   
                    NSArray *array;
                    NSDictionary *dd=[[files objectAtIndex:i] getDisplayedMetaDataInOrder:&array];
                    [names addObject:[[files objectAtIndex:i] prettyName]];
                    [paths addObject:[[files objectAtIndex:i] path]];
                    [dicts addObject:dd];
                    //[dicts addObject:dd];
                    
                }
                
            }
            [rdict setObject:@"Movies" forKey:@"Target"];
            [rdict setObject:names forKey:kSMSRETURN];
            [rdict setObject:paths forKey:@"Return2"];
            [rdict setObject:dicts forKey:@"Return3"];
            [rdict setObject:[NSNumber numberWithInt:0] forKey:kSMSACTION];
            //NSLog(@"dict: %@",dicts);
            [client sendPlist:rdict];
            //[self sendPlist:rdict toConnection:con];
            [rdict release];
            [names release];
            [dicts release];
            break;
            
        }
        case 2:
        {
            id tc = [[[BRApplicationStackManager singleton]stack] peekController];
            BOOL play=TRUE;
            if ([tc respondsToSelector:@selector(setPlayFile:)]) {
                NSString *assetID = [[[tc player] media] assetID];
                NSString *path = [[inputDict objectForKey:@"Movie"] lastPathComponent];
                if ([assetID isEqualToString:path]) {
                    play=FALSE;
                    id event=[BRHIDEvent eventWithPage:1 usage:137 value:1];
                    [[BREventManager sharedManager]postEvent:event];
                }
                else {
                    [[[BRApplicationStackManager singleton]stack] popController];
                }
            }
            if (play)
            {
                NSString *path = [inputDict objectForKey:@"Movie"];
                id a =[SapphireFileMetaData fileWithPath:path inContext:_moc];
                NSURL *url = [NSURL fileURLWithPath:path];
                SapphireMedia *asset  =[[SapphireMedia alloc] initWithMediaURL:url];
                [asset setResumeTime:[a resumeTimeValue]];
                SapphireVideoPlayer *player = [[SapphireVideoPlayer alloc] init];
                NSError *error = nil;
                [player setMedia:asset error:&error];
                SapphireVideoPlayerController *controller = [[SapphireVideoPlayerController alloc] initWithScene:nil player:player];
                [controller setPlayFile:a];
                [controller setAllowsResume:YES];
                [[[BRApplicationStackManager singleton] stack] pushController:controller];
                
                [asset release];
                [player release];
                [controller release];    
            }
            break;
            
        }
                    case 3:
        {
            NSString *path = [inputDict objectForKey:@"Movie"];
            SapphireFileMetaData *a =[SapphireFileMetaData fileWithPath:path inContext:_moc];
            NSString *coverPath = [a coverArtPath];
            //NSLog(@"coverArtPath = %@",coverPath);
            NSImage *img = [[NSImage alloc] initWithContentsOfFile:coverPath];
            NSMutableDictionary *rdict = [inputDict mutableCopy];
            NSData *data = [NSData dataWithContentsOfFile:coverPath];
            [client sendImage:data withInfo:rdict];
            //[rdict setObject:[img TIFFRepresentation] forKey:kSMSRETURN];
            [rdict setObject:[NSNumber numberWithBool:TRUE] forKey:@"ImageFound"];
            //NSData *data = [NSData dataWithContentsOfFile:coverPath];
            [rdict setObject:data forKey:kSMSRETURN];
            //[client sendPlist:rdict];
            //[self sendPlist:rdict toConnection:con];
            //[self sendImage:img withDict:rdict toConnection:con];
            [img release];
            [rdict release];
            
            break;
            
        }
        case 36:
        {
            [client showMessage:@"test case 35" fromNickname:@"AppleTV"];
            NSLog(@"test case 35");
            id a = [[SapphireTVDirectory alloc] initWithContext:_moc];
            [a reloadDirectoryContents];
            NSLog(@"directories = %@",[a directories]);
            NSLog(@"TV: %@",[a metaFiles]);
            [client showMessage:[NSString stringWithFormat:@"%@",[a directories],nil] fromNickname:@"hello"];
            [client showMessage:[NSString stringWithFormat:@"%@",[a metaFiles],nil] fromNickname:@"hello"];
            
        }
        case 4:
        {
            [client showMessage:@"getting shows" fromNickname:@"AppleTV"];
            NSLog(@"test case 35");
            
            id a = [[SapphireTVDirectory alloc] initWithContext:_moc];
            [a reloadDirectoryContents];
            NSArray *dir = [a directories];
            NSMutableDictionary *shows=[[NSMutableDictionary alloc]init];
            int i,j,k,count1,count2,count3=0;
            if ([dir count]!=0) 
            {
                count1=[dir count];
                for(i=0;i<count1;i++)
                {
                    NSMutableDictionary *showDict=[[NSMutableDictionary alloc]init];
                    id b= [a metaDataForDirectory:[dir objectAtIndex:i]];
                    [b reloadDirectoryContents];
                    NSArray *seasons = [b directories];
                    if ([seasons count]!=0) 
                    {
                        count2=[seasons count];
                        for(j=0;j<count2;j++)
                        {
                            NSMutableDictionary *seasonsDict = [[NSMutableDictionary alloc] init];
                            
                            id c = [b metaDataForDirectory:[seasons objectAtIndex:j]];
                            [c reloadDirectoryContents];
                            NSArray *files = [c files];
                            if ([files count]!=0) {
                                count3 = [files count];
                                NSMutableArray *filesA=[[NSMutableArray alloc]init];
                                for(k=0;k<count3;k++)
                                {
                                    NSArray *array;
                                    SapphireFileMetaData *f = [SapphireFileMetaData fileWithPath:[files objectAtIndex:k] inContext:_moc];
                                    NSDictionary *dd=[f getDisplayedMetaDataInOrder:&array];
                                    [filesA addObject:dd];
                                    [dd release];
                                }
                                [seasonsDict setObject:filesA forKey:@"episodes"];
                            }
                            [seasonsDict setObject:files forKey:@"files"];
                            [showDict setObject:seasonsDict forKey:[seasons objectAtIndex:j]];
                            [seasonsDict release];
                        }
                    }
                    [shows setObject:showDict forKey:[dir objectAtIndex:i]];
                    [showDict release];
                }
                //                id b = [a metaDataForDirectory:[dir objectAtIndex:0]];
                //                [b reloadDirectoryContents];
                //                NSLog(@"Seasons: %@",[b directories]);
                //                NSArray *seas=[b directories];
                //                [client showMessage:[NSString stringWithFormat:@"%@",[b directories],nil] fromNickname:@"season"];
                //                if ([seas count]!=0) {
                //                    id c = [b metaDataForDirectory:[seas objectAtIndex:0]];
                //                    [c reloadDirectoryContents];
                //                    [client showMessage:[NSString stringWithFormat:@"%@",[c directories],nil] fromNickname:@"episodes"];
                //                    [client showMessage:[NSString stringWithFormat:@"%@",[c files],nil] fromNickname:@"episodes"];
                //                }
                
            }
            [shows writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"hello.plist"]   atomically:YES];
            NSDictionary *rdict=[[NSDictionary alloc] initWithObjectsAndKeys:shows,kSMSRETURN,@"TV",kSMSTARGET,[NSNumber numberWithInt:0],kSMSACTION,nil];
            [client sendPlist:rdict];
            [rdict release];
            //NSLog(@"shows: %@",shows);
            //[client showMessage:[NSString stringWithFormat:@"%@",shows,nil] fromNickname:@"hello"];
            [shows release];
            break;
        }
            
    }
    
}
#pragma mark SCRIPTS
- (bycopy NSArray *)scripts
{
    return [SMNewScriptsMenu scripts];
}

- (oneway void)runscript:(in bycopy NSString *)path asRoot:(BOOL)root displayOutput:(BOOL)output
{
    if (root) {
        [[SMHelper helperManager] runscript:path withOption1:nil withOption2:nil];
    }
    else {
        [SMNewScriptsMenu runScript:path displayResult:output];
    }

}
#pragma mark VIDEO
- (oneway void)playQTMovie:(in bycopy NSString *)path
{
    [self stopCurrentMovie];
    path = [path stringByExpandingTildeInPath];    
    NSURL *url = [NSURL fileURLWithPath:path];
    SMMovieAsset *asset  =[[SMMovieAsset alloc] initWithMediaURL:url];
    BRQTKitVideoPlayer *player = [[BRQTKitVideoPlayer alloc] init];
    NSError *error = nil;
    [player setMediaAtIndex:0 inTrackList:[NSArray arrayWithObject:asset] error:&error];
    BRMediaPlayerController *controller = [[BRMediaPlayerController alloc]initWithPlayer:player];
    [[[BRApplicationStackManager singleton] stack] pushController:controller];
}

- (oneway void)nitoTVPlayMovie:(in bycopy NSString *)path withMplayer:(BOOL)mplayer
{
    [self stopCurrentMovie];
    path=[path stringByExpandingTildeInPath];
    nitoMPlayerController *mpController = [[nitoMPlayerController alloc] initWithFile:path 
                                                                     playbackType:(mplayer?1:3)
                                                                      titleNumber:0 
                                                                       isShuffled:NO 
                                                                       withRepeat:0];
    
    [[[BRApplicationStackManager singleton]stack]pushController:mpController];
    [mpController release];
}
-(oneway void)sapphirePlayMovie:(in bycopy NSString *)path
{
    id tc = [[[BRApplicationStackManager singleton]stack] peekController];
    BOOL play=TRUE;
    if (![tc isKindOfClass:[SapphireVideoPlayerController class]]) {
        [self stopCurrentMovie];
    }
    else {
        NSString *assetID = [[[tc player] media] assetID];
        NSString *file = [path lastPathComponent];
        if ([assetID isEqualToString:file]) {
            play=FALSE;
            id event=[BRHIDEvent eventWithPage:1 usage:137 value:1];
            [[BREventManager sharedManager]postEvent:event];
        }
        else {
            [[[BRApplicationStackManager singleton]stack] popController];
        }
    }

    if (play)
    {
        [self sapphireLoadMoc];
        path = [path stringByExpandingTildeInPath];
        SapphireFileMetaData* a =[SapphireFileMetaData fileWithPath:path inContext:_moc];
        NSURL *url = [NSURL fileURLWithPath:path];
        SMMovieAsset *asset  =[[SMMovieAsset alloc] initWithMediaURL:url];
        [asset setResumeTime:[a resumeTimeValue]];
        if ([a prettyName]!=nil) {
            [asset setTitle:[a prettyName]];
        }
        else
        {
            [asset setTitle:[a fileName]];
        }
        NSArray *order;
        NSDictionary *dict = [a getDisplayedMetaDataInOrder:&order];
        NSString *sum=[dict objectForKey:@"Plot"];
        if (sum==nil) 
            sum=[dict objectForKey:@"Show Description"];
        if(sum==nil)
            sum=[dict objectForKey:@"Summary"];
        if(sum!=nil)
            [asset setObject:sum forKey:@"mediaSummary"];
        else
            [asset setObject:@"." forKey:@"mediaSummary"];
        
        [asset setCoverArtPath:[a coverArtPath]];
        SapphireVideoPlayer *player = [[SapphireVideoPlayer alloc] init];
        NSError *error = nil;
        [player setMedia:asset error:&error];
        SapphireVideoPlayerController *controller = [[SapphireVideoPlayerController alloc] initWithScene:nil player:player];
        [controller setPlayFile:a];
        [controller setAllowsResume:YES];
        [[[BRApplicationStackManager singleton] stack] pushController:controller];
        
        [asset release];
        [player release];
        [controller release]; 
    }
}
#pragma mark PHOTO
- (oneway void)slideshowForPath:(in bycopy NSString *)path
{
    [self stopCurrentMovie];
    path=[path stringByExpandingTildeInPath];
    BOOL isDir=NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]&&isDir) {
        [SMPhotosMenu startSlideshowForPath:path];
    }
}
- (oneway void)startScreensaver;
{
    [[ATVScreenSaverManager singleton] showScreenSaver];
}
- (bycopy NSArray *)slideshowFavorites
{
    return [SMPreferences photoFavorites];
}
- (oneway void)setSlideshowPath:(in bycopy NSString *)path
{
    [SMPreferences setString:path forKey:PHOTO_DIRECTORY_KEY];
}
#pragma mark CLEANING
-(void)stopCurrentMovie
{
    NSLog(@"controllers: %@",[[[BRApplicationStackManager singleton]stack]controllers]);
    id tf = [[[BRApplicationStackManager singleton]stack]peekController];
    NSLog(@"tf: %@",tf);
    if ([tf isKindOfClass:[nitoMPlayerController class]]) {
        NSLog(@"popping ntv media controller");
        id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapMenu value:1];
        [[BREventManager sharedManager]postEvent:event];
        
    }
    if ([tf isKindOfClass:[BRMediaPlayerController class]]) {
        NSLog(@"popping normal controller");
        [[[BRApplicationStackManager singleton]stack] popController];
    }
    
    if ([tf isKindOfClass:[SMPhotoBrowserController class]]) {
        NSLog(@"popping PhotoBrowser");
        //[[BRMediaPlayerManager singleton]_removeShroudWindow];
        [[BRMediaPlayerManager singleton] endPresentation];
        [[BRMediaPlayerManager singleton] removePresentation];
        [[[BRApplicationStackManager singleton]stack] popController];
        //        id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapMenu value:1];
        //        
        //        [[BREventManager sharedManager]postEvent:event];
        //        tf = [[[BRApplicationStackManager singleton]stack]peekController];
        //        if ([tf isKindOfClass:[SMPhotoBrowserController class]]) {
        //            NSLog(@"popping Really PhotoBrowser");
        //            [[[BRApplicationStackManager singleton]stack] popController];
        //        }
    }
}
#pragma mark NETWORK
-(BOOL)mountNetworkDrive:(in bycopy NSDictionary *)information softLink:(in BOOL)link
{
    NSString *string;
    BOOL returnVal=[[SMGeneralMethods sharedInstance] mountManualPointWithDictionary:information softLink:link returnString:&string];
    if (returnVal) {
        NSLog(@"drive mounted");
        return TRUE;
    }
    else {
        NSLog(@"drive not mounted: \n%@",string);
        return FALSE;
    }
}
-(bycopy NSDictionary *)ntvMounts
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/nito/mounts.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return [NSDictionary dictionary];
}

#pragma mark SYSTEM

-(bycopy NSDictionary *)testing;
{
    //NSLog(@"mounts: %@",[[SMGeneralMethods sharedInstance] availableBonjourMounts]);
    return [NSDictionary dictionaryWithObject:@"NOTING" forKey:@"object"];
    
}
-(oneway void)remoteActionForEvent:(int)event
{
    switch (event) {
        case kBREventActionTapRight:
        case kBREventActionTapLeft:
        case kBREventActionTapUp:
        case kBREventActionTapDown:
        {
            BRHIDEvent* eventProper=[BRHIDEvent eventWithPage:1 usage:event value:1];
            [[BREventManager sharedManager]postEvent:eventProper];
            eventProper=[BRHIDEvent eventWithPage:1 usage:event value:0];
            [[BREventManager sharedManager]postEvent:eventProper];
            break;
        }

        case kBREventActionTapMenu:
        case kBREventActionTapPlay:
        {
            BRHIDEvent* eventProper=[BRHIDEvent eventWithPage:1 usage:event value:1];
            [[BREventManager sharedManager]postEvent:eventProper];
            break;
        }

        default:
            break;
    }
}
-(oneway void)remoteAction:(NSDictionary *)dict
{
    int i=[[dict objectForKey:kSMSACTION]intValue];
    //    NSArray *values = [NSArray arrayWithObjects:
    //                       [NSNumber numberWithInt:kBREventRemoteActionDown],
    //                       [NSNumber numberWithInt:kBREventRemoteActionLeft],
    //                       [NSNumber numberWithInt:kBREventRemoteActionRight],
    //                       [NSNumber numberWithInt:kBREventRemoteActionPlay],
    //                       [NSNumber numberWithInt:kBREventRemoteActionMenu],
    //                       [NSNumber numberWithInt:kBREventRemoteActionUp],
    //                       nil
    //                       ];
    NSString *message=@"";
    switch (i) 
    {
        case 1:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapDown value:1];
            [[BREventManager sharedManager]postEvent:event];
            event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapDown value:0];
            [[BREventManager sharedManager]postEvent:event];
            //event=[BRHIDEvent eventWithPage:0 usage:kBREventActionTapDown value:0];
            //[[BREventManager sharedManager]postEvent:event];
            
            break;
        }
        case 6:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapUp value:1];
            [[BREventManager sharedManager]postEvent:event];
            event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapUp value:0];
            [[BREventManager sharedManager]postEvent:event];
            break;
        }
        case 2:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapLeft value:1];
            [[BREventManager sharedManager]postEvent:event];
            event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapLeft value:0];
            [[BREventManager sharedManager]postEvent:event];
            break;
        }  
        case 3:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapRight value:1];
            [[BREventManager sharedManager]postEvent:event];
            event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapRight value:0];
            [[BREventManager sharedManager]postEvent:event];
            break;
        }
        case 4:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapPlay value:1];
            [[BREventManager sharedManager]postEvent:event];
            //event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapPlay value:0];
            //[[BREventManager sharedManager]postEvent:event];
            break;
        }
        case 5:
        {
            id event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapMenu value:1];
            [[BREventManager sharedManager]postEvent:event];
            //event=[BRHIDEvent eventWithPage:1 usage:kBREventActionTapMenu value:0];
            //[[BREventManager sharedManager]postEvent:event];
            break;
        }
        default:
            message=@"Remote Event not Recognized";
            break;
            
    }
}

//    NSLog(@"method remoteAction: is not implemented yet");

-(BOOL)nitoTVIsInstalled
{
    Class klass = NSClassFromString(@"nitoMPlayerController");
    if (klass!=nil) {
        return YES;
    }
    return NO;
}
-(BOOL)sapphireIsInstalled
{
    Class klass = NSClassFromString(@"SapphireFileMetaData");
    if (klass!=nil) {
        return YES;
    }
    return NO;
}




#pragma mark FILES
-(bycopy NSDictionary *)filesForFolder:(in bycopy NSString *)path
{
    NSString *finalpath=[path stringByExpandingTildeInPath];
    NSFileManager *man=[NSFileManager defaultManager];
    BOOL isDir;
    if ([man fileExistsAtPath:finalpath isDirectory:&isDir]&&isDir) {
        NSArray *files=[man directoryContentsAtPath:finalpath];
        NSMutableArray *folders=[[NSMutableArray alloc] init];
        int i,count=[files count];
        for(i=0;i<count;i++)
        {
            if([man fileExistsAtPath:[finalpath stringByAppendingPathComponent:[files objectAtIndex:i]] isDirectory:&isDir] &&isDir)
                [folders addObject:[NSNumber numberWithBool:TRUE]];
            else {
                [folders addObject:[NSNumber numberWithBool:FALSE]];
            }

        }
        return [NSDictionary dictionaryWithObjectsAndKeys:files,@"files",folders,@"folder",nil];
    }
    else 
        return nil;
}
- (void)unsubscribeClient:(in byref id <ChatterUsing>)client
{
    NSDistantObject *clientProxy = (NSDistantObject *)client;
    NSConnection *connection = [clientProxy connectionForProxy];
    [clients removeObject:client];
    [connection invalidate];
    //NSLog(@"client removed");
}
-(void)connectionDidDie:(NSNotification *)note
{
    NSLog(@"note: %@",note);
}
- (void)dealloc
{
    [clients release];
    [super dealloc];
}
@end
















