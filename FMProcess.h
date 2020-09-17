//11
//  FMProcess.h
//  FileMonitor
//2
//  Created by Zhai,Yupeng on 2017/12/7.
//  Copyright © 2017年 Zhai,Yupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSocket.h"

@interface FMProcess : NSObject

@property NSString* name;
@property int ppid;
@property int status;
@property NSMutableArray* childs;
@property NSMutableArray* sockets;

- (id) init;
- (id) initWithValue:(NSString*)name ppid:(int)ppid status:(int)status;

- (void) addChild:(int)child;
@end
