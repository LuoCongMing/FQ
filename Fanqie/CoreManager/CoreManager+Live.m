//
//  CoreManager+Live.m
//  Fanqie
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager+Live.h"

@implementation CoreManager (Live)
-(void)fq_LiveBannerCompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@wheelplanting",host];
    [self getRequestWithPara:nil Path:path CompleteBlock:^(id success) {
        NSDictionary*info = success[@"info"];
        NSArray*infos = info[@"infos"];
        NSMutableArray*marray = [[NSMutableArray alloc]init];
        for (NSDictionary*dict in infos) {
            FQLiveBannerModel*model = [[FQLiveBannerModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [marray addObject:model];
        }
        complete(marray);
    } FaildBlock:^(id error) {
        
    }];
}

-(void)fq_LiveRecommendListPage:(int)page CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@Recommend_livelist",host];
    NSDictionary*para = @{@"page":@(page),@"user_id":@0};
    [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
        NSDictionary*info = success[@"info"];
        NSArray*infos = info[@"infos"];
        NSMutableArray*marray = [[NSMutableArray alloc]init];
        for (NSDictionary*dict in infos) {
            FQLiveModel*model = [[FQLiveModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [marray addObject:model];
        }
        int page = [info[@"pageCount"] intValue];
        complete(@{@"array":marray,@"page":@(page)});
    } FaildBlock:^(id error) {
        
    }];
}
@end
