//
//  FQVideoModel.h
//  Fanqie
//
//  Created by mac on 2019/4/9.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FQVideoModel : NSObject
@property (nonatomic,copy)NSString*title;
@property (nonatomic,copy)NSString*head_portrait;
@property (nonatomic,copy)NSString*user_nikname;
///
@property (nonatomic,copy)NSString*url;
@property (nonatomic,assign)int id;
@property (nonatomic,assign)int user_id;

@property (nonatomic,assign)int shortvideo_commentcount;
@property (nonatomic,assign)int shortvideo_dianzanncount;
@property (nonatomic,assign)int shortvideo_sharcount;
@property (nonatomic,assign)BOOL is_dianzan;
@property (nonatomic,assign)BOOL is_follow;
@property (nonatomic,assign)UIImage*thubImage;
@end
