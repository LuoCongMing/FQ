//
//  CoreManager+Home.m
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager+Home.h"

@implementation CoreManager (Home)
-(void)getADSCompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@/indexpic",host];
    [self getRequestWithPara:@{@"type":@"2"} Path:path CompleteBlock:^(id success) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[RLMRealm defaultRealm]beginWriteTransaction];
            if ([FQADSModel allObjects].count>0)
            {
                [[RLMRealm defaultRealm]deleteObject:[FQADSModel allObjects].firstObject];
            }
            FQADSModel *model = [[FQADSModel alloc]init];
            model.tupian = success[@"tupian"];
            model.name = success[@"name"];
            model.url = success[@"url"];
            [[RLMRealm defaultRealm]addObject:model];
            [[RLMRealm defaultRealm]commitWriteTransaction];
        });
    } FaildBlock:^(id error) {
        
    }];
}

#pragma mark 社区公告
-(void)getCommunitybulletinCompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@/communitybulletin",host];
    [self getRequestWithPara:nil Path:path CompleteBlock:^(id success) {
        FQBulletinModel*model = [[FQBulletinModel alloc]init];
        model.bulletinId = [success[@"id"] intValue];
        model.title = success[@"title"];
        model.content = success[@"content"];
        if(complete){
            complete(model);
        }
    } FaildBlock:^(id error) {
        if(faild){
            faild(nil);
        }
    }];
}

#pragma 获取社区内容
-(void)getCommunityindexPage:(int)page CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    NSString*path = [NSString stringWithFormat:@"%@communityindex",host];
    FQUserModel*user = [FQUserModel share];
    NSMutableDictionary*mpara = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":@(page)}];
    if (user.userid) {
        [mpara setValue:@(user.userid) forKey:@"user_id"];
    }
    [self getRequestWithPara:mpara Path:path CompleteBlock:^(id success) {
        NSArray*info = success[@"datainfo"];
        NSMutableDictionary*mdict = [[NSMutableDictionary alloc]init];
        NSMutableArray*modelArray = [[NSMutableArray alloc]init];
        int total = 0;
        NSDictionary*page = success[@"page"];
        total = [page[@"pageCount"] intValue];
        if (info.count>0) {
            for (NSDictionary*dict in info) {
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
        if (faild) {
            faild(nil);
        }
    }];
}

#pragma mark 社区搜索列表
-(void)getCommunitysearchindexPage:(int)page SearchString:(NSString *)searchString CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@communitysearch",host];
    NSMutableDictionary*mpara = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":@(page),@"searchcontent":searchString}];
    
    [self getRequestWithPara:mpara Path:path CompleteBlock:^(id success) {
        NSDictionary*info = success[@"info"];
        NSMutableDictionary*mdict = [[NSMutableDictionary alloc]init];
        NSMutableArray*modelArray = [[NSMutableArray alloc]init];
        int total = 0;
        NSDictionary*page = success[@"page"];
        total = [page[@"pageCount"] intValue];
        if (info.count>0) {
            for (NSDictionary*dict in info) {
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
        if (faild) {
            faild(nil);
        }
    }];
}

#pragma mark 我关注的社区内容
-(void)fq_myfollowlcommunityistPage:(int)page CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@communityindex",host];
    FQUserModel*user = [FQUserModel share];
    NSMutableDictionary*mpara = [[NSMutableDictionary alloc]initWithDictionary:@{@"page":@(page)}];
    if (user.userid) {
        [mpara setValue:@(user.userid) forKey:@"user_id"];
    }
    [self getRequestWithPara:mpara Path:path CompleteBlock:^(id success) {
        NSDictionary*info = success[@"datainfo"];
        NSMutableDictionary*mdict = [[NSMutableDictionary alloc]init];
        NSMutableArray*modelArray = [[NSMutableArray alloc]init];
        int total = 0;
        NSDictionary*page = success[@"page"];
        total = [page[@"pageCount"] intValue];
        if (info.count>0) {
            for (NSDictionary*dict in info) {
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
        if (faild) {
            faild(nil);
        }
    }];
}

#pragma mark 获取社区内容详情
-(void)fq_communityCommentDetailID:(int)Id CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@communitycommentlist",host];
    FQUserModel*model = [FQUserModel share];
    int user_id = 0;
    if (model.userid>0) {
        user_id = model.userid;
    }
    NSDictionary*para = @{@"community_id":@(Id),
                          @"user_id":@(user_id),
                          };
    [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
        NSLog(@"in");
    } FaildBlock:^(id error) {
        if (faild) {
            faild(nil);
        }
    }];
}
#pragma mark 获取社区内容评论
-(void)fq_communityCommentListWithPage:(int)page Community_id:(int)Id Sort:(int)sort CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@community_commentlist",host];
    FQUserModel*model = [FQUserModel share];
    int user_id = 0;
    if (model.userid>0) {
        user_id = model.userid;
    }
    NSDictionary*para = @{@"community_id":@(Id),
                          @"user_id":@(user_id),
                          @"page":@(page),
                          @"sort":@(sort)
                          };
    [self getRequestWithPara:para Path:path CompleteBlock:^(id success) {
        if ([success[@"code"] intValue]==1) {
            NSArray*info = success[@"info"];
            NSMutableArray*marray = [[NSMutableArray alloc]init];
//            int page = 0;
            
                
//                page = [info[@"page"][@"page"] intValue];
                if (info.count>0) {
                    for (NSDictionary*dict in info) {
                        FQCommunityCommentModel*model = [[FQCommunityCommentModel alloc]init];
                        [model setValuesForKeysWithDictionary:dict];
                        [marray addObject:model];
                    }
                    
                }
            
            if (complete) {
                complete(@{@"page":@(page),@"array":marray});
            }
        }
    } FaildBlock:^(id error) {
        if (faild) {
            faild(nil);
        }
    }];
    
}
#pragma mark 点赞
-(void)fq_zanWithID:(int)ID Type:(int)type CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@app/communityfabulous",host];
    FQUserModel*model = [FQUserModel share];
    if (model.user_token.length>0) {
        NSDictionary*para = @{@"id":@(ID),
                              @"user_token":model.user_token,
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

#pragma mark 社区复制内容
-(void)fq_copyCompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@communitycontentreproduction",host];
    [self getRequestWithPara:nil Path:path CompleteBlock:^(id success) {
        if (complete) {
            complete(success);
        }
    } FaildBlock:^(id error) {
        if (faild) {
            faild(nil);
        }
    }];
}

-(void)fq_followingWithUserID:(int)user_id Type:(int)type CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    NSString*path = [NSString stringWithFormat:@"%@app/following",host];
    FQUserModel*model = [FQUserModel share];
    if (model.user_token.length>0) {
        NSDictionary*para = @{@"user_id":@(user_id),
                              @"user_token":model.user_token,
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

#pragma mark 七牛云鉴权
-(void)fq_qiniu_tokenCompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    if ([FQUserModel share].user_token.length>0) {
        NSString*path = [NSString stringWithFormat:@"%@app/qiniu_token",host];
        NSDictionary*para = @{@"user_token":[FQUserModel share].user_token};
        
        [self PostRequestWithPara:para Path:path CompleteBlock:^(id success) {
            if (complete) {
                complete(success[@"qiniu_token"]);
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

#pragma mark 发布社区内容
-(void)fq_communityPublicTitle:(NSString*)title
                   Textcontent:(NSString*)textcontent
                Picturecontent:(NSArray*)pcituresUrl
                  videocontent:(NSString*)vedioUrl
                          Type:(int)type
                 CompleteBlock:(FQCompleteBlock)complete
                    FaildBlock:(FQFaildBlock)faild{
    
    NSString*path = [NSString stringWithFormat:@"%@app/communityadd",host];
    NSMutableDictionary*para = [[NSMutableDictionary alloc]initWithDictionary:@{
                                                                                @"user_token":[FQUserModel share].user_token,
                                                                                @"title":title,
                                                                                @"type":@(type),
                                                                                @"textcontent":@"",
                                                                                @"picturecontent":@"",
                                                                                @"videocontent":@""
                                                                                }];
    
    switch (type) {
        case 1:
        {
            [para setValue:textcontent forKey:@"textcontent"];
        }
            break;
        case 2:
        {
            NSMutableString * picturePath = [[NSMutableString alloc]init];
            for (NSString*picture in pcituresUrl) {
                [picturePath appendFormat:@"%@,",picture];
            }
            NSString*resultString =[picturePath substringToIndex:picturePath.length-1 ];
            [para setValue:resultString forKey:@"picturecontent"];
        }
            break;
        case 3:
        {
            [para setValue:vedioUrl forKey:@"videocontent"];
        }
            break;
            
        default:
            break;
    }
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

#pragma mark 发布社区内容回复
-(void)fq_communityCommentPublicCommunity_id:(int)community_id Commentcontent:(NSString *)commentcontent CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild
{
    FQUserModel*model = [FQUserModel share];
    if (model.user_token.length>0) {
        NSString*path = [NSString stringWithFormat:@"%@app/communitycommenting",host];
        NSDictionary*para = @{@"user_token":model.user_token,
                              @"community_id":@(community_id),
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

#pragma mark 社区评论内容点赞
-(void)fq_zanWithComment_id:(int)ID Type:(int)type Community_id:(int)community_id CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild{
    
    FQUserModel*model = [FQUserModel share];
    if (model.user_token.length>0) {
        NSString*path = [NSString stringWithFormat:@"%@app/communitycommentsthumbs",host];
        NSDictionary*para = @{@"user_token":model.user_token,
                              @"community_id":@(community_id),
                              @"comment_id":@(ID),
                              @"type":@(type)
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





@end
