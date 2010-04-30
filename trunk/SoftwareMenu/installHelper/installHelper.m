
//
//  Created by nito on 10/18/08.
//  Copyright 2008 nito. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "installHelperClass.h"
#import <Backrow/Backrow.h>
#import "smToolHelper.h"
void SMHLogIt (NSString *format, ...)
{
    va_list args;
    
    va_start (args, format);
    
    NSString *string;
    
    string = [[NSString alloc] initWithFormat: format  arguments: args];
    
    va_end (args);
    
    printf ("%s\n", [string cString]);
    
    [string release];
    
}
/* argv[0] = command path */


int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	NSRunLoop *rl = [NSRunLoop currentRunLoop];
	
	[rl configureAsServer];
	if (argc < 2){
		printf("smTool --help       for more Information\n");
        printf("smTool --version    for version Information\n");
		printf("\n");
        [pool release];
        return 0;
        
	}
    
	int i=1;
    NSString *value;
    NSString *value2;
    NSString *path = [NSString stringWithUTF8String:argv[0]];
    NSString *option = [NSString stringWithUTF8String:argv[i]];
    installHelperClass *ihc = [[installHelperClass alloc] init];
    [ihc setRunPath:path];
    smToolHelper *sth=[[smToolHelper alloc]init];
    [sth setRunPath:path];
    int result = 0;
    if (argc>2) {
        value=[NSString stringWithUTF8String:argv[i+1]];
    }
    if (argc>3) {
        value2=[NSString stringWithUTF8String:argv[i+2]];
    }
    

    if ([option isEqualToString:@"--help"]) {
        SMHLogIt(@"Software Menu Install Helper version: %@",@"1.0b2.3");
        SMHLogIt(@"usage: smTool <command> [option1] [option2]");
        SMHLogIt(@"Available commands:");
        SMHLogIt(@"");
        SMHLogIt(@"commands requiring plugin name as input (with or without extension):");
        SMHLogIt(@" %@       \t\tremoves the plugin",SMH_REMOVE_PLUGIN);
        SMHLogIt(@"\t<alias>:%@",SMH_REMOVE_PLUGIN_1);
        SMHLogIt(@" %@          \t\tbackups the plugin",SMH_BACKUP);
        SMHLogIt(@"\t<alias>:%@",SMH_REMOVE_BACKUP_1);
        SMHLogIt(@" %@       \t\tremoves the plugin backup",SMH_REMOVE_BACKUP);
        SMHLogIt(@"\t<alias>:%@",SMH_REMOVE_BACKUP_1);
        SMHLogIt(@" %@          \t\trestores the plugin from backup",SMH_RESTORE);
        SMHLogIt(@"\t<alias>:%@",SMH_RESTORE_1);
        SMHLogIt(@" %@       \thides the plugin",SMH_HIDE);
        SMHLogIt(@"\t<alias>:%@",SMH_HIDE_1);
        SMHLogIt(@" %@       \t\tshows the plugin",SMH_SHOW);
        SMHLogIt(@"\t<alias>:%@",SMH_SHOW_1);
        SMHLogIt(@"\nInstalling plugins from archive");
        SMHLogIt(@"");
        SMHLogIt(@"commands requiring plugin as arg1 and a number as option2");
        SMHLogIt(@" %@     \t\tchange the order of the plugin to option2",SMH_ORDER);
        SMHLogIt(@"\t<alias>:%@",SMH_ORDER_1);
        SMHLogIt(@"");
        SMHLogIt(@"commands requiring paths to targets");
        SMHLogIt(@" %@      \t\tinstall the plugin in archive ",SMH_INSTALL);
        SMHLogIt(@"\t<alias>:%@",SMH_INSTALL_1);
        SMHLogIt(@" %@      \t\t\tmounts a dmg",SMH_MOUNT);
        SMHLogIt(@" %@      \t\tunmounts a drive",SMH_UNMOUNT);
        SMHLogIt(@" %@      \t\tconverts a dmg to read-only",SMH_MAKE_RO);
        SMHLogIt(@" %@      \tconverts a dmg to read-write",SMH_MAKE_RW);
        SMHLogIt(@" %@      \t\trun asr scan on a dmg",SMH_ASR);
        SMHLogIt(@"");
        SMHLogIt(@"commands requiring no extra inputs");
        SMHLogIt(@" %@      \tinstalls the SoftwareMenu Screensaver",SMH_SCREENSAVER);
        SMHLogIt(@" %@      \t\t\tlaunch the update (proper files have to be in ~/Updates",SMH_UPDATE);
        SMHLogIt(@" %@      \t\trestart the Finder",SMH_RESTART);
        SMHLogIt(@"\t<alias>:%@",SMH_RESTART_1);
        SMHLogIt(@" %@      \t\t\treboot the AppleTV",SMH_REBOOT);
        SMHLogIt(@"\nrunning scripts as root");
        SMHLogIt(@" %@      \t\truns a script. arguments are passed through to the script",SMH_SCRIPT);
        SMHLogIt(@"scripts can also be run directly in the following fashion:");
        SMHLogIt(@"\t\tsmTool <scriptPath> [args...]");
        SMHLogIt(@"\ninstallation commands:");
        SMHLogIt(@" %@      \t\tinstalls Perian\n\t\t\t\trequires the perian dmg as option1 and the destination as option2.\n\t\t\t\tNo option2 means /",SMH_PERIAN);
        SMHLogIt(@" %@      \t\tinstalls Python\n\t\t\t\trequires the python dmg as option1 and the destination as option2.\n\t\t\t\tNo option2 means /",SMH_PYTHON);
        SMHLogIt(@" %@      \tinstalls Dropbear SSH to the destination drive passed on as option1.\n\t\t\t\tNo option1 means /",SMH_DROPBEAR);
        SMHLogIt(@" %@      \tinstalls convenience binaries to the destination drive passed on as option1.\n\t\t\t\tNo option1 means /",SMH_BINARIES);
        [pool release];
        return 0;
        
    }
    else if ([option isEqualToString:@"--help"])
    {
       SMHLogIt(@"Software Menu Install Helper version: %@",@"1.0b2.3"); 
        [pool release];
        return 0;
    }
    else if([[option pathExtension] isEqualToString:@"sh"])
    {
        SMHLogIt(@"Running Shell script at Path: %@",option);
        setuid(0);
        setgid(0);
        NSTask *mdTask = [[NSTask alloc] init];
        //NSPipe *mdip = [[NSPipe alloc] init];
        [mdTask setLaunchPath:@"/bin/bash"];
        [mdTask setArguments:[NSArray arrayWithObjects:option,nil]];
        //[mdTask setStandardOutput:mdip];
        //[mdTask setStandardError:mdip];
        [mdTask launch];
        [mdTask waitUntilExit];
        [pool release];
        SMHLogIt(@"done");
        return 0;
    }
    else if([[option pathExtension] isEqualToString:@"py"]||[[option pathExtension] isEqualToString:@"pyc"])
    {
        
    }
    else if(ISString(option,SMH_RESTART)){
        [sth restartFinder];
        return 0;
    }
    else if(ISString(option,SMH_REBOOT))
    {
        [sth reboot];
        return 0;
    }


    BOOL isRW=YES;
    if([sth isWritable])
    {
        isRW=NO;
        [sth makeSystemWritable];
    }
//    if ([option isEqual:@"-z"]) { //move stub file
//        [ihc updateSelf:value];	
//    }
    if([option isEqualToString:@"--test"])
    {
        [sth makeDMGRW:value newName:@"converted.dmg"];
        NSString *drive = [sth mountImage:@"/Users/frontrow/converted.dmg"];
        if (drive !=nil) {
            [sth installDropbearToDrive:drive];
        }
        
        //[sth testFind];
    }
    else if(ISString(option,SMH_SHOW)||ISString(option,SMH_SHOW_1))
    {
        [sth plistShowFrap:value];
    }
    else if(ISString(option,SMH_HIDE)||ISString(option,SMH_HIDE_1))
    {
        
        [sth plistHideFrap:value];
    }
    
    else if(ISString(option,SMH_INSTALL)||ISString(option,SMH_UPDATE)||ISString(option,SMH_INSTALL_1))
    {
        [sth installPluginWithArchive:value];
    }
    else if(ISString(option,SMH_EXTRACT)||ISString(option,SMH_EXTRACT_1))
    {
        if (value2=nil) {
            value2=[[sth runPath] stringByDeletingLastPathComponent];
        }
        [sth extractArchive:value toPath:value2];
        [pool release];
    }
    else if(ISString(option,SMH_RESTART)||ISString(option,SMH_RESTART_1))
    {
        [sth restartFinder];
    }
    else if (ISString(option,SMH_RESTART)){
        [sth reboot];
    }

    else if(ISString(option,SMH_REMOVE_PLUGIN)||ISString(option,SMH_REMOVE_PLUGIN_1))
    {
        [sth removeFile:[sth getPluginPath:value]];
    }
    else if(ISString(option,SMH_REMOVE_BACKUP)||ISString(option,SMH_REMOVE_BACKUP_1))
    {
        [sth removeFile:[sth getBackupPath:value]];
    }
//    else if(ISString(option,SMH_UPDATE))
//    {			
//        [ihc removeFrap:value2];
//        [ihc installSelf:value];
//    }
    else if([option isEqual:@"--disable"])
    {
        [sth disableFrap:value];
    }
    else if([option isEqual:@"--enable"])
    {
        [sth enableFrap:value];
    }
    else if(ISString(option,SMH_RESTORE)||ISString(option,SMH_RESTORE_1))
    {
        [sth restoreFrap:value];
    }
    else if(ISString(option,SMH_BACKUP)||ISString(option,SMH_BACKUP_1))
    {
        [sth backupFrap:value];
    }
//    else if([option isEqual:@"-updateSelf"])
//    {
//        [ihc updateSelf:value];
//    }
    else if(ISString(option,SMH_ORDER)||ISString(option,SMH_ORDER_1))
    {
        [sth changeOrder:value toOrder:value2];
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
        
    }
    
    
    else if(ISString(option,SMH_MAKE_RW)||ISString(option,SMH_MAKE_RW_1))
    {
        if (value2==nil) {
            value2=@"final.dmg";
        }
       // NSString *basepath = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",value,nil];
        [sth makeDMGRW:value newName:value2];
    }
    else if(ISString(option,SMH_MAKE_RO)||ISString(option,SMH_MAKE_RO_1))
    {
        if (value2==nil) {
            value2=@"converted.dmg";
        }
        [sth makeDMGRO:value newName:value2];
    }
    else if(ISString(option,SMH_MOUNT))
    {
        [sth mountImage:value];
    }
    else if(ISString(option,SMH_DROPBEAR))
    {
        if (value==nil) {
            value=@"/";
        }
        SMHLogIt(@"dropbear path: %@",value);
        [sth installDropbearToDrive:value];
        //[ihc copySSHFiles];
        [pool release];
    }
    else if(ISString(option,SMH_UNMOUNT))
    {
        [sth unMountDrive:value];
        
    }
    else if(ISString(option,SMH_ASR))
    {
        [ihc makeASRscan:value];
    }
    else if(ISString(option,SMH_OSUPDATE))
    {
        [ihc OSUpdate];
    }
    else if([option isEqual:SMH_TOGGLE_UPDATE])
    {
        i=[ihc toggleUpdate];
    }
    else if([option isEqual:@"-blockUpdate"])
    {
        i=[ihc blockUpdate];
    }
    else if([option isEqualToString:@"-untar"])
    {
        [ihc extractTar:value toLocation:value2];
    }
    else if(ISString(option,SMH_PERIAN))
    {
        if (value2==nil) 
            value2=@"/";
        if (value==nil) {
            return 98;
        }
        [sth installPerian:value toVolume:value2];
    }
    else if(ISString(option,SMH_PYTHON))
    {
        if (value2==nil) 
            value2=@"/";
        if (value==nil) {
            return 98;
        }
        [sth installPython:value toVolume:value2];
    }
    else if(ISString(option,SMH_TWEAK))
    {
        
        if (value==nil) 
            return 98;
        if (value2==nil) 
            return 99;
        SMTweak tw = [value intValue];
        BOOL on = [[NSNumber numberWithInt:[value2 intValue]] boolValue];
        SMHLogIt(@"Toggling Tweak: %d %d",tw,on);
        
        if (tw!=kSMTweakReadWrite) {
            result = [sth toggleTweak:tw on:on];
        }
        else
            isRW=on;
    }
    else if([option isEqualToString:@"--script"])
    {
        int returnvalue;
        returnvalue=[ihc runscript:value];
        [pool release];
    }
    else if([option isEqualToString:@"-installTGZ"])
    {
        int returnvalue;
        
        returnvalue = [ihc extractGZip:value toLocation:value2];
        [pool release];
    }
    else if (ISString(option,SMH_SCREENSAVER))
    {
        NSLog(@"Install ScreenSaver");
        
        int returnvalue;
        
        returnvalue = [ihc installScreenSaver];
        [pool release];
        //return //returnvalue;
    }
    if (!isRW) {
        [sth makeSystemReadOnly];
    }	
    
    
    [pool release];
    return 0;
}


