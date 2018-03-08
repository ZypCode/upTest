//
//  FMEvent.m
//  FileMonitor
//
//  Created by System Administrator on 2017/11/15.
//  Copyright © 2017年 Zhai,Yupeng. All rights reserved.
//

#import "FMEvent.h"
#include <bsm/libbsm.h>

@implementation FMEvent

@synthesize filePath;
@synthesize processPath;
@synthesize processPid;
@synthesize eventType;

NSMutableDictionary* eventTypeDic;

+(void) initEventTypeDic{
    
    eventTypeDic = [[NSMutableDictionary alloc]init];
    
    FILE * fp;
    char * line = NULL;
    size_t len = 0;
    ssize_t read;
    
    fp = fopen(AUDIT_EVENT_FILE, "r");
    if (fp == NULL)
        return;
    
    while ((read = getline(&line, &len, fp)) != -1) {
        //Getting the line of the event.
        if (!startsWith("#", line)&&strcmp(line, "\n")!=0) {
            char* segment = strtok(line, ":");
            
            //找到event的ID
            char* eventID = segment;
            
            segment = strtok(0, ":");
            segment = strtok(0, ":");
            //Eliminating the content after "(" to return a nicer output
            char *p = strchr(segment, '(');
            if (p){
                *p = 0;
            }
            
            [eventTypeDic setValue:[NSString stringWithUTF8String:segment] forKey:[NSString stringWithUTF8String:eventID]];
        }
    }
    fclose(fp);
}

+(NSString*) getEventType:(int) event{
    switch (event) {
        case 1:
            return @"exit";
        case 14:
            return @"access";
        case 22:
            return @"readlink";
        case 72:
            return @"open/read";
        case 112:
            return @"close";
    }
    NSString *eventID = [NSString stringWithFormat:@"%d",event];
    
    NSString * eventName = [eventTypeDic objectForKey:eventID];
    if (eventName != nil) {
        return eventName;
    }else{
        return @"N/A";
    }
}

@end
