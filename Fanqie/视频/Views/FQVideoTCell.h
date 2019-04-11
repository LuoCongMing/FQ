//
//  FQVideoTCell.h
//  Fanqie
//
//  Created by mac on 2019/4/9.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQVedioButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "FQVideoModel.h"
#import "CoreManager.h"
#import <SJVideoPlayer.h>

static NSString*fq_UserInfo = @"fq_Userinfo";
static NSString*fq_PostVedio = @"fq_PostVedio";
static NSString*fq_share = @"fq_share";
static NSString*fq_comment = @"fq_comment";
@interface FQVideoTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *fq_description;
@property (weak, nonatomic) IBOutlet FQVedioButton *zanButton;
@property (weak, nonatomic) IBOutlet FQVedioButton *commentButton;
@property (weak, nonatomic) IBOutlet FQVedioButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UIImageView *vedioImageView;

@property (nonatomic,strong)SJVideoPlayer*player;

@property (nonatomic,strong)FQVideoModel*model;

-(void)updateContentWithModel:(FQVideoModel*)model;

-(void)playIndexpath:(NSIndexPath*)indexpath Table:(UITableView*)table;
@end
