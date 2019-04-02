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
                complete(responseObject[@"info"]);
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
@end
