//
//  SMUpdaterPreprocess.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 12/1/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//
#define UCANDLOS @"canDownloadOS"
@interface SMUpdaterPreprocess (layout)
-(void)layoutHeader;
-(void)layoutSpinner;
-(void)layoutImage;
@end


@implementation SMUpdaterPreprocess
-(id)initWithForVersionDictionary:(NSDictionary *)versionDict forVersion:(NSString *)version
{
    self=[super init];
    if (self==nil)
        return nil;
    _infoDictionary=versionDict;
    [_infoDictionary retain];
    _version=version;
    _image = [BRImage imageWithPath:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/appleTVImage.png"];
    [_image retain];
    _imageControl = [[BRImageControl alloc] init];
    [_version retain];
    _title = [NSString stringWithFormat:@"Preflight for Version: %@",_version,nil];
    _textControls=[[NSMutableArray alloc]init];
    [_textControls retain];
    _arrowControl = [[BRImageControl alloc] init];
    BRImage *arrow = [[BRThemeInfo sharedTheme]menuArrowImage];
    [_arrowControl setImage:arrow];
    [_arrowControl setAutomaticDownsample:YES];
    return self;
}

-(void)SMLayoutSubcontrols
{
    [self _removeAllControls];
    _headerControl=[[BRHeaderControl alloc]init];
    _spinner=[[BRWaitSpinnerControl alloc]init];
    [self layoutSpinner];
    [self layoutHeader];
    [self layoutImage];
    [self setBackgroundColor:[[SMThemeInfo sharedTheme] colorFromNSColor:[NSColor blackColor]]];
    //[self layoutSubcontrols];
}
-(void)controlWasActivated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(run:) name:@"UIReady" object:nil];
    [self SMLayoutSubcontrols];
    [super controlWasActivated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UIReady" object:nil userInfo:nil];
}
-(void)run:(NSNotification*)note
{
    NSLog(@"1");
    BOOL isDir;
    BOOL dirExists=NO;
    if([[NSFileManager defaultManager]fileExistsAtPath:[[NSString stringWithFormat:@"~/Documents/ATV%@",_version,nil]stringByExpandingTildeInPath]isDirectory:&isDir]
       &&isDir)
        dirExists=YES;
    if(!dirExists)
        NSLog(@"dir does not Exist");
    if(![[_infoDictionary objectForKey:UCANDLOS] boolValue])
        NSLog(@"cannot downloadOS");
    if(!dirExists && ![[_infoDictionary objectForKey:UCANDLOS] boolValue])
    {
        [[self stack]swapController:[BRAlertController alertOfType:0 
                                                            titled:[NSString stringWithFormat:@"Error"]
                                                       primaryText:[NSString stringWithFormat:@"OS %@ is not available anymore on apple servers",_version] 
                                                     secondaryText:nil]];
        return;
    }
    if(!dirExists)
    {
        [[NSFileManager defaultManager]createDirectoryAtPath:[[NSString stringWithFormat:@"~/Documents/ATV%@",_version,nil]stringByExpandingTildeInPath] attributes:nil];
    }
    NSMutableArray *md5s=[self getMD5s];
    NSMutableArray *URLs=[self getURLs];
    NSMutableArray *newMD5=[[NSMutableArray alloc]init];
    NSMutableArray *newURL=[[NSMutableArray alloc]init];
    int i;
    NSFileManager *man = [NSFileManager defaultManager];
    NSLog(@"bla");
    for(i=0;i<[URLs count];i++)
    {
        
        NSString *url = [URLs objectAtIndex:i];
        NSString *md5 = [md5s objectAtIndex:i];
        NSString *folder = [[NSString stringWithFormat:@"~/Documents/ATV%@",_version,nil] stringByExpandingTildeInPath];
        if(![[url pathExtension]isEqualToString:@"dmg"])
        {   
            if(![[NSFileManager defaultManager] fileExistsAtPath:[folder stringByAppendingPathComponent:[url lastPathComponent]]])
            {
                [newMD5 addObject:md5];
                [newURL addObject:url];
                NSLog(@"%@ not found",[url lastPathComponent]);
                [self addText:[NSString stringWithFormat:@"%@ not found",[url lastPathComponent],nil]];
            }
            else if(![self checkmd5ForURL:url withExpectedmd5:md5])
            {
                [newMD5 addObject:md5];
                [newURL addObject:url];
                [man removeFileAtPath:[folder stringByAppendingPathComponent:[url lastPathComponent]] handler:nil];
                NSLog(@"%@ found but wrong md5, deleting",[url lastPathComponent]);
                [self addText:[NSString stringWithFormat:@"%@ found but wrong md5, deleting",[url lastPathComponent],nil]];
            }
            else {
                NSLog(@"%@ has correct md5",[url lastPathComponent]);
                [self addText:[NSString stringWithFormat:@"%@ has correct md5",[url lastPathComponent],nil]];
            }

        }
        else 
        {
            BOOL cont=YES;
            NSString *filename;
            if ([man fileExistsAtPath:[folder stringByAppendingPathComponent:@"OS.dmg"]]) 
            {
                [self addText:@"found OS.dmg"];
                filename=@"OS.dmg";
                
            }
            else if ([man fileExistsAtPath:[folder stringByAppendingPathComponent:[NSString stringWithFormat:@"OS%@.dmg",_version,nil]]])
            {
                [self addText:[NSString stringWithFormat:@"found OS%@.dmg",_version]];
                filename=[NSString stringWithFormat:@"OS%@.dmg",_version,nil];
            }
            else if ([man fileExistsAtPath:[folder stringByAppendingPathComponent:[url lastPathComponent]]])
            {
                [self addText:[NSString stringWithFormat:@"found %@",[url lastPathComponent],nil]];
                filename=[url lastPathComponent];
            }
            else if (![[_infoDictionary objectForKey:UCANDLOS] boolValue]){
                [[self stack]swapController:[BRAlertController alertOfType:0 
                                                                    titled:[NSString stringWithFormat:@"Error"]
                                                               primaryText:[NSString stringWithFormat:@"OS %@ is not available anymore on apple servers",_version] 
                                                             secondaryText:nil]];
                
            }
            else {
                [self addText:@"No os dmg found"];
                [newMD5 addObject:md5];
                [newURL addObject:url];
                cont=NO;
            }
            if (cont) {
                if(![self checkmd5ForFile:[folder stringByAppendingPathComponent:filename] withExpectedmd5:md5])
                {
                    if(![[_infoDictionary objectForKey:UCANDLOS]boolValue])
                    {
                        [[self stack]swapController:[BRAlertController alertOfType:0 
                                                                            titled:[NSString stringWithFormat:@"Error"]
                                                                       primaryText:[NSString stringWithFormat:@"OS %@ is not available anymore on apple servers",_version] 
                                                                     secondaryText:[NSString stringWithFormat:@"Wrong md5 on file: %@",[folder stringByAppendingPathComponent:filename],nil]]];
                        
                    }
                    
                    [newMD5 addObject:md5];
                    [newURL addObject:url]; 
                    [self addText:[NSString stringWithFormat:@" wrong md5 on %@",filename ]];
                }
                else
                {
                    [self addText:[NSString stringWithFormat:@" %@ has correct md5",filename]];
                    [man movePath:[folder stringByAppendingPathComponent:filename] toPath:[folder stringByAppendingPathComponent:@"OS.dmg"] handler:nil];
                }
                
            }
            

                 
                 
        }

    }
    [_spinner setSpins:NO];
    NSLog(@"Done");
    SMUpdaterDownload *a = [[SMUpdaterDownload alloc] initWithFiles:newURL withImage:[BRImage imageWithPath:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/Downloads.png"] withTitle:@"Downloading Files" withVersion:_version];
    [a setmd5Array:newMD5];
    [a setCheckMD5:YES];
    [a setForceDestination:YES];
    [[self stack] swapController:a];
    
        
}
-(BOOL)checkmd5ForFile:(NSString *)path withExpectedmd5:(NSString *)md5
{
    
    //NSLog(@"%@ %s", self, _cmd);
    NSTask *mdTask = [[NSTask alloc] init];
    NSPipe *mdip = [[NSPipe alloc] init];
    NSString *fullPath = path;
    NSFileHandle *mdih = [mdip fileHandleForReading];
    [mdTask setLaunchPath:@"/sbin/md5"];
    
    [mdTask setArguments:[NSArray arrayWithObjects:@"-q", fullPath, nil]];
    [mdTask setStandardOutput:mdip];
    [mdTask setStandardError:mdip];
    [mdTask launch];
    [mdTask waitUntilExit];
    NSData *outData;
    outData = [mdih readDataToEndOfFile];
    NSString *temp = [[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding];
    temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //int theTerm = [mdTask terminationStatus];
    //NSLog(@"md5: %@", temp);
    NSLog(@"file: %@",path);
    NSLog(@"expected md5: %@",md5);
    NSLog(@"returned md5: %@",temp);
    if ([temp isEqualToString:md5])
    {
        //NSLog(@"file at %@ is OK", path);
        return YES;
        
    }
    
    return NO;
}
-(BOOL)checkmd5ForURL:(NSString *)url withExpectedmd5:(NSString *)md5
{
    NSString *filename = [url lastPathComponent];
    NSString *folder = [[NSString stringWithFormat:@"~/Documents/ATV%@",_version] stringByExpandingTildeInPath];
    return [self checkmd5ForFile:[folder stringByAppendingPathComponent:filename] withExpectedmd5:md5];
    
}
-(NSMutableArray *)getURLs
{
    NSMutableArray *dLinks = [[NSMutableArray alloc]init];
    [dLinks addObject:[[_infoDictionary valueForKey:@"OS"] valueForKey:@"UpdateURL"]];
	[dLinks addObject:[[_infoDictionary valueForKey:@"EFI"] valueForKey:@"InstallerURL"]];
	[dLinks addObject:[[_infoDictionary valueForKey:@"EFI"] valueForKey:@"UpdateURL"]];
	[dLinks addObject:[[_infoDictionary valueForKey:@"IR"] valueForKey:@"InstallerURL"]];
	[dLinks addObject:[[_infoDictionary valueForKey:@"IR"] valueForKey:@"UpdateURL"]];
	[dLinks addObject:[[_infoDictionary valueForKey:@"SI"] valueForKey:@"InstallerURL"]];
	[dLinks addObject:[[_infoDictionary valueForKey:@"SI"] valueForKey:@"UpdateURL"]];
    if ([[SMGeneralMethods sharedInstance]checkblocker]) {
        NSEnumerator *enumd=[dLinks objectEnumerator];
        NSMutableArray *dLinks2=[[NSMutableArray alloc]init];
        id obj;
        while (obj=[enumd nextObject]) {
            [dLinks2 addObject:[obj stringByReplacingAllOccurancesOfString:@"mesu.apple.com" withString:@"mesu.apple.com.edgesuite.net"]];
        }
        dLinks = dLinks2;
        
    }
    return [dLinks autorelease];
}
-(NSMutableArray *)getMD5s
{
    NSMutableArray *md5s = [[NSMutableArray alloc] init];
    [md5s addObject:[[_infoDictionary valueForKey:@"OS"] valueForKey:@"md5OS"]];
	[md5s addObject:[[_infoDictionary valueForKey:@"EFI"] valueForKey:@"md5EFIins"]];
	[md5s addObject:[[_infoDictionary valueForKey:@"EFI"] valueForKey:@"md5EFIupd"]];
	[md5s addObject:[[_infoDictionary valueForKey:@"IR"] valueForKey:@"md5IRins"]];
	[md5s addObject:[[_infoDictionary valueForKey:@"IR"] valueForKey:@"md5IRupd"]];
	[md5s addObject:[[_infoDictionary valueForKey:@"SI"] valueForKey:@"md5SIins"]];
	[md5s addObject:[[_infoDictionary valueForKey:@"SI"] valueForKey:@"md5SIupd"]];
    return [md5s autorelease];
}
-(void)addText:(NSString *)text
{
    NSLog(@"text: %@",text);
    CGRect masterFrame = [self getMasterFrame];
    CGRect frame;
    BRTextControl *textC = [[BRTextControl alloc] init];
    [textC setText:text withAttributes:[[BRThemeInfo sharedTheme] metadataTitleAttributes]];
    frame.size = [textC preferredFrameSize];
    frame.origin.x=masterFrame.origin.x+masterFrame.size.width*0.13f;
    if(frame.size.width>masterFrame.size.width*0.65f)
        frame.size.width=masterFrame.size.width*0.65f;
    if([_textControls count]==0)
        frame.origin.y=masterFrame.size.height*0.7f;
    else
    {
        CGRect oldframe=[[_textControls lastObject] frame];
        frame.origin.y=oldframe.origin.y-frame.size.height*1.1f;
    }
    [textC setFrame:frame];
    //[textC retain];
    [self addControl:textC];
    [_textControls addObject:textC];
    [self setArrowForRect:frame];
}
-(void)setArrowForRect:(CGRect)frame
{
    [_arrowControl removeFromParent];
    BRImage *arrow=[[BRThemeInfo sharedTheme] folderIcon];
    CGRect newFrame;
    newFrame.size.height=frame.size.height;
    newFrame.size.width = frame.size.height*[arrow aspectRatio];
    newFrame.origin.x=frame.origin.x-newFrame.size.width*1.5f;
    newFrame.origin.y=frame.origin.y;
    [_arrowControl setFrame:newFrame];
    [self addControl:_arrowControl];
    
}
-(void)dealloc
{
    [self _removeAllControls];
    [_arrowControl release];
    [_textControls release];
    [_headerControl release];
    [_spinner release];
    [_version release];
    [_title release];
    [_infoDictionary release];
    [super dealloc];
}
@end


