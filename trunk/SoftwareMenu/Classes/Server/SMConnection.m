//
//  SMConnection.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/7/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMConnection.h"
typedef enum _smRemoteTypes{
    kSMSRemote=0,
    kSMSSystem=1,
    kSMSPhotos=2,
    kSMSScripts=3,
    kSMSMainMenu=4,
}smRemoteTypes;
//typedef enum {
//	
//	kBREventActionTapMenu = 134,
//	kBREventActionTapPlay = 137,
//	kBREventActionTapRight = 138,
//	kBREventActionTapLeft = 139,
//	kBREventActionTapUp = 140,
//	kBREventActionTapDown = 141,
//	kBREventActionTapPlayNew = 205,
//	
//	kBREventActionHoldMenu = 64,
//	kBREventActionHoldRight = 179,
//	kBREventActionHoldLeft = 180,
//	
//} BREventRemoteActions;
#define kSMSTYPE        @"Type"
#define kSMSACTION      @"Action"
#define kSMSMESSAGE     @"Message"
#define kSMSRETURN      @"Return"
#define kSMSTARGET      @"Target"


#define kSMSSCRIPTS     @"Scripts"
#define kSMSPHOTOS      @"Photos"
#define MEXT_PATH   [ATV_PLUGIN_PATH stringByAppendingPathComponent:@"SoftwareMenu.frappliance/Contents/Mextensions/"]
@class SapphireMetaDataSupport,SapphireMedia,SapphireVideoPlayerController,SapphireVideoPlayer,SapphireApplianceController,SapphireFileMetaData,SapphireMovieDirectory;
@implementation SMConnection
static SMConnection *singleton = nil;

+ (SMConnection*)singleton
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self singleton] retain];
}
-(id)init
{
    self=[super init];
    server = [SimpleCocoaServer serverWithPort:2335 delegate:self];
    [server retain];
    [server startListening];
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (int)retainCount
{
    return 15000;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
-(NSDictionary *)getDictForData:(NSData *)data
{
    NSPropertyListFormat format;
    return [NSPropertyListSerialization propertyListFromData:data 
                                            mutabilityOption:NSPropertyListImmutable 
                                                      format:&format 
                                            errorDescription:nil];
    
}
- (void)sendPlist:(NSDictionary *)output toConnection:(SimpleCocoaConnection *)con
{
    NSData *rdata=[NSPropertyListSerialization dataFromPropertyList:output
                                                             format:NSPropertyListBinaryFormat_v1_0
                                                   errorDescription:nil];
    [server sendData:rdata toConnection:con];
}
- (void)sendMessage:(NSString *)message toConnection:(SimpleCocoaConnection *)con
{
    [self sendPlist:[NSDictionary dictionaryWithObjectsAndKeys:
                     message,kSMSMESSAGE,
                     [NSNumber numberWithInt:20],kSMSTYPE,
                     nil]
       toConnection:con];
}
- (void)remoteEvent:(NSDictionary *)dict fromConnection:(SimpleCocoaConnection *)con
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
//            
//            
//        
//        case 2:
//        case 3:
//        {
//            int value=[[values objectAtIndex:(i-1)] intValue];
//            id event = [BREvent eventWithAction:value value:1];
//            [[BREventManager sharedManager]postEvent:event];
//            //[event release];
//            event = [BREvent eventWithAction:value value:0];
//            [[BREventManager sharedManager]postEvent:event];
//            //[event release];
//            message=[NSString stringWithFormat:@"Event with Key: %i posted",value,nil];
//            break;
//        }
//        case 4:
//        case 5:
//        {
//            int value=[[values objectAtIndex:(i-1)] intValue];
//            id event = [BREvent eventWithAction:value value:1];
//            [[BREventManager sharedManager]postEvent:event];
//            //[event release];
//            message=[NSString stringWithFormat:@"Event with Key: %i posted",value,nil];
//            break;
//            
//        }
        default:
            message=@"Remote Event not Recognized";
            
    }
    [self sendMessage:message toConnection:con];
}
-(void)photosEvent:(NSDictionary *)dict fromConnection:(SimpleCocoaConnection *)con
{
    switch ([[dict objectForKey:kSMSACTION]intValue]) 
    {
        case 0:
            [SMPhotosMenu startSlideshow];
            break;
        case 1:
            [[ATVScreenSaverManager singleton] showScreenSaver];
            break;
        case 2:
        {
            
            break;
        }
        default:
            break;
    }
}
-(void)mamenuEvent:(NSDictionary *)dict fromConnection:(SimpleCocoaConnection *)con
{
    switch ([[dict objectForKey:kSMSACTION]intValue]) 
    {
        case 0:
            [SMPhotosMenu startSlideshow];
            break;
        case 1:
        {
            NSDictionary *options = [dict objectForKey:@"Options"];
            NSArray *keys = [options allKeys];
            if ([keys containsObject:@"CMM"]) {
                [SMPreferences setCustomMainMenu:[[dict objectForKey:@"CMM"]boolValue]];
            }
            if ([keys containsObject:@"BlockPreview"]) {
                [SMPreferences setMainMenuBlockPreview:[[dict objectForKey:@"BlockPreview"]boolValue]];
            }
            if ([keys containsObject:@"SelectPlugin"]) {
                [SMPreferences setSelectedExtension:
                 [MEXT_PATH stringByAppendingFormat:@"%@.mext",[options objectForKey:@"SelectPlugin"],nil]];
            }
            if ([keys containsObject:@"EdgeFade"]) {
                [SMPreferences setMainMenuEdgeFade:[[dict objectForKey:@"EdgeFade"]boolValue]];
            }
            
            break;
        }
            
        case 2:
        {
            break;
        }
        case 3:
            NSLog(@"root Controller: %@",[[[BRApplicationStackManager singleton] stack] rootController]);
                id newController = [[SMMainMenuController alloc]init];
                [[[BRApplicationStackManager singleton] stack] replaceAllControllersWithController:newController];
            break;
        default:
            break;
    }
    
}
-(void)scriptEvent:(NSDictionary *)dict fromConnection:(SimpleCocoaConnection *)con
{
    
    NSMutableDictionary *rdict=[[NSMutableDictionary alloc]init];
    switch ([[dict objectForKey:kSMSACTION]intValue]) {
        case 0:         //Get Scripts
            [rdict setObject:[dict objectForKey:kSMSACTION] forKey:kSMSACTION];
            [rdict setObject:[dict objectForKey:kSMSTYPE] forKey:kSMSTYPE];
            [rdict setObject:[SMScriptsMenu scripts] forKey:kSMSRETURN];
            [rdict setObject:kSMSSCRIPTS forKey:kSMSTARGET];
            [self sendPlist:rdict toConnection:con];
            break;
        case 1:         //Run Script as Root
        {
            NSString *scriptsPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Scripts"];
            [[SMHelper helperManager] runscript:[scriptsPath stringByAppendingPathComponent:[dict objectForKey:@"Name"]]
                                    withOption1:nil 
                                    withOption2:nil];
            [self sendMessage:[NSString stringWithFormat:@"Running script: %@ as root",[dict objectForKey:@"Name"],nil]
                 toConnection:con];
            
           break; 
        }
        case 2:         //Run Script
        {
            NSString *scriptsPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Scripts"];
            [SMScriptsMenu runScript:[scriptsPath stringByAppendingPathComponent:[dict objectForKey:@"Name"]] 
                       displayResult:[[dict objectForKey:@"Display"]boolValue]];
            [self sendMessage:[NSString stringWithFormat:@"Running script: %@ as root",[dict objectForKey:@"Name"],nil]
                 toConnection:con];
        }
            
        default:
            break;
    }
    [rdict release];
}
-(void)systemEvent:(NSDictionary *)dict fromConnection:(SimpleCocoaConnection *)con
{
    switch ([[dict objectForKey:kSMSACTION]intValue]) {
        case 0:
            [self sendMessage:@"Restarting the Finder" toConnection:con];
            [[SMHelper helperManager] restartFinder];
            break;
        case 1:
            [self sendMessage:@"Rebooting" toConnection:con];
            [[SMHelper helperManager]reboot];
            break;
        case 2:
            [self sendMessage:@"Updating" toConnection:con];
            //[[SMHelper helperManager]launchUpdateWithFolder:@"/Users/frontrow/Updates"];
            break;
        default:
            break;
    }
}
//- (void)sapphireEvent:(NSDictionary *)inputDict fromConnection:(SimpleCocoaConnection *)con
//{
//    if (_moc == nil) {
//        NSDictionary *storeOptions =[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO], NSReadOnlyPersistentStoreOption, nil];
//        _moc = [SapphireApplianceController newManagedObjectContextForFile:nil withOptions:nil];
//        [storeOptions release]; 
//        [_moc retain];
//    }
//
//  
//    switch ([[inputDict objectForKey:kSMSACTION]intValue]) {
//        case 1:
//        {
//            SapphireMovieDirectory *dir=[[SapphireMovieDirectory alloc] initWithContext:_moc];
//            NSArray *files=[dir metaFiles];
//            NSMutableArray *names = [[NSMutableArray alloc] init];
//            NSMutableArray *paths = [[NSMutableArray alloc] init];
//            NSMutableDictionary *rdict=[[NSMutableDictionary alloc]init];
//            NSMutableArray *dicts=[[NSMutableArray alloc]init];
//            if ([files count]>0) {
//                int i,ct=[files count];
//                for(i=0;i<ct;i++)
//                {   
//                    NSArray *array;
//                    NSMutableDictionary *dd=[[files objectAtIndex:i]getDisplayedMetaDataInOrder:&array];
//                    [names addObject:[[files objectAtIndex:i] prettyName]];
//                    [paths addObject:[[files objectAtIndex:i] path]];
//                    [dicts addObject:[dd objectForKey:@"Plot"]];
//                    //[dicts addObject:dd];
//                    
//                }
//                
//            }
//            [rdict setObject:@"Movies" forKey:@"Target"];
//            [rdict setObject:names forKey:kSMSRETURN];
//            [rdict setObject:paths forKey:@"Return2"];
//            [rdict setObject:dicts forKey:@"Return3"];
//            [rdict setObject:[NSNumber numberWithInt:0] forKey:kSMSACTION];
//            NSLog(@"dict: %@",dicts);
//            [self sendPlist:rdict toConnection:con];
//            [rdict release];
//            [names release];
//            [dicts release];
//            break;
//            
//        }
//                    case 2:
//            NSLog(@"top controller = %@",[[[BRApplicationStackManager singleton]stack] peekController]);
//            NSString *path = [inputDict objectForKey:@"Movie"];
//            id a =[SapphireFileMetaData fileWithPath:path inContext:_moc];
//            NSURL *url = [NSURL fileURLWithPath:path];
//            SapphireMedia *asset  =[[SapphireMedia alloc] initWithMediaURL:url];
//            [asset setResumeTime:[a resumeTimeValue]];
//            SapphireVideoPlayer *player = [[SapphireVideoPlayer alloc] init];
//            NSError *error = nil;
//            [player setMedia:asset error:&error];
//            SapphireVideoPlayerController *controller = [[SapphireVideoPlayerController alloc] initWithScene:nil player:player];
//            [controller setPlayFile:a];
//            [controller setAllowsResume:YES];
//            [[[BRApplicationStackManager singleton] stack] pushController:controller];
//            
//            [asset release];
//            [player release];
//            [controller release];            
//            break;
//        case 3:
//        {
//            NSString *path = [inputDict objectForKey:@"Movie"];
//            SapphireFileMetaData *a =[SapphireFileMetaData fileWithPath:path inContext:_moc];
//            NSString *coverPath = [a coverArtPath];
//            NSLog(@"coverArtPath = %@",coverPath);
//            NSImage *img = [[NSImage alloc] initWithContentsOfFile:coverPath];
//            NSMutableDictionary *rdict = [inputDict mutableCopy];
//            //[rdict setObject:[img TIFFRepresentation] forKey:kSMSRETURN];
//            [rdict setObject:[NSNumber numberWithBool:TRUE] forKey:@"ImageFound"];
//            NSData *data = [NSData dataWithContentsOfFile:coverPath];
//            [rdict setObject:data forKey:kSMSRETURN];
//            [self sendPlist:rdict toConnection:con];
//            //[self sendImage:img withDict:rdict toConnection:con];
//            [img release];
//            [rdict release];
//            
//            break;
//            
//        }
//        default:
//            break;
//    }
//    
//}
-(void)sendData:(NSData *)data toConnection:(SimpleCocoaConnection *)con
{
    [server sendData:data toConnection:con];
}
-(void)sendImage:(NSImage *)img withDict:(NSDictionary *)rdict toConnection:(SimpleCocoaConnection *)con
{
    [self sendPlist:rdict toConnection:con];
    //NSLog(@"tiff: %@,",[img TIFFRepresentation]);
    [self sendData:[img TIFFRepresentation] toConnection:con];
}
- (void)processMessage:(NSString *)inputS orData:(NSData *)data  fromConnection:(SimpleCocoaConnection *)con
{
    if (_moc!=nil) {
        [SapphireMetaDataSupport applyChangesFromContext:_moc];
    }
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    NSLog(@"dict: %@",[self getDictForData:data]);
    NSDictionary *inputDict=[self getDictForData:data];
    switch ([[inputDict objectForKey:kSMSTYPE] intValue]) {
        case kSMSRemote:
            [self remoteEvent:inputDict fromConnection:con];
            break;
        case kSMSScripts:
            [self scriptEvent:inputDict fromConnection:con];
            break;
        case kSMSSystem:
            [self systemEvent:inputDict fromConnection:con];
            break;
        case kSMSMainMenu:
            [self mamenuEvent:inputDict fromConnection:con];
            break;
        case 5:
            //[self sapphireEvent:inputDict fromConnection:con];
            break;
        case 35:
        {
            NSMutableDictionary *data= [NSMutableDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"hello.plist"]];
            //[data setObject:[NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"hello.png"]] forKey:@"bla"];
            [self sendPlist:data toConnection:con];
            break;
        }
        case 36:
        {
            NSLog(@"top controller = %@",[[[BRApplicationStackManager singleton]stack] peekController]);
            NSString *path = [inputDict objectForKey:@"Movie"];
            NSDictionary *storeOptions =[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSReadOnlyPersistentStoreOption, nil];
            NSManagedObjectContext *moc = [SapphireApplianceController newManagedObjectContextForFile:nil withOptions:storeOptions];
            [storeOptions release];
            //SapphireMovieDirectory *dir=[[SapphireMovieDirectory alloc] initWithContext:moc];
            id a =[SapphireFileMetaData fileWithPath:path inContext:moc];
            NSURL *url = [NSURL fileURLWithPath:path];
            SapphireMedia *asset  =[[SapphireMedia alloc] initWithMediaURL:url];
            
            [asset setResumeTime:[a resumeTimeValue]];
            //            
            //            /*Get the player*/
            SapphireVideoPlayer *player = [[SapphireVideoPlayer alloc] init];
            NSError *error = nil;
            [player setMedia:asset error:&error];
            //            
            //            /*and go*/
            SapphireVideoPlayerController *controller = [[SapphireVideoPlayerController alloc] initWithScene:nil player:player];
            [controller setPlayFile:a];
            [controller setAllowsResume:YES];
            [[[BRApplicationStackManager singleton] stack] pushController:controller];
            
            [asset release];
            [player release];
            [controller release];
            
            break;
        }
            
        default:
            break;
    }
    [pool drain];
}

@end
