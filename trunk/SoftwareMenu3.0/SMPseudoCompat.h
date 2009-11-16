//
//  SMPseudoCompat.h
//  SoftwareMenu
//
//  Created by Thomas on 5/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>

@interface BRSettingsFacade (protectedAccess)
-(int)screenSaverTimeout;
-(void)setScreenSaverTimeout:(int)fp16;

@end
@interface BRScrollingTextControl (protectedAccess)
-(id)text;

@end

/*@interface ATVSettingsFacade : BRSettingsFacade
- (void)setScreenSaverSelectedPath:(id)fp8;
- (id)screenSaverSelectedPath;
- (id)screenSaverPaths;
- (id)screenSaverCollectionForScreenSaver:(id)fp8;
- (id)versionOS;
@end*/

@interface SMPseudoCompat : NSObject {

}
+(BOOL)usingTakeTwoDotThree;
+(NSString *)SMATVVersion;
@end

@interface BRTextEntryController (SMExtensions)
-(void)setTextEntryCompleteDelegate:(id)object;
@end

