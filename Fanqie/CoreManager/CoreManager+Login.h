//
//  CoreManager+Login.h
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager.h"
#import "FQUserModel.h"

@interface CoreManager (Login)

/**
 获取验证码
 
 @param count 账号/手机号
 @param type 类型1注册2修改密码3验证绑定手机4验证新手机
 */
-(void)FQgetRegistCodeWithCount:(NSString*)count Type:(int)type CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;



/**
 注册

 @param username 手机号
 @param code 验证码
 @param password 密码
 @param repeatpassword 重复密码

 */
-(void)FQRegistCodeWithUserName:(NSString*)username
                           code:(int)code
                      Tusername:(int)tusername
                       Password:(NSString*)password
                 Repeatpassword:(NSString*)repeatpassword
                  CompleteBlock:(FQCompleteBlock)complete
                     FaildBlock:(FQFaildBlock)faild;


/**
 登录

 @param phone 手机号
 @param password 密码

 */
-(void)FQLoginWithPhone:(NSString*)phone
               Password:(NSString*)password
          CompleteBlock:(FQCompleteBlock)complete
             FaildBlock:(FQFaildBlock)faild;


/**
 找回密码
 */
-(void)fq_FindPswWithPhone:(NSString*)phone
                      Code:(NSString*)code
                  Password:(NSString*)password
            RepeatPassword:(NSString*)repeatpassword
                CompleteBlock:(FQCompleteBlock)complete
                   FaildBlock:(FQFaildBlock)faild;



@end
