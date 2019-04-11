//
//  FQShortVideoCommentCell.h
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQVedioButton.h"
#import "FQShortVideoCommentModel.h"
@interface FQShortVideoCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet FQVedioButton *zanClick;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong)FQShortVideoCommentModel*model;
-(void)updateContentWithModel:(FQShortVideoCommentModel*)model;
@end
