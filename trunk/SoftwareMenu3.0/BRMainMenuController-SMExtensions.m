//
//  BRMainMenuController-SMExtensions.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/8/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "BRMainMenuController-SMExtensions.h"
#import <objc/objc-class.h>

@implementation BRMainMenuController (SMExtensions)
-(BRMainMenuControl *)gimmeControl {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_browser");
	return *(BRMainMenuControl * *)(((char *)self)+ret->ivar_offset);
}

@end
@implementation BRMainMenuControl (SMExtensions)
-(BRControl *)gimmeCurControl {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_curPreview");
	return *(BRControl * *)(((char *)self)+ret->ivar_offset);
}

@end
@implementation BRCyclerControl (SMExtensions)
-(id)gimmeProvider {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_provider");
	return *(id *)(((char *)self)+ret->ivar_offset);
}
-(BRControl *)gimmeControl {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_control");
	return *(BRControl * *)(((char *)self)+ret->ivar_offset);
}
@end
