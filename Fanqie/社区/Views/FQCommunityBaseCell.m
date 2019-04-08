//
//  FQCommunityBaseCell.m
//  Fanqie
//
//  Created by mac on 2019/3/18.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQCommunityBaseCell.h"
#import <MBProgressHUD.h>
#import "SJActionSheet.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoreManager+Home.h"
#import "MJPhotoBrowser.h"

@interface FQCommunityBaseCell()
///文字内容
@property (nonatomic,strong)UILabel*characterLabel;
@property (nonatomic,strong)UIButton*allButton;
@property (nonatomic,strong)FQCommunityIndexModel*model;



@end

@implementation FQCommunityBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = 12.5;
    self.iconImage.layer.masksToBounds = YES;
}
//图片
-(void)updatePictureContentWithModel:(FQCommunityIndexModel*)model{
    self.model = model;
    
    for (UIView*view in _fq_contenView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat gridWidth = (iPhone_Width-26-10)/3.0;//格子的宽度
    CGFloat gridHeight = gridWidth;//格子的高度
    NSInteger rowNumber = 3;//每行几个
    //间距x,y
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat marginX = 5;
    CGFloat marginY = 5;
    
    NSArray * images = [model.picturecontent componentsSeparatedByString:@","];
    NSMutableArray*mArray = [[NSMutableArray alloc]init]
    ;
    
    for (int i = 0 ;i<images.count;i++) {
        UIImageView*imageV = [[UIImageView alloc]init];
        NSString*url = images[i];
        [mArray addObject:url];
        [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"图片默认"]];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.tag = i;
        imageV.userInteractionEnabled = YES;
        [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBrower:)]];
        imageV.layer.masksToBounds = YES;
        [_fq_contenView addSubview:imageV];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(originX + i % rowNumber * (gridWidth + marginX));
            make.top.mas_equalTo(originY + i / rowNumber * (gridHeight + marginY));
            make.width.mas_equalTo(gridWidth);
            make.height.mas_equalTo(gridHeight);
            if (i==images.count-1) {
                make.bottom.mas_equalTo(0);
            }
        }];
        
    }
    self.model.pictureArray = mArray;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.head_portrait]];
    self.titleLabel.text = model.title;
    self.nickName.text = model.user_nikname;
    [self.likeButton setSelected:model.is_dianzan];
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",model.community_dianzanncount] forState:UIControlStateNormal];
    [self.shareButton setTitle:[NSString stringWithFormat:@"%d",model.community_sharcount] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%d",model.community_commentcount] forState:UIControlStateNormal];
}
   
-(void)showBrower:(UITapGestureRecognizer*)tap{
    
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<self.model.pictureArray.count; i++) {
       
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:self.model.pictureArray[i]]; // 图片路径
        photo.srcImageView = tap.view; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];

    
}



///文本
-(void)updateCharacterContentWithModel:(FQCommunityIndexModel*)model{
    self.model = model;
    for (UIView*view in _fq_contenView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableParagraphStyle*para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = 5;
    para.paragraphSpacing = 15;
    
    NSDictionary*attribute = @{NSFontAttributeName:PingFangSC(15),NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:para};
    NSMutableAttributedString*attributeString = [[NSMutableAttributedString alloc]initWithString:model.textcontent attributes:attribute];
    CGSize size =  [attributeString boundingRectWithSize:CGSizeMake(iPhone_Width, 100) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if (_characterLabel == nil) {
        _characterLabel = [[UILabel alloc]init];
        _characterLabel.numberOfLines = 0;
        _characterLabel.layer.masksToBounds = YES;
        [self.fq_contenView addSubview:_characterLabel];
    }
    if (_allButton == nil) {
        _allButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_allButton setTitle:@"全文" forState:UIControlStateNormal];
        _allButton.tag = 99;
        _allButton.titleLabel.font = PingFangSC(15);
    }
    _characterLabel.attributedText = attributeString;
   
    [_characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.top.and.right.mas_equalTo(0);
        make.size.mas_equalTo(size);
    }];

    if(size.height>=80){
        self.allButton.frame = CGRectMake(0, CGRectGetMaxY(_fq_contenView.frame)+5, 30, 20);
        [self.fq_contenView addSubview:self.allButton];
        [_characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
        }];
        [_allButton addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchUpInside];
            [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.bottom.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(30, 20));
            }];
    }else{
        
        [_characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.head_portrait]];
    self.titleLabel.text = model.title;
    self.nickName.text = model.user_nikname;
    [self.likeButton setSelected:model.is_dianzan];
    [self.likeButton setTitle:[NSString stringWithFormat:@"%d",model.community_dianzanncount] forState:UIControlStateNormal];
    [self.shareButton setTitle:[NSString stringWithFormat:@"%d",model.community_sharcount] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%d",model.community_commentcount] forState:UIControlStateNormal];
    
    
    
}

#pragma mark 全文
-(void)all{
    [self routerEventWithName:fq_allCharacter dataInfo:nil];
}
#pragma mark 分享

- (IBAction)share:(id)sender {
    
     CoreManager*task = [[CoreManager alloc]init];
    [task fq_copyCompleteBlock:^(id success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.label.text = @"复制成功";
            [hud hideAnimated:YES afterDelay:1.0];
            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = success[@"info"][@"name"];
        });
    } FaildBlock:^(id error) {
        
    }];
    
    
}

#pragma mark 点赞
- (IBAction)zan:(UIButton*)sender {
    CoreManager*task = [[CoreManager alloc]init];
    int type = 1;
    if (sender.selected) {
        type = 2;
    }else{
        type = 1;
    }
    @weakify(self)
    [task fq_zanWithID:self.model.id Type:type CompleteBlock:^(id success) {
        @strongify(self)
        self.model.is_dianzan = type==1?YES:NO;
        sender.selected = self.model.is_dianzan;
    } FaildBlock:^(id error) {
        
    }];
    
}

#pragma mark 评论

- (IBAction)comment:(id)sender {
    [self routerEventWithName:fq_commentDetail dataInfo:nil];
}
- (IBAction)arrow:(UIButton *)sender {
    SJActionSheet*sheet = [[SJActionSheet alloc]initSheetWithTitle:@"" style:SJSheetStyleWeiChat itemTitles:@[@"收藏",@"关注",@"屏蔽",@"举报"]];
    sheet.itemTextColor = UIColorFromRGB(0x323232);
    sheet.itemTextFont = PingFangSC(15);
    sheet.cancelTextFont = PingFangSC(15);
    sheet.cancelTextColor = UIColorFromRGB(0x323232);
    [sheet didFinishSelectIndex:^(NSInteger index, NSString *title) {
        switch (index) {
            case 1:
            {
                //关注
                CoreManager * task = [[CoreManager alloc]init];
                [task fq_followingWithUserID:self.model.user_id Type:1 CompleteBlock:^(id success) {
                    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.label.text = @"关注成功";
                    [hud hideAnimated:YES afterDelay:1.0];
                } FaildBlock:^(id error) {
                    
                }];
            }
                break;
                
            default:
                break;
        }
    }];
    [sheet show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
