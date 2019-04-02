//
//  FQUserModel.m
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQUserModel.h"
#import <Realm.h>

@implementation FQUserModel
+(instancetype)share{
    static FQUserModel *user ;
    user = [FQUserModel allObjects].firstObject;
    if (user){
        
        
    }else{
        user = [[FQUserModel alloc]init];
    }
    return user;
}
@end
