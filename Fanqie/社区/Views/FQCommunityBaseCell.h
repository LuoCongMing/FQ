//
//  FQCommunityBaseCell.h
//  Fanqie
//
//  Created by mac on 2019/3/18.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQCustomButton.h"
static NSString*fq_allCharacter = @"fq_allCharacter";
static NSString*fq_commentDetail = @"fq_commentDetail";
@interface FQCommunityBaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *fq_contenView;
@property (weak, nonatomic) IBOutlet FQCustomButton *shareButton;
@property (weak, nonatomic) IBOutlet FQCustomButton *commentButton;
@property (weak, nonatomic) IBOutlet FQCustomButton *likeButton;

///纯文本
-(void)updateCharacterContentWithModel:(id)model;
///图片
-(void)updatePictureContentWithModel:(id)model;
///视频
-(void)updateVedioContentWithModel:(id)model;
@end
