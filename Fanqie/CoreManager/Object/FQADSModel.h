//
//  FQADSModel.h
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "RLMObject.h"

@interface FQADSModel : RLMObject
///图片地址
@property (nonatomic,copy)NSString*tupian;
///标题
@property (nonatomic,copy)NSString*name;
///连接地址
@property (nonatomic,copy)NSString*url;
@end
