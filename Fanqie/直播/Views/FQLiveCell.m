//
//  FQLiveCell.m
//  Fanqie
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQLiveCell.h"

@implementation FQLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _redPoint.layer.cornerRadius = 3.5;
    _redPoint.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end
