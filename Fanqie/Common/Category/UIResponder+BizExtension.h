//
//  UIResponder+BizExtension.h
//  MWGX-Customer
//
//  Created by CoolCamel on 17/4/5.
//  Copyright © 2017年 www.meiweigx.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (BizExtension)
/**
 *  发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
 *
 *  @param eventName 发生的事件名称
 *  @param dataInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
 *
 */
- (void)routerEventWithName:(NSString *)eventName dataInfo:(NSDictionary *)dataInfo;

+(id) currentFirstResponder;

-(void) findFirstResponder:(id) sender;
@end
