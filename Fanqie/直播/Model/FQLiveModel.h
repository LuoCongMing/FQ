//
//  FQLiveModel.h
//  Fanqie
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 addtime = 1554994859;
 id = 1;
 "live_describe" = "\U5957\U8def\U592a\U6df1\U56de\U519c\U6751";
 "live_pic" = "http://poa970vus.bkt.clouddn.com/ltrxjPBPSUyU3e4iD-WTVkPTXKiw";
 nikname = J115881;
 status = 1;
 title = "\U4eca\U665a\U6253\U8001\U864e";
 url = "rtmp://rtmp.r8339.cn/live/cfb55ed21881a6063c15f1e91ff3902c?txSecret=cd391e8a3f9cc6a719c2bd68d8948ede&txTime=5CB0A82B";
 "user_id" = 1883;
 username = J115881;
 */
@interface FQLiveModel : NSObject
@property (nonatomic,copy)NSString*live_describe;
@property (nonatomic,copy)NSString*live_pic;
@property (nonatomic,copy)NSString*title;
@property (nonatomic,copy)NSString*url;
@property (nonatomic,copy)NSString*username;
@property (nonatomic,copy)NSString*nikname;
@property (nonatomic,assign)int addtime;
@property (nonatomic,assign)int user_id;
@property (nonatomic,assign)int id;
@property (nonatomic,assign)int status;
@end
