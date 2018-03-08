//
//  Log.m
//  FileMonitor
//
//  Created by System Administrator on 2017/11/16.
//  Copyright © 2017年 Zhai,Yupeng. All rights reserved.
//

#import "Log.h"

@implementation Log
+ (void)FMLog:(NSString*)text inType:(NSString*)type{
    @autoreleasepool {
        NSFileManager * fileManager=[NSFileManager defaultManager];
        
        BOOL isDir;
        
        NSString * dirPath= @"/Users/zhaiyupeng/Desktop/FM";
        @synchronized(self) {
            if(!([fileManager fileExistsAtPath:dirPath isDirectory:&isDir] && isDir)){
                NSError * err = nil;
                [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&err];
            }
            
            NSDate * currentDate=[NSDate date];
            NSDate * deleteDate=[NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:currentDate];
            
            NSArray * logFileArray=[fileManager contentsOfDirectoryAtPath:dirPath error:nil];
            
            for (NSString * fileName in logFileArray) {
                if([fileName hasPrefix:@"fileMonitor"]){
                    NSString * filePath=[dirPath stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
                    NSDate *fileDate=[[fileManager attributesOfItemAtPath:filePath error:nil] objectForKey:NSFileCreationDate];
                    
                    if([fileDate compare:deleteDate]==NSOrderedAscending){
                        [fileManager removeItemAtPath:filePath error:nil];
                    }
                }
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *strCurrentDate = [dateFormatter stringFromDate:currentDate];
            
            NSString *fileCurrentDate=[strCurrentDate substringToIndex:10];
            
            NSString * logFileName=[NSString stringWithFormat:@"fileMonitor.%@.%@",fileCurrentDate,type];
            
            NSString * logFilePath=[dirPath stringByAppendingString:[NSString stringWithFormat:@"/%@",logFileName]];
            
            text = [NSString stringWithFormat:@"[%@]%@\n",strCurrentDate,text];
            NSData *data= [text dataUsingEncoding:NSUTF8StringEncoding];
            BOOL b;
            
            if(![fileManager fileExistsAtPath:logFilePath]){
                b=[fileManager createFileAtPath:logFilePath contents:nil attributes:nil];
            }
            
            NSFileHandle *logFileHandler;
            
            logFileHandler=[NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
            
            [logFileHandler seekToEndOfFile];
            [logFileHandler writeData:data];
            [logFileHandler closeFile];
            
        }
    }
}

@end
