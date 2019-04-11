//
//  FQLiveCell.m
//  Fanqie
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQLiveCell.h"

@interface FQLiveCell()
@property (weak, nonatomic) IBOutlet UIImageView *backGrandImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveTitle;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *liveNum;
@property (weak, nonatomic) IBOutlet UIView *redPoint;
@end

@implementation FQLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _redPoint.layer.cornerRadius = 3.5;
    _redPoint.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

-(void)updateContentWithModel:(FQLiveModel *)model{
    [_backGrandImageView sd_setImageWithURL:[NSURL URLWithString:model.live_pic] placeholderImage:[UIImage imageNamed:@"图像默认"]];
    _liveTitle.text = model.title;
    _nickName.text = model.nikname;
    
}
@end
