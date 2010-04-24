//
//  SMNewScriptsMenu.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/18/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMNewScriptsMenu : SMFMediaMenuController {
    NSMutableArray          *_scripts;
    NSMutableDictionary     *_scriptOptions;
}
+(NSArray *)scripts;
+(NSString *)scriptsPlistPath;
+(NSString *)scriptsPath;
+(NSDictionary *)scriptsOptions;
+(NSDictionary *)defaultScriptOptions;
+(void)runScript:(NSString *)path withDictionary:(NSDictionary *)dict;
+(void)runScript:(NSString *)path displayResult:(BOOL)display asRoot:(BOOL)root;
+(void)runScript:(NSString *)path displayResult:(BOOL)display;
@end
