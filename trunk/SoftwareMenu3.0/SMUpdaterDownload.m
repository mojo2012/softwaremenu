//
//  SMUpdaterDownload.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 12/1/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMUpdaterDownload.h"


@implementation SMUpdaterDownload
-(id)initWithFiles:(NSArray *)links withImage:(BRImage *)image withTitle:(NSString *)title withVersion:(NSString *)version
{
    self=[super initWithFiles:links withImage:image withTitle:title];
    if (self == nil )
        return ( nil );
    _version = version;
    [_version retain];

    return self;
    
}
-(void)process
{
    [self addText:@"Moving Files"];
    int i;
    NSString *folder = [[@"~/Documents" stringByExpandingTildeInPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"ATV%@",_version,nil]];
    NSFileManager *man = [NSFileManager defaultManager];
    if(![man fileExistsAtPath:folder])
        [man createDirectoryAtPath:folder attributes:nil];
    for(i=0;i<[_outputPaths count];i++)
    {
        NSString *currenPath= [_outputPaths objectAtIndex:i];
        
        NSString *filename = [currenPath lastPathComponent];
        NSString *newfilename=filename;
        if([[filename pathExtension] isEqualToString:@"txt"])
            newfilename=[filename stringByDeletingPathExtension];
        if([[filename pathExtension] isEqualToString:@"dmg"])
            newfilename=@"OS.dmg";
        NSString *destination = [folder stringByAppendingPathComponent:newfilename];
        if([man fileExistsAtPath:destination])
            [man removeFileAtPath:destination handler:nil];
        
        [man movePath:currenPath toPath:destination handler:nil];
        NSLog(@"moving %@ to %@",currenPath, destination);
    }
    [self addText:@"Files Moved"];
    NSLog(@"version before : %@",_version);
    SMNewUpdaterProcess *a = [[SMNewUpdaterProcess alloc]initForFolder:folder withVersion:_version];
    [self _removeAllControls];
    [[self stack]swapController:a];
    
}
-(void)dealloc
{
    [_version release];
    [super dealloc];
}
@end
