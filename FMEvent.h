	//
//  FMEvent.h
//  FileMonitor
//
//  Created by System Administrator on 2017/11/15.
//  Copyright © 2017年 Zhai,Yupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMEvent : NSObject

@property NSString* filePath;
@property NSString* processPath;
@property int processPid;
@property int eventType;

+(void) initEventTypeDic;
+(NSString*) getEventType:(int) event;
@end
