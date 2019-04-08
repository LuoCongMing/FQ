//
//  CoreManager+Login.m
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager+Login.h"

@implementation CoreManager (Login)

///获取验证码
-(void)FQgetRegistCodeWithCount:(NSString *)count Type:(int)type CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    NSString*path = [NSString stringWithFormat:@"%@regcode",host];
    NSDictionary*para = @{@"username":count,
                          @"type":@(type)
                          };
    
    [self PostRequestWithPara:para Path:path CompleteBlock:^(id success) {
        if (complete){
            complete(nil);
        }
    } FaildBlock:^(id error) {
        if (faild){
            faild(nil);
        }
    }];
}

///注册
-(void)FQRegistCodeWithUserName:(NSString *)username code:(int)code Tusername:(int)tusername Password:(NSString *)password Repeatpassword:(NSString *)repeatpassword CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    NSString*path = [NSString stringWithFormat:@"%@reg",host];
    NSMutableDictionary*mPara =[[NSMutableDictionary alloc]initWithDictionary:@{@"username":username,
                                                                                @"password":password,
                                                                                @"repeatpassword":repeatpassword,
                                                                                @"code":@(code),
                                                                                
                                                                                }];
    if(tusername>0){
        [mPara setValue:@(tusername) forKey:@"tusername"];
    }else{
        [mPara setValue:@(tusername) forKey:@""];
    }
    [self PostRequestWithPara:mPara Path:path CompleteBlock:^(id success) {
        if (success){
            
            complete(nil);
        }
    } FaildBlock:nil];
    
}

#pragma mark 登录
-(void)FQLoginWithPhone:(NSString *)phone Password:(NSString *)password CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    NSDictionary *para = @{@"username":phone,@"password":password};
    NSString*path = [NSString stringWithFormat:@"%@login",host];
    
    [self PostRequestWithPara:para Path:path CompleteBlock:^(id success) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[RLMRealm defaultRealm]beginWriteTransaction];
            if ([FQUserModel allObjects].count>0) {
                [[RLMRealm defaultRealm]deleteObject:[FQUserModel allObjects].firstObject];
            }
            NSDictionary*info = success[@"data"];
            FQUserModel * model = [FQUserModel share];
            model.userid = [info[@"id"] intValue];
            model.username = info[@"username"];
            model.user_token = info[@"user_token"];
            [[RLMRealm defaultRealm]addObject:model];
            [[RLMRealm defaultRealm]commitWriteTransaction];
            
            if (complete){
                complete(nil);
            }
        });

    } FaildBlock:^(id error) {
        if (faild){
            faild(nil);
        }
    }];
}


#pragma mark 找回密码
-(void)fq_FindPswWithPhone:(NSString *)phone Code:(NSString *)code Password:(NSString *)password RepeatPassword:(NSString *)repeatpassword CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    NSString*path = [NSString stringWithFormat:@"%@forpassword",host];
    NSDictionary*para = @{@"username":phone,
                          @"code":code,
                          @"password":password,
                          @"repassword":repeatpassword
                          };
    [self PostRequestWithPara:para Path:path CompleteBlock:^(id success) {
        if (complete) {
            complete(nil);
        }
    } FaildBlock:^(id error) {
        if (faild) {
            faild(nil);
        }
    }];
}







@end
