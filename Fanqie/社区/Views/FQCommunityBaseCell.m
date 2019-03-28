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

@interface FQCommunityBaseCell()
///文字内容
@property (nonatomic,strong)UILabel*characterLabel;
@property (nonatomic,strong)UIButton*allButton;

@end

@implementation FQCommunityBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//图片
-(void)updatePictureContentWithModel:(id)model{
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
    for (int i = 0 ;i<9;i++) {
        UIImageView*imageV = [[UIImageView alloc]init];
        
        imageV.image = [UIImage imageNamed:@""];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.backgroundColor = [UIColor redColor];
        [_fq_contenView addSubview:imageV];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(originX + i % rowNumber * (gridWidth + marginX));
            make.top.mas_equalTo(originY + i / rowNumber * (gridHeight + marginY));
            make.width.mas_equalTo(gridWidth);
            make.height.mas_equalTo(gridHeight);
            if (i==8) {
                make.bottom.mas_equalTo(0);
            }
        }];
        
    }
}
   
   
    
   
///文本
-(void)updateCharacterContentWithModel:(id)model{
    for (UIView*view in _fq_contenView.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableParagraphStyle*para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = 5;
    para.paragraphSpacing = 15;
    
    NSDictionary*attribute = @{NSFontAttributeName:PingFangSC(15),NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:para};
    NSMutableAttributedString*attributeString = [[NSMutableAttributedString alloc]initWithString:@"测试这是一段长文字案例看结果拉卡价格看来就爱看了感觉记录" attributes:attribute];
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
    
}

#pragma mark 全文
-(void)all{
    [self routerEventWithName:fq_allCharacter dataInfo:nil];
}
#pragma mark 分享

- (IBAction)share:(id)sender {
    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.label.text = @"复制成功";
    [hud hideAnimated:YES afterDelay:1.0];
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = @"测试复制内容";
}

#pragma mark 点赞
- (IBAction)zan:(id)sender {
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
        NSLog(@"%@==%ld",title,(long)index);
    }];
    [sheet show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
