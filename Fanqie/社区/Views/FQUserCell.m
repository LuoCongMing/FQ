//
//  FQUserCell.m
//  Fanqie
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQUserCell.h"

@implementation FQUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImage.layer.cornerRadius = 20.5;
    _iconImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
