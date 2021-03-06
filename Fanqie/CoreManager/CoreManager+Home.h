//
//  CoreManager+Home.h
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager.h"
#import "FQADSModel.h"
#import "FQBulletinModel.h"
#import "FQCommunityIndexModel.h"
#import "FQCommunityCommentModel.h"

@interface CoreManager (Home)
///启动广告图片
-(void)getADSCompleteBlock:(FQCompleteBlock)complete
                FaildBlock:(FQFaildBlock)faild;


///社区公告
-(void)getCommunitybulletinCompleteBlock:(FQCompleteBlock)complete
                              FaildBlock:(FQFaildBlock)faild;

///社区推荐内容
-(void)getCommunityindexPage:(int)page
               CompleteBlock:(FQCompleteBlock)complete
                  FaildBlock:(FQFaildBlock)faild;

///社区搜索内容
-(void)getCommunitysearchindexPage:(int)page
                      SearchString:(NSString*)searchString
               CompleteBlock:(FQCompleteBlock)complete
                  FaildBlock:(FQFaildBlock)faild;


///我关注的社区内容
-(void)fq_myfollowlcommunityistPage:(int)page

                      CompleteBlock:(FQCompleteBlock)complete
                         FaildBlock:(FQFaildBlock)faild;

/**
 点赞
 
 @param ID 社区内容id
 @param type 1 点赞 2取消赞
 */
-(void)fq_zanWithID:(int)ID Type:(int)type CompleteBlock:(FQCompleteBlock)complete
         FaildBlock:(FQFaildBlock)faild;


/**
 社区复制内容

 */
-(void)fq_copyCompleteBlock:(FQCompleteBlock)complete
                 FaildBlock:(FQFaildBlock)faild;


/**
 获取文章详情
 @param Id 文章ID
 */
-(void)fq_communityCommentDetailID:(int)Id CompleteBlock:(FQCompleteBlock)complete
                            FaildBlock:(FQFaildBlock)faild;


/**
 获取社区的评论列表

 @param page 页数
 @param Id 社区内容ID
 @param sort 排序方式
 */
-(void)fq_communityCommentListWithPage:(int)page Community_id:(int)Id Sort:(int)sort CompleteBlock:(FQCompleteBlock)complete
                            FaildBlock:(FQFaildBlock)faild;


/**
 社区内容回复

 @param community_id 社区内容id
 @param commentcontent 回复内容
 */
-(void)fq_communityCommentPublicCommunity_id:(int)community_id Commentcontent:(NSString*)commentcontent CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;


/**
 社区评论内容点赞

 @param ID 评论内容id
 @param type 1点赞2取消
 @param community_id 社区内容id
 
 */
-(void)fq_zanWithComment_id:(int)ID Type:(int)type Community_id:(int)community_id CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;

/**
加关注

 @param user_id 关注用户id
 @param type 1关注2取消关注3取消粉丝
 */
-(void)fq_followingWithUserID:(int)user_id Type:(int)type CompleteBlock:(FQCompleteBlock)complete
                   FaildBlock:(FQFaildBlock)faild;


/**
 获取七牛云上传鉴权
 */
-(void)fq_qiniu_tokenCompleteBlock:(FQCompleteBlock)complete
FaildBlock:(FQFaildBlock)faild;


/**
 
 @param title 标题
 @param textcontent 文本
 @param pcituresUrl 图片地址数组
 @param vedioUrl 视频地址
 @param type  1文本 2图片 3视频
 */
-(void)fq_communityPublicTitle:(NSString*)title
                   Textcontent:(NSString*)textcontent
                Picturecontent:(NSArray*)pcituresUrl
                  videocontent:(NSString*)vedioUrl
                          Type:(int)type
                 CompleteBlock:(FQCompleteBlock)complete
                    FaildBlock:(FQFaildBlock)faild;

@end
