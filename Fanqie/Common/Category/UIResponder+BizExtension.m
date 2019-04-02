//
//  UIResponder+BizExtension.m
//  MWGX-Customer
//
//  Created by CoolCamel on 17/4/5.
//  Copyright © 2017年 www.meiweigx.com. All rights reserved.
//

#import "UIResponder+BizExtension.h"

static __weak id currentFirstResponder;

@implementation UIResponder (BizExtension)
-(void) routerEventWithName:(NSString *)eventName dataInfo:(NSDictionary *)dataInfo{
    [[self nextResponder] routerEventWithName:eventName dataInfo:dataInfo];
}

+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}
@end
