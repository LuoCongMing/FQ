//
//  CoreManager+Video.h
//  Fanqie
//
//  Created by mac on 2019/4/9.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "CoreManager.h"
#import "FQVideoModel.h"
#import "FQShortVideoCommentModel.h"
#import "FQUserInfoModel.h"
#import "FQCommunityIndexModel.h"

@interface CoreManager (Video)

///获取短视频列表
-(void)fq_getVideoListWithPage:(int)page CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;

///短视频点赞
-(void)fq_shortVideoZanWithID:(int)ID Type:(int)type CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;
/**
 短视频发布

 @param title 标题
 @param url 视频地址
 @param description 描述 （非必填）
 */
-(void)fq_publicShortVideoTitle:(NSString*)title VideoUrl:(NSString*)url Description:(NSString*)description CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;


/**
 短视频评论列表

 */
-(void)fq_shortVideoCommentWithId:(int)shortvideo_id Page:(int)page CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;

/**
 短视频评论发布

 */
-(void)fq_publicShortVideoCommenID:(int)shortvideo_id Content:(NSString*)commentcontent CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;



/**
 短视频评论点赞

 @param shortvideo_id 短视频id
 @param commentID 评论id
 @param type 1点赞2取消
 */
-(void)fq_zanShortVideoID:(int)shortvideo_id  CommentID:(int)commentID Type:(int)type CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;


/**
 查看用户动态

 */
-(void)fq_SeeUser_dyanmic:(int)userId CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;

///查看用户信息
-(void)fq_SeeUser_info:(int)user_Id CompleteBlock:(FQCompleteBlock)complete FaildBlock:(FQFaildBlock)faild;
@end
