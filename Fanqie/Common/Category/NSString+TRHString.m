//
//  NSString+TRHString.m
//  Trh
//
//  Created by 周建波 on 2018/9/13.
//  Copyright © 2018年 Trh_周建波. All rights reserved.
//

#import "NSString+TRHString.h"

@implementation NSString (TRHString)
+ (BOOL)adjustIfEqualToPhoneNumberWithString:(NSString *)phoneNumber {
    
    NSString * NUM = @"^((13)|(14)|(15)|(16)|(17)|(18)|(19))[0-9]{9}$";
    NSPredicate * predicate_num = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",NUM];
    BOOL ct = [predicate_num evaluateWithObject:phoneNumber];
    
    //   NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    //   NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    //   NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    
    //    NSPredicate * predicate_cm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    //    NSPredicate * predicate_cu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    //    NSPredicate * predicate_ct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    //    BOOL cm = [predicate_cm evaluateWithObject:phoneNumber];
    //    BOOL cu = [predicate_cu evaluateWithObject:phoneNumber];
    //    BOOL ct = [predicate_ct evaluateWithObject:phoneNumber];
    
    return ct;
}
// 将数字转为每隔3位整数由逗号“,”分隔的字符串
+ (NSString *)separateNumberUseCommaWith:(NSString *)number {
    // 前缀
//    NSString *prefix = @"-";
//    // 后缀
//    NSString *suffix = @"元";
    // 分隔符
    NSString *divide = @",";
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([number containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [number componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = number;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
//    if (![prefix isEqualToString:@""]) {
//        newNumber = [NSString stringWithFormat:@"%@%@",prefix,newNumber];
//    }
//    if (![suffix isEqualToString:@""]) {
//        newNumber = [NSString stringWithFormat:@"%@%@",newNumber,suffix];
//    }
    return newNumber;
}

+(NSString*)emojiDealWithString:(NSString *)string{
    if ([string containsString:@"[["]) {
        NSArray*array = [string componentsSeparatedByString:@"[["];
        NSMutableString*resultString = [[NSMutableString alloc]initWithFormat:@"%@",array.firstObject];
        for (int i = 1; i<array.count; i++) {
            NSMutableString*mString = [[NSMutableString alloc]initWithFormat:@"%@",array[i]];
            NSArray* secondArray = [mString componentsSeparatedByString:@"]]"];
            NSString*urlString = secondArray.firstObject;
            NSString*decode = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)urlString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
            [resultString appendString:decode];
        }
            
            return resultString;
        
    }
    
    return string;
    
}
+(NSString*)dealphonenum:(NSString *)phoneNum{
    NSMutableString*mString = [[NSMutableString alloc]init];
    if (phoneNum.length==11) {
        mString = [NSMutableString stringWithFormat:@"%@****%@",[phoneNum substringToIndex:3],[phoneNum substringFromIndex:7]];
    }
    return mString;
}
@end
