//
//  FQCommunityIndexModel.h
//  Fanqie
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQCommunityIndexModel : NSObject
///id
@property (nonatomic ,assign)int id;
///user_id
@property (nonatomic ,assign)int user_id;
///
@property (nonatomic ,copy)NSString*username;
///
@property (nonatomic ,copy)NSString*title;
///
@property (nonatomic ,copy)NSString*textcontent;
///
@property (nonatomic ,copy)NSString*picturecontent;
///
@property (nonatomic ,copy)NSString*videocontent;
///头像
@property (nonatomic ,copy)NSString*head_portrait;
///
@property (nonatomic ,copy)NSString*user_nikname;
///
@property (nonatomic ,assign)BOOL is_dianzan;
///
@property (nonatomic ,assign)int community_dianzanncount;
///
@property (nonatomic ,assign)int community_commentcount;
///
@property (nonatomic ,assign)int community_sharcount;
///type 1 文字 3视频 2图片
@property (nonatomic ,assign)int type;

///vediothumb
@property (nonatomic,strong)UIImage*thubImage;

///分解出来的图片地址
@property (nonatomic,strong)NSMutableArray*pictureArray;
@end
