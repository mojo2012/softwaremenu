
//
//  Created by nito on 10/18/08.
//  Copyright 2008 nito. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "installHelperClass.h"

/* argv[0] = command path */



int main (int argc, const char * argv[]) {
	fprintf(stdout, "SoftwareMenu installHelper:\n");
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
        BOOL isRW=YES;
		installHelperClass *ihc = [[installHelperClass alloc] init];
        if([ihc isWritable])
        {
            isRW=NO;
            [ihc makeSystemWritable];
        }

		if ([option isEqual:@"-z"]) { //move stub file

				
				[ihc makeSystemWritable];
				[ihc setRunPath:path];
			NSLog(@"installhelper value; %@",value);
				[ihc updateSelf:value];	
				[pool release];
				//return rvalue;

		}
		else if([option isEqual:@"-i"])
		{
			NSLog(@"option: %@",option);
			
			[ihc setRunPath:path];
            //[ihc makeSystemWritable];
			[ihc removeFrap:value2];
			[ihc installSelf:value];
            //[ihc makeSystemReadOnly];
			[pool release];
			//rvalue = 1;

			//return 0;
		}
		else if([option isEqual:@"-r"])
		{
			NSString *file = [@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/" stringByAppendingString:value];
			NSLog(@"option: %@",option);
			
			[ihc setRunPath:path];
			[ihc removeFile:file];
			[pool release];
			//rvalue = 1;
			
			//return //returnvalue;
		}
		else if([option isEqual:@"-rb"])
		{
			NSLog(@"option: %@",option);
			NSString *file = [@"/Users/frontrow/Documents/Backups/" stringByAppendingString:[[value stringByDeletingPathExtension] stringByAppendingPathExtension:@"bak"]];
			NSLog(@"filelocation: %@",file);
			
			[ihc setRunPath:path];
			[ihc removeFile:file];
			[pool release];
			//rvalue = 1;
			
			//return //returnvalue;
		}
		else if([option isEqual:@"-update"])
		{
			NSLog(@"option: %@",option);
			[ihc setRunPath:path];
			[ihc removeFrap:value2];
			[ihc installSelf:value];
			[pool release];
			//rvalue = 1;
			
			//return 0;
		}
		else if([option isEqual:@"-h"])
		{
			NSLog(@"option: %@",option);
			
			[ihc setRunPath:path];
			[ihc hideFrap:value];
			[pool release];
			//rvalue = 1;
			
			//return 0;
		}
		else if([option isEqual:@"-s"])
		{
			NSLog(@"option: %@",option);
			
			[ihc setRunPath:path];
			[ihc showFrap:value];
			[pool release];
			//rvalue = 1;
			
			//return 0;
		}
		else if([option isEqual:@"-restore"])
		{
			NSLog(@"option: %@",option);
			
			[ihc setRunPath:path];
			[ihc restoreFrap:value];
			[pool release];
			//rvalue = 1;
			
			//return 0;
		}
		else if([option isEqual:@"-backup"])
		{
			NSLog(@"option: %@",option);
			
			[ihc setRunPath:path];
			[ihc backupFrap:value];
			[pool release];
			//rvalue = 1;
			
			//return 0;
		}
		else if([option isEqual:@"-updateSelf"])
		{
			NSLog(@"option: %@",option);
			
			[ihc setRunPath:path];
			[ihc updateSelf:value];
			[pool release];
			//rvalue = 1;
			
			//return rvalue;
		}
		else if([option isEqual:@"-restart"])
		{
		
		
		[ihc setRunPath:path];
			[ihc restart:value];
		[pool release];
		[rl run];
		}
		else if([option isEqual:@"-changeOrder"])
		{
			
			[ihc setRunPath:path];
			[ihc changeOrder:value toOrder:value2];
			[pool release];
		}
		else if([option isEqualToString:@"-fullOSUpdateNoLaunch"])
		{
			
			
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
			
			NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			[ihc makeDMGRW:[basepath stringByAppendingPathComponent:@"OS.dmg"]];
			[pool release];
			
		}
		else if([option isEqual:@"-makeRO"])
		{
			NSLog(@"makeRO");
			
			[ihc makeDMGRO:value];
			[pool release];
		}
		else if([option isEqual:@"-mountconverted"])
		{
			NSLog(@"mountconverted");
			
			NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			[ihc mountImage:[basepath stringByAppendingPathComponent:@"converted.dmg"]];
			//return 0;
			[pool release];
		}
		else if([option isEqual:@"-addFiles"])
		{
			NSLog(@"addFIles");
			
			[ihc setRunPath:path];
			//NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			[ihc copySSHFiles];
			[pool release];
		}
		else if([option isEqual:@"-unmount"])
		{

			
			//NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			[ihc unMountDrive:value];
			
		}
		else if([option isEqual:@"-asrscan"])
		{
			NSLog(@"asrscan");
			
			NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Updates/",nil];
			NSLog(@"%@",[basepath stringByAppendingPathComponent:@"final.dmg"]);
			[ihc makeASRscan:[basepath stringByAppendingPathComponent:@"final.dmg"]];
		}
		else if([option isEqual:@"-osupdate"])
		{
			NSLog(@"osupdate");
			
			//NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
			//NSLog(@"%@",[basepath stringByAppendingPathComponent:@"final.dmg"]);
			[ihc OSUpdate];
		}
		else if([option isEqual:@"-toggleUpdate"])
		{
			
			NSLog(@"toggleUpdate");
			
			int i;
			BOOL HELLO;
			HELLO=[ihc makeSystemWritable];
			i=[ihc toggleUpdate];
		}
		else if([option isEqual:@"-blockUpdate"])
		{
			
			
			
			int i;
			BOOL HELLO;
			HELLO=[ihc makeSystemWritable];
			i=[ihc blockUpdate];
		}
		else if([option isEqualToString:@"-untar"])
		{
			NSLog(@"untar");
			

			[ihc extractTar:value toLocation:value2];
		}
		else if([option isEqualToString:@"-install_perian"])
		{
			
			[ihc setRunPath:path];
			[ihc install_perian:value toVolume:value2];
			[pool release];
			//return //returnvalue;
		}
		else if([option isEqualToString:@"-toggleTweak"])
		{
			
			[ihc setRunPath:path];
			int returnvalue;
			returnvalue = [ihc toggleTweak:value toValue:value2];
            if([value isEqualToString:@"RW"])
            {
                if ([value2 isEqualToString:@"ON"]) 
                {
                    isRW=YES;
                }
                else {
                    isRW=NO;
                }

            }
			[pool release];
			//return //returnvalue;
		}
		else if([option isEqualToString:@"-script"])
		{
			
			int returnvalue;
			returnvalue=[ihc runscript:value];
			[pool release];
			//return //returnvalue;
		}
		else if([option isEqualToString:@"-installTGZ"])
		{
			NSLog(@"installTGZ");
			fprintf(stdout, "install TGZ");
			
			int returnvalue;
			[ihc setRunPath:path];
			returnvalue = [ihc extractGZip:value toLocation:value2];
			[pool release];
			//return //returnvalue;
		}
		else if ([option isEqualToString:@"installScreensaver"])
		{
			NSLog(@"Install ScreenSaver");
			
			int returnvalue;
			[ihc setRunPath:path];
			returnvalue = [ihc installScreenSaver];
			[pool release];
			//return //returnvalue;
		}
        if (!isRW) {
            [ihc makeSystemReadOnly];
        }	
			
	}

    [pool release];
    return 0;
}


