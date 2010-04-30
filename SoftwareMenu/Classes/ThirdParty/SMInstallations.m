//
//  SMInstallations.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/28/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMInstallations.h"
#import <SoftwareMenuFramework/SMFDelegatedDownloader.h>

@implementation SMInstallations

-(id)init
{
    self=[super init];
    [self setTitle:BRLocalizedString(@"Installs",@"Installs")];
    BRTextMenuItemLayer *_item = [BRTextMenuItemLayer networkMenuItem];
    _item = [BRTextMenuItemLayer networkMenuItem];
    [_item setTitle:BRLocalizedString(@"Load Packages",@"Load Packages")];
    [_items addObject:_item];
    [_options addObject:[NSNumber numberWithInt:SMInstallCheck]];
    [[self list] addDividerAtIndex:[_items count] withLabel:BRLocalizedString(@"Packages",@"Packages")];
    
    
    _item = [BRTextMenuItemLayer networkMenuItem];
    [_item setTitle:BRLocalizedString(@"Install Perian",@"Install Perian")];
    [_items addObject:_item];
    [_options addObject:[NSNumber numberWithInt:SMInstallPerian]];
    
    _item = [BRTextMenuItemLayer networkMenuItem];
    [_item setTitle:BRLocalizedString(@"Install Python",@"Install Python")];
    [_items addObject:_item];
    [_options addObject:[NSNumber numberWithInt:SMInstallPython]];
    currentInstall=SMInstallNone;
    return self;
    
}
-(void)itemSelected:(long)arg1
{
    SMInstall opt = [[_options objectAtIndex:arg1] intValue];
    if (opt == SMInstallCheck) {
        id cont= [[SMFSpinnerMenu alloc] initWithTitle:@"Awesome" text:@"Loading Packages"];
        [[self stack]pushController:cont];
        //[self loadPackages];
    }
    if (opt==SMInstallPerian) {
        NSXMLDocument *doc = [self fetchURL:@"http://www.perian.org/appcast.xml"];
        NSArray *val=[doc nodesForXPath:@"./rss/channel/item/enclosure" error:nil];
        NSString *a = [[[val objectAtIndex:0] attributeForName:@"url"] stringValue];
        DLog(@"perian URL: %@",a);
        SMFDelegatedDownloader * d=[[SMFDelegatedDownloader alloc] initWithFiles:[NSArray arrayWithObject:a] 
                                                                       withImage:[[SMThemeInfo sharedTheme]perianImage] 
                                                                       withTitle:@"Downloading Perian"];
        currentInstall=SMInstallPerian;
        [d setDelegate:self];
        [[self stack]pushController:d];
        [d release];
    }
    else if(opt==SMInstallPython)
    {
        id cont= [[SMFSpinnerMenu alloc] initWithTitle:@"Awesome" text:@"Loading Python Information"];
        [[self stack]pushController:cont];
        [cont release];
        NSDictionary *updates = [[SMGeneralMethods sharedInstance] fetchPlist:@"http://www.tomcool.org/SoftwareMenu/packages.plist"];
        if (updates==nil||![updates respondsToSelector:@selector(objectForKey:)]||[updates objectForKey:@"Python"]==nil) {
            id alert = [[BRAlertController alloc] initWithType:0
                                                        titled:@"Python Info Not Found" 
                                                   primaryText:@"Please Contact Thomas Cool" 
                                                 secondaryText:@"Me"];
            [[self stack]swapController:alert];
            [alert release];
            return;
            
        }
        
        NSString *a = [[updates objectForKey:@"Python"] objectForKey:@"URL"];
        SMFDelegatedDownloader * d=[[SMFDelegatedDownloader alloc] initWithFiles:[NSArray arrayWithObject:a] 
                                                                       withImage:[[SMThemeInfo sharedTheme] softwareMenuImage] 
                                                                       withTitle:@"Downloading Python"];
        currentInstall=SMInstallPython;
        [d setDelegate:self];
        [[self stack]pushController:d];
        [d release];
        
    }
}
-(NSXMLDocument *)fetchURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	NSURLResponse *response = nil;
    NSError *error;
	NSData *documentData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSXMLDocument *doc;
    if (error!=nil) {
        NSLog(@"error: %@",error);
        return [NSDictionary dictionary];
    }
    else {
        NSStringEncoding nsEncoding = NSUTF8StringEncoding; // default to UTF-8
        NSString *encoding = [response textEncodingName];
        if (encoding) {
            CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)encoding);
            if (cfEncoding != kCFStringEncodingInvalidId) {
                nsEncoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
            }
        }
        //NSStringEncoding responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)[response textEncodingName]));
        NSString *documentString = [[NSString alloc] initWithData:documentData encoding:nsEncoding];
        doc=[[NSXMLDocument alloc]initWithXMLString:documentString options:NSXMLDocumentTidyXML error:nil];
    }
    return doc;
}
-(void)downloadDidComplete:(NSArray *)files object:(SMFDelegatedDownloader *)cont
{
    NSLog(@"delegate called");
    if (currentInstall==SMInstallPerian) {
        [cont addText:BRLocalizedString(@"Installing Perian",@"Installing Perian")];
        [[SMHelper helperManager] installPerian:[files objectAtIndex:0]];
        [cont addText:BRLocalizedString(@"Done",@"Done")];
    }
    else if(currentInstall==SMInstallPython){
        [cont addText:BRLocalizedString(@"Installing Python",@"Installing Python")];
        [[SMHelper helperManager]installPython:[files objectAtIndex:0]];
        [cont addText:BRLocalizedString(@"Done",@"Done")];
        //[[SMHelper helperManager] installPerian:[files objectAtIndex:0
    }
    currentInstall=SMInstallNone;

}
@end
