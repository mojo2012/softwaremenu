//
//  SMFPluginAsset.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 2/23/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface SMFPluginAsset : SMFBaseAsset {

}
-(void)setDeveloper:(NSString *)developer;
-(NSString *)developer;
-(void)setInstalledVersion:(NSString *)installedVersion;
-(NSString *)installedVersion;
-(void)setOnlineVersion;
-(NSString *)onlineVersion;
@end
