//
//  SMPluginMediaAsset.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SMApplianceDictionary;
@interface SMPluginMediaAsset : SMFBaseAsset {
    SMApplianceDictionary *_applianceDict;
}
-(id)initWithApplianceDictionary:(SMApplianceDictionary *)applianceDict;
-(void)setApplianceDictionary:(SMApplianceDictionary *)applianceDict;
-(SMApplianceDictionary *)applianceDictionary;
@end
