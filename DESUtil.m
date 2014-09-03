//
//  DESUtil.m
//  SmartSwitch
//
//  Created by sdzg on 14-9-2.
//  Copyright (c) 2014年 itouchco.com. All rights reserved.
//

#import "DESUtil.h"
#import <CommonCrypto/CommonCryptor.h>

#define LocalStr_None @""

@implementation DESUtil
static NSString *key = @"alkertyu";
static Byte iv[] = {1, 2, 3, 4, 5, 6, 7, 8};

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key {
  char keyPtr[kCCKeySizeAES256 + 1];
  bzero(keyPtr, sizeof(keyPtr));

  [key getCString:keyPtr
        maxLength:sizeof(keyPtr)
         encoding:NSUTF8StringEncoding];

  NSUInteger dataLength = [data length];

  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);

  size_t numBytesEncrypted = 0;
  CCCryptorStatus cryptStatus =
      CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding, keyPtr,
              kCCBlockSizeDES, iv, [data bytes], dataLength, buffer, bufferSize,
              &numBytesEncrypted);
  if (cryptStatus == kCCSuccess) {
    return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
  }

  free(buffer);
  return nil;
}

/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key {
  char keyPtr[kCCKeySizeAES256 + 1];
  bzero(keyPtr, sizeof(keyPtr));

  [key getCString:keyPtr
        maxLength:sizeof(keyPtr)
         encoding:NSUTF8StringEncoding];

  NSUInteger dataLength = [data length];

  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);

  size_t numBytesDecrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(
      kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode,
      keyPtr, kCCBlockSizeDES, iv, [data bytes], dataLength, buffer, bufferSize,
      &numBytesDecrypted);

  if (cryptStatus == kCCSuccess) {
    return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
  }

  free(buffer);
  return nil;
}

+ (NSString *)encryptString:(NSString *)string {
  if (string && ![string isEqualToString:LocalStr_None]) {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // IOS 自带DES加密 Begin
    data = [self DESEncrypt:data WithKey:key];
    // IOS 自带DES加密 End
    Byte *byte = (Byte *)[data bytes];
    return [self parseByte2HexString:byte];
  } else {
    return LocalStr_None;
  }
}

+ (NSString *)decryptString:(NSString *)string {
  if (string && ![string isEqualToString:LocalStr_None]) {
    //    NSData *data = [self dataWithBase64EncodedString:base64];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // IOS 自带DES解密 Begin
    data = [self DESDecrypt:data WithKey:key];
    // IOS 自带DES加密 End
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  } else {
    return LocalStr_None;
  }
}

+ (NSString *)parseByte2HexString:(Byte *)bytes {
  NSMutableString *hexStr = [[NSMutableString alloc] init];
  int i = 0;
  if (bytes) {
    while (bytes[i] != '\0') {
      NSString *hexByte =
          [NSString stringWithFormat:@"%x", bytes[i] & 0xff];  /// 16进制数
      if ([hexByte length] == 1)
        [hexStr appendFormat:@"0%@", hexByte];
      else
        [hexStr appendFormat:@"%@", hexByte];

      i++;
    }
  }
  return hexStr;
}

+ (NSString *)parseByteArray2HexString:(Byte[])bytes {
  NSMutableString *hexStr = [[NSMutableString alloc] init];
  int i = 0;
  if (bytes) {
    while (bytes[i] != '\0') {
      NSString *hexByte =
          [NSString stringWithFormat:@"%x", bytes[i] & 0xff];  /// 16进制数
      if ([hexByte length] == 1)
        [hexStr appendFormat:@"0%@", hexByte];
      else
        [hexStr appendFormat:@"%@", hexByte];

      i++;
    }
  }
  return hexStr;
}

@end