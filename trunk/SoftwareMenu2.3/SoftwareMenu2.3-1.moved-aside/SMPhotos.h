//
//  TomRSS.h
//  TomSS.frss
//
//  Created by Thomas on 4/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "BackRow.h"
@interface ATVPhloatoScreenSaver 
@end
@interface ATVDefaultPhotos 
@end




@interface SMPhoto : ATVPhloatoScreenSaver {

}
- (id)init;
- (id)loadAssets;
- (id)applePhotosForPath:(NSString *)path;
- (id)getPath;

@end

