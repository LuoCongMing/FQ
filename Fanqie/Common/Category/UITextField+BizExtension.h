//
//  UITextField+BizExtension.h
//  WineCellar
//
//  Created by zero on 2017/11/30.
//  Copyright © 2017年 www.biz-united.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BizTextFieldDelegateHook.h"

@interface UITextField (BizExtension)

@property (nonatomic,assign) IBInspectable CGFloat paddingLeft;
//设置一下两个属性需要先设置delegate,谨记！！！
///输入内容 默认BizTextFieldTypeWithoutCN
@property(nonatomic,assign)BizTextFieldType bizType;
///最大输入长度
@property(nonatomic,assign)int bizMaxLength;
-(void)setBizDelegate:(id)delegate;
@end
