//
//  CoreManager+Video.m
//  Fanqie
//
//  Created by mac on 2019/4/9.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager+Video.h"

@implementation CoreManager (Video)
-(void)fq_getVideoListWithPage:(int)page CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    FQUserModel*model = [FQUserModel share];
    NSMutableDictionary*para = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":@(page)}];
    if (model.userid) {
        [para setValue:@(model.userid) forKey:@"user_id"];
    }
    NSString*path = [NSString stringWithFormat:@"%@shortvideolist",host];
    [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
        NSArray*datainfo = success[@"datainfo"];
        NSDictionary*pageinfo = success[@"pageinfo"];
        int currentPage = [pageinfo[@"pageCount"] intValue];
        NSMutableArray*mArray = [[NSMutableArray alloc]init];
        
        if (datainfo.count>0) {
            for (NSDictionary*dict in datainfo) {
                FQVideoModel*model = [[FQVideoModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [mArray addObject:model];
            }
        }
        if (complete) {
            complete(@{@"array":mArray,@"page":@(currentPage)});
        }
    } FaildBlock:^(id error) {
        NSLog(@"faild");
    }];
    
}

#pragma mark 短视频点赞
-(void)fq_shortVideoZanWithID:(int)ID Type:(int)type CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    FQUserModel*model = [FQUserModel share];
    if (model.user_token.length>0) {
        NSString*path = [NSString stringWithFormat:@"%@app/shortvideocomments",host];
        NSDictionary*para = @{@"user_token":model.user_token,
                              @"id":@(ID),
                              @"type":@(type)
                              };
        [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
            if (complete) {
                complete(nil);
            }
        } FaildBlock:^(id error) {
            if (faild) {
                faild(nil);
            }
        }];
    
    }else{
        [self fq_LoginFirst];
    }
}

-(void)fq_publicShortVideoTitle:(NSString *)title VideoUrl:(NSString *)url Description:(NSString *)description CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    FQUserModel*model = [FQUserModel share];
    if (model.user_token.length>0) {
        NSString*path = [NSString stringWithFormat:@"%@app/shortvideopublishing",host];
        NSDictionary*para = @{@"user_token":model.user_token,
                              @"title":title,
                              @"shortvideourl":url,
                              @"characterdescription":description
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
       
        
    }else{
        [self fq_LoginFirst];
    }
    
}

#pragma mark 获取短视频评论

-(void)fq_shortVideoCommentWithId:(int)shortvideo_id Page:(int)page CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    NSString*path = [NSString stringWithFormat:@"%@shortvideo_commentlist",host];
    NSDictionary*para = @{
                          @"shortvideo_id":@(shortvideo_id),
                          };
    [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
        
        NSArray*datainfo = success[@"info"];
//        NSDictionary*pageinfo = success[@"pageinfo"];
//        int currentPage = [pageinfo[@"pageCount"] intValue];
        NSMutableArray*mArray = [[NSMutableArray alloc]init];
        
        if (datainfo.count>0) {
            for (NSDictionary*dict in datainfo) {
                FQShortVideoCommentModel*model = [[FQShortVideoCommentModel alloc]init];
                [model setValuesForKeysWithDictionary: dict];
                [mArray addObject:model];
            }
        }
        if (complete) {
            complete(@{@"array":mArray});
//            complete(@{@"array":mArray,@"page":@(currentPage)});
        }
        
    } FaildBlock:^(id error) {
        if (faild) {
            faild(nil);
        }
    }];
}

#pragma mark 发布短视频评论
-(void)fq_publicShortVideoCommenID:(int)shortvideo_id Content:(NSString *)commentcontent CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    FQUserModel*model = [FQUserModel share];
    if (model.user_token.length>0) {
        NSString*path = [NSString stringWithFormat:@"%@app/shortvideocommenting",host];
        NSDictionary*para = @{@"user_token":model.user_token,
                              @"shortvideo_id":@(shortvideo_id),
                              @"commentcontent":commentcontent
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
        
        
    }else{
        [self fq_LoginFirst];
    }
}
#pragma mark 短视频评论点赞
-(void)fq_zanShortVideoID:(int)shortvideo_id CommentID:(int)commentID Type:(int)type CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild
{
    FQUserModel*model = [FQUserModel share];
    if (model.user_token.length>0) {
        NSString*path = [NSString stringWithFormat:@"%@app/shortvideocommentsthumbs",host];
        NSDictionary*para = @{@"user_token":model.user_token,
                              @"shortvideo_id":@(shortvideo_id),
                              @"comment_id":@(commentID),
                              @"type":@(type)
                              };
        [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
            if (complete) {
                complete(nil);
            }
        } FaildBlock:^(id error) {
            if (faild) {
                faild(nil);
            }
        }];
        
        
    }else{
        [self fq_LoginFirst];
    }
}

#pragma mark 查看用户信息
-(void)fq_SeeUser_info:(int)user_Id CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSDictionary*para = @{@"user_id":@(user_Id),@"loguser_id":@(0)};//,
    NSString*path = [NSString stringWithFormat:@"%@See_user_info",host];
    [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
        NSDictionary*info = success[@"info"];
        if ([info isKindOfClass:[NSDictionary class]]) {
            FQUserInfoModel*model = [[FQUserInfoModel alloc]init];
            [model setValuesForKeysWithDictionary:info];
            if (complete) {
                complete(model);
            }
        }
        
    } FaildBlock:^(id error) {
        
    }];
}
#pragma mark 查看用户动态
-(void)fq_SeeUser_dyanmic:(int)userId CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSDictionary*para = @{@"user_id":@(userId)};//,@"loguser_id":@(0)
    NSString*path = [NSString stringWithFormat:@"%@See_user_dynamic",host];
    [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
        NSDictionary*info = success[@"info"];
        NSMutableDictionary*mdict = [[NSMutableDictionary alloc]init];
        NSMutableArray*modelArray = [[NSMutableArray alloc]init];
        int total = 0;
        NSDictionary*page = info[@"page"];
        total = [page[@"pageCount"] intValue];
        NSArray*datainfo = info[@"datainfo"];
        if (datainfo.count>0) {
            for (NSDictionary*dict in datainfo) {
                FQCommunityIndexModel*model = [[FQCommunityIndexModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                [modelArray addObject:model];
            }
        }
        
        [mdict setValue:modelArray forKey:@"array"];
        [mdict setValue:@(total) forKey:@"total"];
        if (complete) {
            complete(mdict);
        }
        
    } FaildBlock:^(id error) {
        
    }];
}
@end
