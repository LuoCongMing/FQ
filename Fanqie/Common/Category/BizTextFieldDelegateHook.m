//
//  BizTextField+DelegateHook.m
//  POS
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 www.xiaoguantea.com. All rights reserved.
//

#import "BizTextFieldDelegateHook.h"

@implementation BizTextFieldDelegateHook
-(instancetype)init{
    self = [super init];
    self.bizType = BizTextFieldTypeWithoutCN;
    self.bizMaxLength = 100;
    return self;
}

-(void)textFieldDidChange:(UITextField*)textfield{
    if (self.bizMaxLength<textfield.text.length) {
        textfield.text = [textfield.text substringToIndex:self.bizMaxLength-1];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField routerEventWithName:@"Editing" dataInfo:nil];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField routerEventWithName:@"endEditing" dataInfo:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.textfieldReturn) {
        self.textfieldReturn(textField.text);
    }
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    switch (self.bizType) {
        case BizTextFieldTypeNum:
        {
            
            if ([self stringIsNum:string]) {
                if (range.location==0&&([string isEqualToString:@"."]||[string isEqualToString:@"0"])) {
                    return NO;
                }
                if ([textField.text containsString:@"."]) {
                    NSArray * array = [textField.text componentsSeparatedByString:@"."];
                    if (array.count==2) {
                        NSString*last = array.lastObject;
                        if (last.length==2) {
                            return NO;
                        }
                    }
                }
                
                return YES;
            }else{
                return NO;
            }
          
        }
            break;
        case BizTextFieldTypeWithoutEmoji:
        {
            
            return ![self stringContainsEmoji:string];
        }
            break;
        case BizTextFieldTypeWithoutCN:
        {
            if ([self stringContainsEmoji:string]) {
                return NO;
            }
            return ![self stringContainCN:string];
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}


//是否包含中文
-(BOOL)stringContainCN:(NSString*)text{
    for(int i=0; i< [text length];i++){
        int a = [text characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
//判断是否全是数字
-(BOOL)stringIsNum:(NSString*)text{
    for (int i = 0 ; i<text.length; i++) {
        NSString*string = [text substringWithRange:NSMakeRange(i, 1)];
        if ([string intValue]||[string isEqualToString:@"."]||[string isEqualToString:@"0"]) {
//            return YES;
        }else{
            return NO;
        }
    }

//    if (text) {
//        NSString*predicateString = @"^[1-9]*.?[0-9]*";
//        NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",predicateString];
//
//        return  [predicate evaluateWithObject:text];
//    }else{
//
//    }
    return YES;
}
//判断NSString字符串是否包含emoji表情
//判断是否有emoji
-(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
//                                    if (0x2100 <= high && high <= 0x27BF){
//                                        returnValue = YES;
//                                    }
                                }
                            }];
    
    return returnValue;
}

@end
