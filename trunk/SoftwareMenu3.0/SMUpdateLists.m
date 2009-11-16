//
//  SMUpdateLists.m
//  SoftwareMenu
//
//  Created by Thomas on 4/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMUpdateLists.h"
#import "SMGeneralMethods.h"


@implementation SMUpdateLists
-(id)init
{
	self = [super init];
	return self;
}
-(void)updateList:(NSString *)toupdate
{
	if([toupdate isEqualToString:PLUGINS]) { [self updatePluginsList];}
}
-(void)updatePluginsList
{
	NSMutableDictionary *threedict =[[NSMutableDictionary alloc] initWithDictionary:nil];
	NSMutableDictionary *fourdict  =[[NSMutableDictionary alloc] initWithDictionary:nil];
	NSMutableDictionary *pluginsdict  =[[NSMutableDictionary alloc] initWithDictionary:nil];
	
	NSFileManager *man = [NSFileManager defaultManager];
	if(![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Trusted" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/Trusted" stringByExpandingTildeInPath] attributes:nil];
	if(![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted" stringByExpandingTildeInPath] attributes:nil];
	if([man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/plugins.plist" stringByExpandingTildeInPath]])
	{
		NSMutableDictionary *threedict=[[NSMutableDictionary alloc] initWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/Info3.plist" stringByExpandingTildeInPath]];
		[man removeFileAtPath:[@"~/Library/Application Support/SoftwareMenu/Info3.plist" stringByExpandingTildeInPath] handler:nil];
	}
	
	if([man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Info4.plist" stringByExpandingTildeInPath]])
	{
		NSMutableDictionary *fourdict = [[NSMutableDictionary alloc] initWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/Info4.plist" stringByExpandingTildeInPath]];
		[man removeFileAtPath:[@"~/Library/Application Support/SoftwareMenu/Info4.plist" stringByExpandingTildeInPath] handler:nil];
	}
	if([man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/plugins.plist" stringByExpandingTildeInPath]])
	{
		NSMutableDictionary *fourdict = [[NSMutableDictionary alloc] initWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/plugins.plist" stringByExpandingTildeInPath]];
		[man removeFileAtPath:[@"~/Library/Application Support/SoftwareMenu/plugins.plist" stringByExpandingTildeInPath] handler:nil];
	}
	
	//tempFrapsInfo = [[NSMutableDictionary alloc] initWithDictionary:nil];
	//tempFrapsInfo2= [[NSMutableDictionary alloc] initWithDictionary:nil];
	//istrusted = [[NSMutableArray alloc] initWithObjects:nil];
	NSMutableDictionary *TrustedDict=[[NSMutableDictionary alloc] init];
	NSMutableDictionary *UnTrustedDict=[[NSMutableDictionary alloc] init];
	NSArray *hellotwo =[[NSArray alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:@"http://web.me.com/tomcool420/Trusted2.plist"]];
	NSEnumerator *enumerator = [hellotwo objectEnumerator];
	[self writeToLog:@"==== startUpdate ===="];
	[self writeToLog:@"========= Adding Trusted ========="];
	[self writeToLog:@"Downloading trusted file from: http://web.me.com/tomcool420/Trusted2.plist"];
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		NSString *theTrustedURL = [obj valueForKey:@"theURL"];
		NSString *theTrustedName = [obj valueForKey:@"name"];
		
		[self writeToLog:[[NSString alloc] initWithFormat:@"Adding From List: %@",theTrustedName]];
		[self writeToLog:[NSString stringWithFormat:@"	From URL:%@",theTrustedURL,nil]];
		[self writeToLog:@"\n"];
		NSDictionary *hellothree =[[NSDictionary alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:theTrustedURL]];
		
		if([theTrustedURL isEqualToString:@"http://nitosoft.com/version.plist"])
		{
			NSMutableDictionary *nitoDict = [[NSMutableDictionary alloc] init];
			[nitoDict setObject:@"nitoTV" forKey:@"name"];
			[nitoDict setObject:[hellothree valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[nitoDict setObject:[hellothree valueForKey:@"versionTwo"] forKey:@"shortVersion"];
			[nitoDict setObject:@"http://nitosoft.com/nitoTVInstaller_tt.zip" forKey:@"theURL"];
			[nitoDict setObject:@"|bile|" forKey:@"developer"];
			[TrustedDict setObject:nitoDict forKey:@"NitoTV"];
			[self writeToLog:@"nitoTV special loop"];
			
		}
		else if([theTrustedURL isEqualToString:@"http://nitosoft.com/updates.plist"])
		{
			NSMutableDictionary *couchDict = [[NSMutableDictionary alloc] init];
			[couchDict setObject:@"CouchSurfer" forKey:@"name"];
			[couchDict setObject:[hellothree valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[couchDict setObject:[hellothree valueForKey:@"twoUrl"] forKey:@"theURL"];
			[couchDict setObject:@"Brandon Holland" forKey:@"developer"];
			[TrustedDict setObject:couchDict forKey:@"CouchSurfer"];
			[self writeToLog:@"CouchSurfer Loop (from nitoserver)"];
		}
		else
		{
			NSArray *dl_keys=[[NSArray alloc] initWithArray:[hellothree allKeys]];
			NSArray *plugins_keys =[NSArray arrayWithArray:[pluginsdict allKeys]];
			NSEnumerator *key_Enumerator=[dl_keys objectEnumerator];
			id obj2;
			while(obj2=[key_Enumerator nextObject] != nil)
			{
				if(![plugins_keys containsObject:obj2])
				{
					[pluginsdict setObject:[hellothree valueForKey:obj2] forKey:obj2];
				}
				else if([[[pluginsdict valueForKey:obj2] valueForKey:@"Version"] compare:[[hellothree valueForKey:obj2] valueForKey:@"Version"]]==NSOrderedAscending)
				{
					[pluginsdict removeObjectForKey:obj2];
					[pluginsdict setObject:[hellothree valueForKey:obj2] forKey:obj2];
				}
			}
			
			//[TrustedDict addEntriesFromDictionary:hellothree];
			[self writeToLog:@"Normal Loop"];
		}
	}
	
	[pluginsdict writeToFile:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist" atomically:YES];
	[pluginsdict writeToFile:@"/Users/frontrow/Library/Application Support/SoftwareMenu/plugins.plist" atomically:YES];

	
	NSDictionary *hellofour = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist"]];
	NSEnumerator *enumerator2 = [hellofour objectEnumerator];
	[self writeToLog:@"========= Adding Untrusted ========="];
	while((obj = [enumerator2 nextObject]) != nil) 
	{
		
		NSString *theUnTrustedName = [obj valueForKey:@"name"];
		NSString *theUnTrustedURL = [obj valueForKey:@"theURL"];
		[self writeToLog:[[NSString alloc] initWithFormat:@"Adding From List: %@",theUnTrustedName]];
		[self writeToLog:theUnTrustedURL];
		[self writeToLog:@"\n"];
		NSDictionary *hellofive = [[NSDictionary alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:theUnTrustedURL]];
		[UnTrustedDict addEntriesFromDictionary:hellofive];
	}
	[UnTrustedDict writeToFile:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info3.plist" atomically:YES];
	//NSLog(@" ===== startUpdate =====");
	[self writeToLog:@"========= Done ========="];
	BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
	[textControls setTitle:@"Check For Updates"];
	[textControls setDocumentPath:@"/Users/frontrow/Library/Application Support/SoftwareMenu/updater.log" encoding:NSUTF8StringEncoding];
	BRController *theController =  [BRController controllerWithContentControl:textControls];
	[[self stack] pushController:theController];
	
}

@end
