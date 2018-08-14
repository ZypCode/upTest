//
//  AES.h
//  MacAptAgent
//
//  Created by Zhai,Yupeng on 2017/8/4.
//  Copyright © 2017年 Zheng,Jie(SMD). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AES : NSObject

+(NSData *)aes256ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text;   //加密
+(NSData *)aes256ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text;   //解密
+(NSString *) aes256_encrypt:(NSString *)key Encrypttext:(NSString *)text;
+(NSString *) aes256_decrypt:(NSString *)key Decrypttext:(NSString *)text;


@end
