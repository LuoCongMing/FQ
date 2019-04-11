//
//  FQVideoTCell.m
//  Fanqie
//
//  Created by mac on 2019/4/9.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQVideoTCell.h"
#import "CoreManager+Home.h"
#import "CoreManager+Video.h"


@implementation FQVideoTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    _zanButton.titleLabel.textAlignment = 1;
    _shareButton.titleLabel.textAlignment = 1;
    _commentButton.titleLabel.textAlignment = 1;
    
}
-(void)playIndexpath:(NSIndexPath *)indexpath Table:(UITableView *)table{
    
    SJPlayModel *playModel = [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:99 // 请务必设置tag, 且不能等于0. 由于重用机制, 当视图滚动时, 播放器需要通过此tag寻找其父视图
                                                    atIndexPath:indexpath
                                                      tableView:table];
    SJVideoPlayerURLAsset *asset =
    [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.model.url]
                                     playModel:playModel];
    
  
    
    _player = [SJVideoPlayer player];
    [_player.defaultEdgeControlLayer.topContainerView setHidden:YES];
    [_player.defaultEdgeControlLayer.bottomContainerView setHidden:YES];
    [_vedioImageView addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    // 设置资源
    _player.URLAsset = asset;
}
-(void)updateContentWithModel:(FQVideoModel *)model{
    self.model = model;
    _nickName.text = model.user_nikname;
    _fq_description.text = model.title;
    [_zanButton setTitle:[NSString stringWithFormat:@"%d",model.shortvideo_dianzanncount] forState:UIControlStateNormal];
    [_shareButton setTitle:[NSString stringWithFormat:@"%d",model.shortvideo_sharcount] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%d",model.shortvideo_commentcount] forState:UIControlStateNormal];
    
    [_iconButton sd_setImageWithURL:[NSURL URLWithString:model.head_portrait] forState:UIControlStateNormal];
    
    if (model.is_follow) {
        [self.attentionButton setHidden:YES];
    }else{
        [self.attentionButton setHidden:NO];
    }
    [_zanButton setSelected:model.is_dianzan];
    
    if (self.model.is_follow) {
        [_attentionButton setHidden:YES];
    }else{
        [_attentionButton setHidden:NO];
    }
    
//    if (self.model.thubImage!=nil) {
//        _vedioImageView.image = self.model.thubImage;
//    }else{
//        @weakify(self)
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.vedioImageView.image =  [CoreManager getThumbnailImage:model.url];
//            self.model.thubImage = self.vedioImageView.image;
//        });
//    }
    
}


///
- (IBAction)zan:(UIButton*)sender {
    CoreManager*core = [[CoreManager alloc]init];
    
    int type = 1;
    if (sender.selected) {
        type = 2;
    }else{
        type = 1;
    }
   __block int count = [sender.titleLabel.text intValue];
    [core fq_shortVideoZanWithID:self.model.id Type:type CompleteBlock:^(id success) {
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
        self.model.shortvideo_dianzanncount = count;
    } FaildBlock:^(id error) {
        
    }];
}

- (IBAction)share:(id)sender {
    [self routerEventWithName:fq_share dataInfo:@{@"model":self.model}];
}

///点击用户头像跳转用户详情
- (IBAction)userInfo:(id)sender {
    [self routerEventWithName:fq_UserInfo dataInfo:@{@"model":self.model}];
}

///加关注
- (IBAction)addFollow:(UIButton*)sender {
    CoreManager*task = [[CoreManager alloc]init];
    [task fq_followingWithUserID:self.model.user_id Type:1 CompleteBlock:^(id success) {
        [sender setHidden:YES];
    } FaildBlock:^(id error) {
        
    }];
}

- (IBAction)comment:(id)sender {
    [self routerEventWithName:fq_comment dataInfo:@{@"model":self.model,@"sender":sender}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
