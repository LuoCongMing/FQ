//
//  FQShortVideoCommentModel.h
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQShortVideoCommentModel : NSObject
@property (nonatomic,assign)int id;//评论id
@property (nonatomic,assign)int pid;///视频id
@property (nonatomic,assign)int user_id;
@property (nonatomic,copy)NSString*commentcontent;
@property (nonatomic,assign)long addtime;
@property (nonatomic,assign)int shortvideo_com_dianzanshu_sort;
@property (nonatomic,assign)BOOL is_dianzan;
@property (nonatomic,copy)NSString*head_portrait;
@property (nonatomic,copy)NSString*user_nikname;

@end
