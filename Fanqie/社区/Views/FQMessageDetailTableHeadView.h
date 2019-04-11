//
//  FQMessageDetailTableHeadView.h
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQCommunityIndexModel.h"
#import "FQCustomButton.h"
@interface FQMessageDetailTableHeadView : UIView

@property (nonatomic,strong)UILabel*titleLabel;

-(CGFloat)updateCharacterContentWithModel:(id)model;
-(CGFloat)updatePictureContentWithModel:(id)model;
-(CGFloat)updateVedioContentWithModel:(id)model;
@property (nonatomic,strong)FQCommunityIndexModel*model;
@end

@interface FQMessageDetailAuthorInfo : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
///性别
@property (weak, nonatomic) IBOutlet UIImageView *setImageView;
@property (weak, nonatomic) IBOutlet UIButton *attentionbutton;
@property (weak, nonatomic) IBOutlet UILabel *creatInfoLabel;



@end

@interface FQMessageDetailClickButtonView : UIView
@property (weak, nonatomic) IBOutlet FQCustomButton *shareButton;
@property (weak, nonatomic) IBOutlet FQCustomButton *collectButton;
@property (weak, nonatomic) IBOutlet FQCustomButton *likeButton;
@end
