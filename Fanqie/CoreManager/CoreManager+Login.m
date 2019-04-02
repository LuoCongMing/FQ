//
//  CoreManager+Login.m
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager+Login.h"

@implementation CoreManager (Login)

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
            dispatch_async(dispatch_get_main_queue(), ^{
            
            });
            NSDictionary*info = success;
            
            complete(nil);
        }
    } FaildBlock:nil];
    
}
@end
