//
//  FQUserInfoHeaderView.m
//  Fanqie
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQUserInfoHeaderView.h"
#import "CoreManager+Home.h"
@interface FQUserInfoHeaderView()
@property (nonatomic,strong)FQUserInfoModel*model;
@end

@implementation FQUserInfoHeaderView

-(void)updateContentWithModel:(FQUserInfoModel *)model{
    self.model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.head_portrait] placeholderImage:[UIImage imageNamed:@"图像默认"]];
    self.attention.text  = [NSString stringWithFormat:@"%d关注",model.countfollow];
    self.fans.text = [NSString stringWithFormat:@"%d粉丝",model.countfans];
    self.nickName.text = model.nikname;
    self.des.text = model.autograph;
    if (model.id == [FQUserModel share].userid) {
        [_modifyButton setHidden:NO];
        [_attention setHidden:YES];
    }else{
        [_modifyButton setHidden:YES];
        [_attention setHidden:NO];
    }
    
}

- (IBAction)attention:(UIButton *)sender {
    CoreManager * task = [[CoreManager alloc]init];
    int type = 0 ;
    if (sender.selected) {
        type = 2;
    }else{
        type = 1;
    }
    [task fq_followingWithUserID:self.model.id Type:type CompleteBlock:^(id success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (type) {
                case 1:
                {
                    //已关注 取消关注 按钮置为加关注状态
                    [self.attentionButton setBackgroundColor: UIColorFromRGB(0xff5252)];
                    [self.attentionButton setTitle:@"+关注" forState:UIControlStateNormal];
                    [sender setSelected:NO];
                }
                    break;
                case 2:
                {
                    //加关注成功 按钮置为已关注状态
                    [self.attentionButton setBackgroundColor: UIColorFromRGB(0xcccccc)];
                    [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                    [sender setSelected:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
        });
    } FaildBlock:^(id error) {
        
    }];
}

@end
