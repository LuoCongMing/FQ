//
//  FQShortVideoCommentCell.m
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQShortVideoCommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoreManager+Video.h"

@implementation FQShortVideoCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _zanClick.titleLabel.textAlignment = 1;
}
-(void)updateContentWithModel:(FQShortVideoCommentModel *)model{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_portrait] placeholderImage:[UIImage imageNamed:@"图像默认"]];
    _nickName.text = model.user_nikname;
    _contentLabel.text = model.commentcontent;
    [_zanClick setSelected:model.is_dianzan];
    [_zanClick setTitle:[NSString stringWithFormat:@"%d",model.shortvideo_com_dianzanshu_sort] forState:UIControlStateNormal];
    
    self.model = model;
}
- (IBAction)zan:(UIButton*)sender {
    CoreManager * task = [[CoreManager alloc]init];
    
    int type = 1;
    if (sender.selected) {
        type = 2;
    }else{
        type = 1;
    }
    __block int count = [sender.titleLabel.text intValue];
    
    [task fq_zanShortVideoID:self.model.pid CommentID:self.model.id Type:type CompleteBlock:^(id success) {
        if (type==1) {
            sender.selected = YES;
            count+=1;
            self.model.is_dianzan = YES;
            [sender setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
            
        }else{
            sender.selected = NO;
            count -=1;
            self.model.is_dianzan = NO;
            [sender setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];
        }
        self.model.shortvideo_com_dianzanshu_sort = count;
    } FaildBlock:^(id error) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
