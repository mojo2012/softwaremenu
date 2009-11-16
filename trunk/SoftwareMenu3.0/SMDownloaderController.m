//
//  SMDownloaderController.m
//  SoftwareMenu
//
//  Created by Thomas on 3/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMDownloaderController.h"


@implementation SMDownloaderController
-(void) processdownload
{
	//NSString *name =  (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"name", kCFPreferencesCurrentApplication));
	//[self setSourceImage:name];
	
	//[self setTitle:name];
	[self appendSourceText:@"Installing"];
	//NSString *name =  (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"name", kCFPreferencesCurrentApplication));
	//[self setSourceImage:name];
	//NSString * thename= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"name", kCFPreferencesCurrentApplication));
	//NSString * thescript= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"thescript", kCFPreferencesCurrentApplication));
	////NSLog(@"_outputPath: %@",_outputPath);
	
	NSTask *helperTask = [[NSTask alloc] init];
	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *attrs = [man fileAttributesAtPath:helperPath traverseLink:YES];
	//NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
	//[self appendSourceText:@"done installing"];
	if (![self helperCheckPerm])
	{
		NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
		NSTask *task = [[NSTask alloc] init];
		NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
		[task setArguments:args];
		[task setLaunchPath:@"/bin/bash"];
		[task launch];
		[task waitUntilExit];
		[self appendSourceText:@"Fixed Permissions"];
		//[self appendSourceText:@"Go to Scripts Menu and run FixPerm"];
		//[self setSourceText:@"go to the Scripts Menu and select FixPerm"];
		//	return;
		
	}
	//[self appendSourceText:@"done installing1"];
	
	//NSLog(@"installHelper curPerms: %@", curPerms);
	[helperTask setLaunchPath:helperPath];
	if([man fileExistsAtPath:[@"/System/Library/Finder/Contents/Plugins/" stringByAppendingPathComponent:[[_theInformation valueForKey:@"name"] stringByAppendingPathExtension:@"frappliance"]]])
	{
		[helperTask setArguments:[NSArray arrayWithObjects:@"-update", _outputPath,@"0", nil]];
		//NSLog(@"update");
		
	}
	else
	{
		[helperTask setArguments:[NSArray arrayWithObjects:@"-i", _outputPath,@"0", nil]];
	}
	
	//[self appendSourceText:@"done installing2"];
	
	[helperTask launch];
	[helperTask waitUntilExit];
	/*int theTerm = *///[helperTask terminationStatus];
	NSLog(@"done");
	//[helperTask release];
	[self appendSourceText:@"done installing"];
	[self appendSourceText:@"Press Menu When you are done"];
	
	////NSLog(@"term status: %d",theTerm);
	//
	//NSString *theSourceText = [self sourceText];
	
	NSMutableDictionary *show_hide = [[NSMutableDictionary alloc] initWithDictionary:nil];
	NSLog(@"done two");
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]];
		[show_hide addEntriesFromDictionary:tempdict];
	}
	NSLog(@"done three");
	/*[self appendSourceText:@"will Pop in 20 secs"];
	 long long t;
	 long count=200;
	 for ( t = 20; t > 0; t-- )
	 {
	 NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 1];
	 [NSThread sleepUntilDate:future];
	 //[self appendSourceText:[NSString stringWithFormat:@"time left: %qi",t]];
	 }
	 [[self stack] popController];*/
}

@end
