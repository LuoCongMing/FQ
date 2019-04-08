//
//  FQBulletinModel.h
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>

///公告
@interface FQBulletinModel : NSObject
///社区公告id
@property (nonatomic,assign)int bulletinId;
///内容
@property (nonatomic,copy)NSString*content;
///标题
@property (nonatomic,copy)NSString*title;


@end
