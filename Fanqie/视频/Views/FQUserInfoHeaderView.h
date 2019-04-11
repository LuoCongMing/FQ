//
//  FQUserInfoHeaderView.h
//  Fanqie
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQUserInfoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FQUserInfoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *attention;

///查看其他用户的时候显示关注和
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
-(void)updateContentWithModel:(FQUserInfoModel*)model;
@end
