//
//  installHelper2.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/27/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//



int main (int argc, const char * argv[]) {

    int i;
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	NSRunLoop *rl = [NSRunLoop currentRunLoop];
    [rl configureAsServer];
    NSString *path = [NSString stringWithUTF8String:argv[0]];
    if (argc < 2){
		printf("Segmentation Fault");
		printf("\n");
	}
    NSString *output = @"/";
    for(i=1;i<(argc - 1);i++)
    {
        NSString *option = [NSString stringWithUTF8String:argv[i]];
        if([option isEqualToString:@"-o"])
            output=[NSString stringWithUTF8String:argv[i++]];
    }
}