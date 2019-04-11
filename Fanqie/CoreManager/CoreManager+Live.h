//
//  CoreManager+Live.h
//  Fanqie
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager.h"
#import "FQLiveModel.h"
#import "FQLiveBannerModel.h"

@interface CoreManager (Live)
/**
 直播banner
 
 */
-(void)fq_LiveBannerCompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;

/**
 直播首页推荐列表
 */
-(void)fq_LiveRecommendListPage:(int)page CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;
@end
