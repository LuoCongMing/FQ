//
//  FQUserModel.h
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "RLMObject.h"

@interface FQUserModel : RLMObject

@property (nonatomic,copy)NSString*username;
@property (nonatomic,assign)int userid;

+(instancetype)share;

@end
