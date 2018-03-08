//
//  FMProcess.m
//  FileMonitor
//
//  Created by Zhai,Yupeng on 2017/12/7.
//  Copyright © 2017年 Zhai,Yupeng. All rights reserved.
//

#import "FMProcess.h"

@implementation FMProcess

@synthesize name;
@synthesize ppid;
@synthesize status;
@synthesize childs;
@synthesize sockets;

- (id) init{
    if(self = [super init])
    {
        name = @"";
        ppid = -1;
        status = 0;
        childs = [[NSMutableArray alloc]init];
        sockets = nil;
    }
    return (self);
}

- (id) initWithValue:(NSString*)pName ppid:(int)pid status:(int)flag{
    if(self = [super init])
    {
        name = pName;
        ppid = pid;
        status = flag;
        childs = [[NSMutableArray alloc]init];
        sockets = nil;
    }
    return (self);
}

- (void) addChild:(int)child{
    [childs addObject:[NSNumber numberWithInt:child]];
}

@end
