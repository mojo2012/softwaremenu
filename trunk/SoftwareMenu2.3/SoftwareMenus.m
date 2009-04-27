//
//  QuDownloader.m
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x



#import "SoftwareMenus.h"
#import "SMInstallMenu.h"
#import "SMThirdPartyMenu.h"
#import "SMBuiltInMenu.h"
#import "SMScriptsMenu.h"
#import "SoftwareUpdater.h"
#import	"SMInfo.h"
#import "SoftwareUpdaterHeadless.h"
#import "SoftwareSettings.h"
#import "SMFrappMover.h"
#import "SMGeneralMethods.h"
#import "AGProcess.h"
#import "SMTweaks.h"
#import "SMScreenSaverMenu.h"
@interface BRParentalControl
@end


@implementation SoftwareMenus

+ (NSString *) className
{
    NSString * className = NSStringFromClass(self);
    NSRange range = [[BRBacktracingException backtrace] rangeOfString: @"_loadApplianceAtPath:"];
    if ( range.location != NSNotFound )
    {
       // BRLog(@"[%@ className] called for whitelist check; returning MOVAppliance instead", className);
        className = @"MOVAppliance"; 
    }
	//NSLog(@"SoftwareMenu");
	[SMGeneralMethods checkScreensaver];
	[SMGeneralMethods checkFolders];
    return className;
}

- (id)applianceCategories;
{
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
	BRApplianceCategory *category6 =[BRApplianceCategory categoryWithName:BRLocalizedString(@"Settings",@"Settings")
															   identifier:@"settings"
														   preferredOrder:12];
	[categories addObject:category6];
		return categories;
	
}

- (id) init
{
	

    if ( [super init] == nil )
        return ( nil );
	

    // so we can clean up if the app quits
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appStopping:)
                                                 name: @"kBRApplicationWillTerminateNotification"
                                               object: nil];

    return ( self );
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

- (id)controllerForIdentifier:(id)identifier;
{

	id newController = nil;
	if([[identifier pathExtension] isEqualToString:@"sh"])
	{

			NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]];

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
			NSLog(@"launchPath: %@",launchPath);
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash/" arguments:[NSArray arrayWithObject:launchPath]];
			return nil;
		}

	}
	else
	{
		int i = [[SMGeneralMethods menuItemOptions] indexOfObject:identifier];
		// If it's the name of a frappliance
		/*if([[identifier substringToIndex:4] isEqualToString:@"frap"])
		 {
		 NSArray *loginItemDict = [NSArray arrayWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Desktop/Info.plist"]];
		 NSEnumerator *enumerator = [loginItemDict objectEnumerator];
		 id obj;
		 while((obj = [enumerator nextObject]) != nil) 
		 {
		 if ([identifier isEqualToString:[obj valueForKey:@"identifier"]])
		 {
		 theURL = [obj valueForKey:@"theURL"];
		 thename = [obj valueForKey:@"name"];
		 theversion = [obj valueForKey:@"Version"];
		 
		 newController = [[SoftwareMenu alloc] init];
		 [newController initWithIdentifier:identifier withName:thename withURLStr:theURL withVers:theversion];
		 }
		 }
		 //NSLog(theURL);		
		 }*/
		switch (i)
		{
			case 0:
				newController = [[SMThirdPartyMenu alloc] init];
				[newController initCustom];
				break;
			case 1:
				newController = [[SMBuiltInMenu alloc] init];
				break;
			case 2:
				newController = [[SMScriptsMenu alloc] init];
				[newController initCustom];
				break;
			case 3:
				[SMGeneralMethods restartFinder];
				break;
			case 4:
				newController = [[SMFrappMover alloc] init];
				[newController initCustom];
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
				newController = [[SMScreenSaverMenu alloc] init];
				[newController initCustom];
				break;
			default: 
				newController = [[SoftwareSettings alloc] init];
				break;
		}
		return newController;
		
	}
	/*if([[identifier pathExtension] isEqualToString:@"sh"])
	{
		NSLog(@"%@",[[scripts valueForKey:identifier] valueForKey:@"runoption"]);
		/*if([[[scripts valueForKey:identifier] valueForKey:@"runoption"] isEqualToString:@"FaW"])
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
		}
		else //if([[[scripts valueForKey:identifier] valueForKey:@"runoption"] isEqualToString:@"FaF"])
		{*/
		//	NSString *launchPath = [@"/Users/frontrow/Documents/scripts/" stringByAppendingString:identifier];
		//	NSLog(@"launchPath: %@",launchPath);
		//	[NSTask launchedTaskWithLaunchPath:@"/bin/bash/" arguments:[NSArray arrayWithObject:launchPath]];
		//}
	//}
	
	/*if([identifier isEqualToString:@"update2"])
	{
		SoftwareUpdaterHeadless *ihc = [[SoftwareUpdaterHeadless alloc] init];
		[ihc startUpdate];
		BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
		[textControls setDocumentPath:@"/Users/frontrow/updater.log" encoding:NSUTF8StringEncoding];
		BRController *theController =  [BRController controllerWithContentControl:textControls];
		return theController;
		/*newController = [[SoftwareUpdater alloc] init];
		return newController;


	}*/
	/*if([identifier isEqualToString: @"download"])
	{
		newController = [[QuDownloadController alloc] init];
	}
	return newController;*/

	/*if if([identifier isEqualToString: @"check"])
	{
		newController = [[QuDownloadController alloc] init];
	}*/
	return nil;
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
