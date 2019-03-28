//
//  FQUserCell.h
//  Fanqie
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *userDescription;

@end
