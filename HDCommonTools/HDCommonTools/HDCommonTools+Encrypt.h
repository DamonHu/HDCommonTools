//
//  HDCommonTools+encrypt.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/23.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"

@interface HDCommonTools (Encrypt)
#pragma mark -
#pragma mark - 加密解密相关操作类

/**
 字符串MD5加密
 @param str 要加密的字符串
 @param lowercase 是否小写
 @return 加密过的字符串
 */
- (NSString*)getMD5withStr:(NSString*)str lowercase:(BOOL)lowercase;


/**
 字符串aes256加密
 @param plain 要加密的字符串
 @param key 加密的key值
 @return 加密后的字符串
 */
- (NSString *)AES256EncryptWithPlainText:(NSString *)plain andKey:(NSString*)key;


/**
 字符串aes256解密

 @param ciphertexts 要解密的字符串
 @param key 加密的key值
 @return 解密后的字符串
 */
- (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts andKey:(NSString*)key;
@end
