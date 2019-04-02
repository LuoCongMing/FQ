//
//  NSString+TRHString.h
//  Trh
//
//  Created by 周建波 on 2018/9/13.
//  Copyright © 2018年 Trh_周建波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TRHString)
+ (BOOL)adjustIfEqualToPhoneNumberWithString:(NSString *)phoneNumber;
// 将数字转为每隔3位整数由逗号“,”分隔的字符串
+ (NSString *)separateNumberUseCommaWith:(NSString *)number;
+ (NSString *)emojiDealWithString:(NSString*)string;
///手机号中间4位*号处理
+ (NSString *)dealphonenum:(NSString*)phoneNum;
@end
