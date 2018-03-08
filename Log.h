//
//  Log.h
//  FileMonitor
//
//  Created by System Administrator on 2017/11/16.
//  Copyright © 2017年 Zhai,Yupeng. All rights reserved.
//
#define LogFormat(text)  [NSString stringWithFormat:@"[%@:%d] %@\n",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,text]

#import <Foundation/Foundation.h>

@interface Log : NSObject
+ (void)FMLog:(NSString*)text inType:(NSString*)type;
@end
