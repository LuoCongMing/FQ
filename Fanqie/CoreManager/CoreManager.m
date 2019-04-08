//
//  CoreManager.m
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager.h"
#import <MBProgressHUD.h>


@implementation CoreManager
-(AFHTTPSessionManager*)manager{
    if(_manager == nil)
    {
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
        _manager.requestSerializer.timeoutInterval = 10;
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    }
    
    return _manager;
}

-(void)PostRequestWithPara:(NSDictionary *)para Path:(NSString *)path CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    [self.manager POST:path parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int code = [responseObject[@"code"] intValue];
        if(code == 1){
            /*
             info =     {
             userid = 1890;
             username = 13684030501;
             };
             */
            if (complete){
                complete(responseObject);
            }
        }else{
            MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.detailsLabel.text = responseObject[@"msg"];
            [hud hideAnimated:YES afterDelay:1.0];
            if (faild){
                faild(nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.detailsLabel.text = @"连接服务器出错";
            [hud hideAnimated:YES afterDelay:1.0];
            if(faild){
                faild(nil);
            }
        });
    }];
    
}

-(void)getRequestWithPara:(NSDictionary *)para Path:(NSString *)path CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    [self.manager GET:path parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int code = [responseObject[@"code"] intValue];
        if(code == 1){
            
            if (complete){
                complete(responseObject);
            }
        }else{
            MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.detailsLabel.text = responseObject[@"msg"];
            [hud hideAnimated:YES afterDelay:1.0];
            if (faild){
                faild(nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.detailsLabel.text = @"连接服务器出错";
            [hud hideAnimated:YES afterDelay:1.0];
            if(faild){
                faild(nil);
            }
        });
    }];
}

-(void)fq_LoginFirst{
    
    [[self controller] presentViewController:[UIStoryboard storyboardWithName:@"Login" bundle:nil].instantiateInitialViewController animated:YES completion:nil];
}
-(UIViewController*)controller{
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
   
}
- (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}
@end
