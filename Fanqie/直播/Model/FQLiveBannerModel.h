//
//  FQLiveBannerModel.h
//  Fanqie
//
//  Created by mac on 2019/4/12.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "url": "ADAD",//跳转地址
 "timee": "3",
 "name": "ADAD",
 "tupian": "http://poa970vus.bkt.clouddn.com/iwanli/image_00f505b42bd1622eb8868f3f6390d337.jpg",图片地址
 "status": "1",
 "type": "1",
 "id": "3",
 "others": ""
 
 */
@interface FQLiveBannerModel : NSObject
///跳转地址
@property (nonatomic,copy)NSString*url;
///封面
@property (nonatomic,copy)NSString*tupian;
@property (nonatomic,assign)int status;
@property (nonatomic,assign)int type;
@property (nonatomic,assign)int id;
@end
