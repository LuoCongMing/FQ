//
//  FQMessageDetailCell.m
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQMessageDetailCell.h"
#import "SJActionSheet.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoreManager+Home.h"

@interface FQMessageDetailCell()
@property (nonatomic,strong)FQCommunityCommentModel*model;


@end
@implementation FQMessageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImage.layer.cornerRadius = 20.5;
    _iconImage.layer.masksToBounds = YES;
}
-(void)updateContentWithModel:(FQCommunityCommentModel *)model{
    self.model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.head_portrait] placeholderImage:[UIImage imageNamed:@"图片默认"]];
    self.nickName.text = model.user_nikname;
    self.contentLabel.text = model.commentcontent;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",model.community_dianzanncount] forState:UIControlStateNormal];
    [self.likeButton setSelected:model.is_dianzan];
    
}
- (IBAction)more:(id)sender {
    SJActionSheet*sheet = [[SJActionSheet alloc]initSheetWithTitle:@"" style:SJSheetStyleWeiChat itemTitles:@[@"关注",@"举报"]];
    sheet.itemTextColor = UIColorFromRGB(0x323232);
    sheet.itemTextFont = PingFangSC(15);
    sheet.cancelTextFont = PingFangSC(15);
    sheet.cancelTextColor = UIColorFromRGB(0x323232);
    [sheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        if (index == 0) {
            [self guanzhu];
        }
    }];
    [sheet show];
}

-(void)guanzhu{
    CoreManager * task = [[CoreManager alloc]init];
    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [task fq_followingWithUserID:self.model.user_id Type:1 CompleteBlock:^(id success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.detailsLabel.text = @"已关注";
            [hud hideAnimated:YES afterDelay:0.5];
        });
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES ];
        });
    }];
}

- (IBAction)zan:(UIButton *)sender {
    CoreManager * task = [[CoreManager alloc]init];
    int type = 1;
    if (sender.selected) {
        type = 2;
    }else{
        type = 1;
    }
 
    [task fq_zanWithComment_id:self.model.pid Type:type Community_id:self.model.id CompleteBlock:^(id success) {
        
    } FaildBlock:^(id error) {
        
    }];
    
    
}


-(void)jubao{
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
