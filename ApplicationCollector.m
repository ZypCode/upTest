//
//  ApplicationCollector.m
//  MacAptAgent
//
//  Created by Ding,Jie(SMD) on 2017/6/28.
//  Copyright © 2017年 Zheng,Jie(SMD). All rights reserved.
//

#import "Log1.h"
#import "APPInfo.h"
#import "ApplicationCollector.h"

static NSMutableArray * applicationArrayCache=nil;

@implementation ApplicationCollector

+ (NSMutableArray *)collectApplication:(NSString *)path{
    if(applicationArrayCache==nil){
        applicationArrayCache=[self collectApplicationArray:path];
        return applicationArrayCache;
    }else{
        NSMutableArray *applicationArray=[self collectApplicationArray:path];
        NSMutableArray *applicationArrayTemp=[applicationArray copy];
        [applicationArray removeObjectsInArray:applicationArrayCache];
        applicationArrayCache=applicationArrayTemp;
        return applicationArray;
    }
}

+ (NSMutableArray *)collectApplicationArray:(NSString *)path{
    @autoreleasepool {
        if(!([[NSFileManager defaultManager] fileExistsAtPath:path])){
            [Log logformat:LogFormat(@"File not exists at path:%@"),path];
            return nil;
        }
        
        NSMutableArray * applicationArray=[NSMutableArray arrayWithCapacity:32];
        [ApplicationCollector collectPath:path array:applicationArray];
        
        for (int i=0; i<[applicationArray count]; ) {
            @autoreleasepool{
                NSString * appPath=[applicationArray[i] path];
                
                NSRange slashRange=[appPath rangeOfString:@"/" options:NSBackwardsSearch];
                NSString * appName=[appPath substringFromIndex:slashRange.location+1];
                
                NSFileManager *fileManager =[NSFileManager defaultManager];
                
                if(![fileManager fileExistsAtPath:appPath]){
                    [applicationArray removeObjectAtIndex:i];
                    continue;
                }
                
                NSDate *fileDate=[[fileManager attributesOfItemAtPath:appPath error:nil] objectForKey:NSFileModificationDate];
                
                [applicationArray[i] setAppName:appName];
                
                [applicationArray[i] setCreationDate:fileDate];
                
                [applicationArray[i] setHashCodeAndMD5];
                
                [applicationArray[i] setSignAndBundleId];
                
                i++;
                [NSThread sleepForTimeInterval:0.03];
            }
        }
        return applicationArray;
    }
}

+ (void)collectPath:(NSString *)path array:(NSMutableArray * )applicationArray{
    //    @autoreleasepool {
    //        Class LSApplicationWorkspace_class = NSClassFromString(@"LSApplicationWorkspace");
    //        NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    //        NSArray *appList = [workspace performSelector:@selector(allApplications)];
    //
    //        for (id proxy in appList){
    //            //这里可以查看一些信息_bundleURL
    //            NSString *bundleID = [proxy performSelector:@selector(applicationIdentifier)];
    //            NSURL *bundleURL =  [proxy performSelector:@selector(bundleURL)];
    //            NSString * str=[bundleURL absoluteString];
    //            NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    //            NSString *shortVersionString =  [proxy performSelector:@selector(shortVersionString)];
    //            NSLog(@"bundleID：%@\n,bundleURL:%@\n,shortVersionString:%@\n", bundleID,bundleURL,shortVersionString);
    //            if(bundleURL!=nil){
    //                APPInfo * appInfo= [[APPInfo alloc] init];
    //                appInfo.path=[decodedString substringFromIndex:7];
    //                [applicationArray addObject:appInfo];
    //            }
    //        }
    //    }
    @autoreleasepool {
        if([path hasSuffix:@".DS_Store"]){
            return;
        }
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if(!([fileManager fileExistsAtPath:path])){
            [Log logformat:LogFormat(@"File not exists at path:%@"),path];
            return;
        }
        BOOL isDir = NO;
        [fileManager fileExistsAtPath:path isDirectory:&isDir];
        BOOL isAPP =[APPInfo isValidAPP:path];
        
        
        if (isDir&&!(isAPP)) {
            NSArray * dirArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
            
            for (NSString * str in dirArray) {
                @autoreleasepool{
                    NSString *  subPath  = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",str]];
                    NSDictionary * dic=[fileManager attributesOfItemAtPath:subPath error:nil];
                    
                    //                NSLog(@"%@",subPath);
                    //                NSLog(@"%@",dic[NSFileType]);
                    if(![dic[NSFileType] isEqualToString:@"NSFileTypeSymbolicLink"]){
                        [self collectPath:subPath array:applicationArray];
                    }
                }
            }
        }else if(isAPP){
            APPInfo * appInfo= [[APPInfo alloc] init];
            appInfo.path=path;
            [applicationArray addObject:appInfo];
            
        }
    }
}

@end
