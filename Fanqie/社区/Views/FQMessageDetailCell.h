//
//  FQMessageDetailCell.h
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQMessageDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *creatInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *donotLike;
@property (weak, nonatomic) IBOutlet UIButton *more;


@end
