//
//  HDCommonTools+encrypt.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/23.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

///aes
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES256;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4
static Byte saltBuff[] = {0,1,2,3,4,5,6,7,8,9,0xA,0xB,0xC,0xD,0xE,0xF};
static Byte ivBuff[]   = {0xA,1,0xB,5,4,0xF,7,9,0x17,3,1,6,8,0xC,0xD,91};

@implementation HDCommonTools (Encrypt)
///字符串MD5加密
- (NSString *)MD5EncryptWithString:(NSString *)string withLowercase:(BOOL)lowercase {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString string];
    for(int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    if (lowercase) {
        return output;
    } else {
        return [output uppercaseString];
    }
}

- (NSString *)SHAEncryptWithString:(NSString *)string withType:(HDSHAEncryType)shaType withLowercase:(BOOL)lowercase {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *output = [NSMutableString string];
    
    switch (shaType) {
        case kHDSHAEncryTypeSha1: {
            uint8_t digest[CC_SHA1_DIGEST_LENGTH];
            CC_SHA1(data.bytes, (unsigned int)data.length, digest);
            for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
                [output appendFormat:@"%02x", digest[i]];
            }
        }
            break;
        case kHDSHAEncryTypeSha224: {
            uint8_t digest[CC_SHA224_DIGEST_LENGTH];
            CC_SHA224(data.bytes, (unsigned int)data.length, digest);
            for(int i=0; i<CC_SHA224_DIGEST_LENGTH; i++) {
                [output appendFormat:@"%02x", digest[i]];
            }
        }
            break;
        case kHDSHAEncryTypeSha256: {
            uint8_t digest[CC_SHA256_DIGEST_LENGTH];
            CC_SHA256(data.bytes, (unsigned int)data.length, digest);
            for(int i=0; i<CC_SHA256_DIGEST_LENGTH; i++) {
                [output appendFormat:@"%02x", digest[i]];
            }
        }
            break;
        case kHDSHAEncryTypeSha384: {
            uint8_t digest[CC_SHA384_DIGEST_LENGTH];
            CC_SHA384(data.bytes, (unsigned int)data.length, digest);
            for(int i=0; i<CC_SHA384_DIGEST_LENGTH; i++) {
                [output appendFormat:@"%02x", digest[i]];
            }
        }
            break;
        case kHDSHAEncryTypeSha512: {
            uint8_t digest[CC_SHA512_DIGEST_LENGTH];
            CC_SHA512(data.bytes, (unsigned int)data.length, digest);
            for(int i=0; i<CC_SHA512_DIGEST_LENGTH; i++) {
                [output appendFormat:@"%02x", digest[i]];
            }
        }
            break;
        default:
            break;
    }
    
    if (lowercase) {
        return output;
    } else {
        return [output uppercaseString];
    }
}
#pragma mark -
#pragma mark - AES加密

- (NSData *)AESKeyForPassword:(NSString *)password {                  //Derive a key from a text password/passphrase
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    NSData *salt = [NSData dataWithBytes:saltBuff length:kCCKeySizeAES128];
    int result = CCKeyDerivationPBKDF(kCCPBKDF2,        // algorithm算法
                                      password.UTF8String,  // password密码
                                      password.length,      // passwordLength密码的长度
                                      salt.bytes,           // salt内容
                                      salt.length,          // saltLen长度
                                      kCCPRFHmacAlgSHA1,    // PRF
                                      kPBKDFRounds,         // rounds循环次数
                                      derivedKey.mutableBytes, // derivedKey
                                      derivedKey.length);   // derivedKeyLen derive:出自
    if (result != kCCSuccess) {
        NSAssert(NO,@"Unable to create AES key for spassword: %d", result);
    }
    return derivedKey;
}
///字符串aes256加密
//String aes256 encryption
- (NSString *)AES256EncryptWithPlainText:(NSString *)plain andKey:(NSString *)key {
    NSData *plainText = [plain dataUsingEncoding:NSUTF8StringEncoding];
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    NSUInteger dataLength = [plainText length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer));
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding,
                                          [[self AESKeyForPassword:key] bytes], kCCKeySizeAES256,
                                          ivBuff /* initialization vector (optional) */,
                                          [plainText bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [self base64Encodings:encryptData];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

///字符串aes256解密
//String aes256 Decrypted
- (NSString *)AES256DecryptWithCiphertext:(NSString *)ciphertexts andKey:(NSString *)key {
    NSData *cipherData = [self dataWithBase64EncodedString:ciphertexts];
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    NSUInteger dataLength = [cipherData length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          [[self AESKeyForPassword:key] bytes], kCCKeySizeAES256,
                                          ivBuff ,/* initialization vector (optional) */
                                          [cipherData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding] init];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (id)dataWithBase64EncodedString:(NSString *)string {
    if (string == nil)
        NSAssert(NO,@"string is nil");
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
        {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
        }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
        {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
            {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
                {
                free(bytes);
                return nil;
                }
            }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
            {
            free(bytes);
            return nil;
            }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
        }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

- (NSString *)base64Encodings:(NSData *)data {
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length]) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else
            characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else
            characters[length++] = '=';
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] init];
}

///字符串转unicode
- (NSString *)unicodeEncodeWithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

///unicode转字符串
- (NSString *)unicodeDecodeWithString:(NSString *)string {
    NSString *tempStr1=[string stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2=[tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3=[[@"\"" stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData=[tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:&error];
    if (!error) {
        return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    } else {
        return string;
    }
}
@end
