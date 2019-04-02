//
//  UITextField+BizExtension.m
//  WineCellar
//
//  Created by zero on 2017/11/30.
//  Copyright © 2017年 www.biz-united.com.cn. All rights reserved.
//

#import "UITextField+BizExtension.h"
#import <objc/runtime.h>

static NSString*k_bizDelegate_Identify = @"k_bizDelegate_Identify";
static NSString*k_bizLength_Identify = @"k_bizLength_Identify";
static NSString*k_bizType_Identify = @"k_bizType_Identify";

@implementation UITextField (BizExtension)
+(void)load{
    Class class = [self class];
    Method TextFieldMethod = class_getInstanceMethod(class, @selector(setDelegate:));
    Method BizTextFieldMethod = class_getInstanceMethod(class, @selector(setBizDelegate:));
    method_exchangeImplementations(TextFieldMethod, BizTextFieldMethod);
}
-(void)setBizDelegate:(id)delegate{
    BizTextFieldDelegateHook*hook = [[BizTextFieldDelegateHook alloc] init];
    objc_setAssociatedObject(self, &k_bizDelegate_Identify, hook, OBJC_ASSOCIATION_RETAIN);
    [self addTarget:hook action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self setBizDelegate:hook];
}

-(void)setBizType:(BizTextFieldType)bizType{
    BizTextFieldDelegateHook*hook = objc_getAssociatedObject(self, &k_bizDelegate_Identify);
    hook.bizType = bizType;
    objc_setAssociatedObject(self, &k_bizType_Identify, @(bizType), OBJC_ASSOCIATION_RETAIN);
}
-(BizTextFieldType)bizType{
    
    return (BizTextFieldType)objc_getAssociatedObject(self, &k_bizType_Identify);
}
-(void)setBizMaxLength:(int)bizMaxLength{
    BizTextFieldDelegateHook*hook = objc_getAssociatedObject(self, &k_bizDelegate_Identify);
    hook.bizMaxLength = bizMaxLength;
    objc_setAssociatedObject(self, &k_bizLength_Identify, [NSNumber numberWithInt:bizMaxLength], OBJC_ASSOCIATION_RETAIN);
}

-(int)bizMaxLength{
    NSNumber*num = objc_getAssociatedObject(self, &k_bizLength_Identify);
    return [num intValue];
}

- (CGFloat)paddingLeft {
    return self.leftView.bounds.size.width;
}

- (void)setPaddingLeft:(CGFloat)paddingLeft {
    UILabel *paddingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, paddingLeft, self.bounds.size.height)];
    paddingView.text = @"";
    paddingView.textColor = [UIColor darkGrayColor];
    paddingView.backgroundColor = [UIColor clearColor];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}



@end
