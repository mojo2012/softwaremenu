//
//  SMFSharedFunctions.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 3/3/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//




@implementation SMFSharedFunctions
+(id)invocationsForObject:(id)target withSelectorVal:(NSString *)selectorString withArguments:(NSArray *)arguments
{
    
    if (selectorString==nil) {
        return @"none";
    }
    SEL theSelector;
    NSMethodSignature *aSignature;
    NSInvocation *anInvocation;
    id b = target;
    theSelector = NSSelectorFromString(selectorString);
    //theSelector= @selector(removeFromQueue:);
    // NSLog(@"selector)
    aSignature = [[target class] instanceMethodSignatureForSelector:theSelector];
    //NSLog(@"signature: %@",aSignature);
    anInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
    [anInvocation setSelector:theSelector];
    [anInvocation setTarget:b];
    if (arguments !=nil)
    {
        int i,count=[arguments count];
        id c;
        for(i=2;i<count+2;i++)
        {
            c=[arguments objectAtIndex:i-2];
            [anInvocation setArgument:&c atIndex:i];
        }
        
    }
    [anInvocation retainArguments];
    return anInvocation;
}

@end
