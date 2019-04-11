//
//  FQUserInfoModel.h
//  Fanqie
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 address = "";
 age = "";
 autograph = "\U5728\U771f\U8f6c\U505a\U6700\U65e0\U8bed\U7a81\U7136\U5c31\U554a\U674e\U5973\U58eb\U5177\U4f53mixskr\U91cc\U4e0d";
 birthday = 1554971854;
 countfans = 0;
 countfollow = 0;
 friendsintention = "\U6c42\U64a9";
 "head_portrait" = "http://poa970vus.bkt.clouddn.com/FmTs3WOJ1S9uOdujxmEFKHWphzY5";
 hunyin = 1;
 id = 1895;
 isfollow = 0;
 nikname = "\U6211\U73a9\U6e38\U620f\U53bb\U4e86";
 "reg_time" = 1554363464;
 sex = 1;
 sexualorientation = "\U7537";
 */
@interface FQUserInfoModel : NSObject
@property (nonatomic,copy)NSString*nikname;
@property (nonatomic,copy)NSString*address;
@property (nonatomic,copy)NSString*sexualorientation;
@property (nonatomic,copy)NSString*head_portrait;
@property (nonatomic,copy)NSString*friendsintention;
///签名
@property (nonatomic,copy)NSString*autograph;
@property (nonatomic,assign)long birthday;
@property (nonatomic,assign)long reg_time;

@property (nonatomic,assign)int id;
@property (nonatomic,assign)int countfans;
@property (nonatomic,assign)int countfollow;
@property (nonatomic,assign)BOOL isfollow;
//婚姻状况1单身2已婚3恋爱中,0其他
@property (nonatomic,assign)int hunyin;
//男女1男2女,0未知
@property (nonatomic,assign)int sex;

@end
