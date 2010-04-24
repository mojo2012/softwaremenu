//
//  SMHelper.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/19/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMHelper : NSObject {
    NSFileHandle *logHandle;
    
}
+ (SMHelper*)helperManager;
-(void)toggleUpdate;
-(void)installScreensaver;
-(void)installWithFile:(NSString *)path;
-(void)makeVisible:(NSString *)plugin;
-(void)makeInvisible:(NSString *)plugin;
-(void)removeBackup:(NSString *)plugin;
-(void)backupPlugin:(NSString *)plugin;
-(void)restorePlugin:(NSString *)plugin;
-(void)removePlugin:(NSString *)plugin;
-(void)changeOrderForPlugin:(NSString *)plugin newOrder:(int)order;
-(void)runscript:(NSString *)script withOption1:(NSString *)option1 withOption2:(NSString *)option2;
-(NSString *)runScriptWithReturn:(NSString *)script;
-(void)restartFinder;
-(void)reboot;
-(void)makeImageReadOnly:(NSString *)dmgPath withNewName:(NSString *)newName;
-(void)makeImageReadWrite:(NSString *)dmgPath withNewName:(NSString *)newName;
-(void)asrscanImage:(NSString *)dmgPath;
-(void)mountImage:(NSString *)dmgPath;
-(void)unmountPath:(NSString *)path;
-(void)addDropbearToDrive:(NSString *)drive;
-(void)addBinariesToDrive:(NSString *)drive;
-(void)installPython:(NSString *)dmgPath;
-(void)extractFile:(NSString *)file toPath:(NSString *)path;
- (NSFileHandle *)logHandle;
- (NSString *)logPath;
-(int)runTaskWithOptions:(NSArray *)options;
-(int)runTaskWithOptions:(NSArray *)options withOutput:(NSString **)output;
-(void)launchUpdateWithFolder:(NSString *)folder;
@end
