//
//  CoreManager.h
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "FQUserModel.h"

static NSString *host = @"http://39.98.196.183:80/";

typedef void(^FQCompleteBlock)(id success);

typedef void(^FQFaildBlock)(id error);

@interface CoreManager : NSObject
@property (nonatomic,copy)FQCompleteBlock completeBlock;
@property (nonatomic,copy)FQFaildBlock  faildBlock;

@property (nonatomic,strong)AFHTTPSessionManager*manager;

-(void)PostRequestWithPara:(NSDictionary*)para Path:(NSString*)path CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;

-(void)getRequestWithPara:(NSDictionary*)para Path:(NSString*)path CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;

///跳转到登录界面
-(void)fq_LoginFirst;

-(UIViewController*)controller;

///获取视频封面
+(UIImage *)getThumbnailImage:(NSString *)videoURL;
@end
