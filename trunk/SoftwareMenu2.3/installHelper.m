
//
//  Created by nito on 10/18/08.
//  Copyright 2008 nito. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "installHelperClass.h"

/* argv[0] = command path */



int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	
	NSRunLoop *rl = [NSRunLoop currentRunLoop];
	
	[rl configureAsServer];
	if (argc < 2){
		//printf("\nUsage: installHelper: --inDVD dvdPath\n");
		printf("Segmentation Fault");
		//printf("version 0.2.5R6");
		printf("\n");
	}
	int i;
	for (i = 1; i < (argc - 1); i+= 3){
		
		NSString *path = [NSString stringWithUTF8String:argv[0]];
		//NSLog(@"argv[0]: %@", path);
		NSString *option = [NSString stringWithUTF8String:argv[i]]; //argument 1
		NSString *value = [NSString stringWithUTF8String:argv[i+1]]; //argument 2
		NSString *value2 = [NSString stringWithUTF8String:argv[i+2]];
		
		if ([option isEqual:@"-z"]) { //move stub file

				installHelperClass *ihc = [[installHelperClass alloc] init];
				BOOL MSW = [ihc makeSystemWritable];
				[ihc setRunPath:path];
			NSLog(@"installhelper value; %@",value);
				int rvalue = [ihc updateSelf:value];	
				[pool release];
				return rvalue;

		}
		else if([option isEqual:@"-i"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			[ihc installSelf:value];
			[pool release];
			//rvalue = 1;

			return 0;
		}
		else if([option isEqual:@"-r"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			int returnvalue=[ihc removeFile:value];
			[pool release];
			//rvalue = 1;
			
			return returnvalue;
		}
		else if([option isEqual:@"-rb"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			[ihc removeBak:value];
			[pool release];
			//rvalue = 1;
			
			return 0;
		}
		else if([option isEqual:@"-update"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			[ihc removeFrap:value];
			[ihc installSelf:value];
			[pool release];
			//rvalue = 1;
			
			return 0;
		}
		else if([option isEqual:@"-h"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			[ihc hideFrap:value];
			[pool release];
			//rvalue = 1;
			
			return 0;
		}
		else if([option isEqual:@"-s"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			[ihc showFrap:value];
			[pool release];
			//rvalue = 1;
			
			return 0;
		}
		else if([option isEqual:@"-restore"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			[ihc restoreFrap:value];
			[pool release];
			//rvalue = 1;
			
			return 0;
		}
		else if([option isEqual:@"-backup"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			[ihc backupFrap:value];
			[pool release];
			//rvalue = 1;
			
			return 0;
		}
		else if([option isEqual:@"-updateSelf"])
		{
			NSLog(@"option: %@",option);
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			int rvalue =[ihc updateSelf:value];
			[pool release];
			//rvalue = 1;
			
			return rvalue;
		}
		else if([option isEqual:@"-restart"])
		{
		
		installHelperClass *ihc = [[installHelperClass alloc] init];
		[ihc setRunPath:path];
		int rvalue =[ihc restart:value];
		[pool release];
		[rl run];
		}
		else if([option isEqual:@"-changeOrder"])
		{
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			[ihc changeOrder:value toOrder:value2];
			[pool release];
		}
		else if([option isEqualToString:@"-fullOSUpdateNoLaunch"])
		{
			
			installHelperClass *ihc = [[installHelperClass alloc] init];
			NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value];
			[ihc makeDMGRW:[basepath stringByAppendingPathComponent:@"OS.dmg"]];
			[ihc mountDrive:[basepath stringByAppendingPathComponent:@"converted.dmg"]];
			[ihc copySSHFiles];
			[ihc unMountDrive:@"/Volumes/OSBoot 1"];
			[ihc makeDMGRO:[basepath stringByAppendingPathComponent:@"converted.dmg"]];
			[ihc makeASRscan:[basepath stringByAppendingPathComponent:@"final.dmg"]];
			[pool release];
			
		}
		
		
		else if([option isEqual:@"-makewritable"])
		{
			NSLog(@"makewritable");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			[ihc makeDMGRW:[basepath stringByAppendingPathComponent:@"OS.dmg"]];
			[pool release];
			
		}
		else if([option isEqual:@"-makeRO"])
		{
			NSLog(@"makeRO");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			[ihc makeDMGRO:value];
			[pool release];
		}
		else if([option isEqual:@"-mountconverted"])
		{
			NSLog(@"mountconverted");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			NSString *themountpath=[ihc mountImage:[basepath stringByAppendingPathComponent:@"converted.dmg"]];
			return themountpath;
			[pool release];
		}
		else if([option isEqual:@"-addFiles"])
		{
			NSLog(@"addFIles");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			//NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			[ihc copySSHFiles];
			[pool release];
		}
		else if([option isEqual:@"-unmount"])
		{

			installHelperClass *ihc = [[installHelperClass alloc] init];
			//NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			[ihc unMountDrive:value];
			
		}
		else if([option isEqual:@"-asrscan"])
		{
			NSLog(@"asrscan");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Updates/",nil];
			NSLog(@"%@",[basepath stringByAppendingPathComponent:@"final.dmg"]);
			[ihc makeASRscan:[basepath stringByAppendingPathComponent:@"final.dmg"]];
		}
		else if([option isEqual:@"-osupdate"])
		{
			NSLog(@"osupdate");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			//NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			//NSLog(@"%@",[basepath stringByAppendingPathComponent:@"final.dmg"]);
			[ihc OSUpdate];
		}
		else if([option isEqual:@"-toggleUpdate"])
		{
			
			NSLog(@"toggleUpdate");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			int i;
			BOOL HELLO;
			HELLO=[ihc makeSystemWritable];
			i=[ihc toggleUpdate];
		}
		else if([option isEqual:@"-blockUpdate"])
		{
			
			NSLog(@"toggleUpdate");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			int i;
			BOOL HELLO;
			HELLO=[ihc makeSystemWritable];
			i=[ihc blockUpdate];
		}
		else if([option isEqualToString:@"-untar"])
		{
			NSLog(@"untar");
			installHelperClass *ihc = [[installHelperClass alloc] init];
			//NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			//NSLog(@"%@",[basepath stringByAppendingPathComponent:@"final.dmg"]);
			[ihc extractTar:value toLocation:value2];
		}
		else if([option isEqualToString:@"-install_perian"])
		{
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			int returnvalue=[ihc install_perian:value toVolume:value2];
			[pool release];
			return returnvalue;
		}
		else if([option isEqualToString:@"-toggleTweak"])
		{
			installHelperClass *ihc = [[installHelperClass alloc] init];
			[ihc setRunPath:path];
			int returnvalue;
			returnvalue = [ihc toggleTweak:value toValue:value2];
			[pool release];
			return returnvalue;
		}
			
			
	}
	
    [pool release];
    return 0;
}


