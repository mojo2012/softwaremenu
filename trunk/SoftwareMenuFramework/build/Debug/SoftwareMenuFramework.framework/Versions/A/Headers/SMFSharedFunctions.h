//
//  SMFSharedFunctions.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 3/3/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMFSharedFunctions : NSObject {

}
+(id)invocationsForObject:(id)target withSelectorVal:(NSString *)selectorString withArguments:(NSArray *)arguments;
@end
