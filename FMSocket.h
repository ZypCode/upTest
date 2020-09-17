//121231
//  FMSocket.h
//  FileMonitor
//
//  Created by Zhai,Yupeng on 2017/12/7.
//  Copyright © 2017年 Zhai,Yupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMSocket : NSObject

@property NSString* localIp;
@property int localPort;
@property NSString* remoteIp;
@property int remotePort;

@end
