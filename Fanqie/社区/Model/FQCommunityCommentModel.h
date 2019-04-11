//
//  FQCommunityCommentModel.h
//  Fanqie
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQCommunityCommentModel : NSObject

@property (nonatomic,assign)int id;
@property (nonatomic,assign)int  pid;
@property (nonatomic,assign)int user_id;
@property (nonatomic,assign)int community_dianzanncount;
@property (nonatomic,assign)int community_commentcount;
@property (nonatomic,assign)int community_sharcount;
@property (nonatomic,assign)BOOL is_dianzan;
@property (nonatomic,copy)NSString*head_portrait;
@property (nonatomic,copy)NSString*user_nikname;
@property (nonatomic,copy)NSString*commentcontent;

@end


