//
//  BizTextField+DelegateHook.h
//  POS
//
//  Created by mac on 2018/8/10.
//  Copyright © 2018年 www.xiaoguantea.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BizTextFieldType){
    BizTextFieldTypeNum,//限制只能输入数字
    BizTextFieldTypeWithoutEmoji,//不能输入表情
    BizTextFieldTypeWithoutCN//不能输入中文和表情
    
};
@interface BizTextFieldDelegateHook : NSObject<UITextFieldDelegate>
@property(nonatomic,assign)int bizMaxLength;//最大长度
@property(nonatomic,assign)BizTextFieldType bizType;
-(void)textFieldDidChange:(UITextField*)textfield;
@end
