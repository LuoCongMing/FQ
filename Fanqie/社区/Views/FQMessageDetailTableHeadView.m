//
//  FQMessageDetailTableHeadView.m
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQMessageDetailTableHeadView.h"
#import "XLPhotoBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation FQMessageDetailAuthorInfo
-(void)awakeFromNib{
    [super awakeFromNib];
    _attentionbutton.layer.cornerRadius = 11;
    _attentionbutton.layer.masksToBounds = YES;
    [_attentionbutton setTitle:@"已关注" forState:UIControlStateSelected];
    [_attentionbutton setTitle:@"+关注" forState:UIControlStateNormal];
    
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 20.5;
    
}

- (IBAction)attention:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = UIColorFromRGB(0xcccccc);
    }else{
        sender.backgroundColor = UIColorFromRGB(0xff5252);
    }
}
@end

@implementation FQMessageDetailClickButtonView
//分享
- (IBAction)share:(id)sender {
}
//收藏
- (IBAction)collection:(id)sender {
}
//赞
- (IBAction)like:(id)sender {
}

@end
@interface FQMessageDetailTableHeadView()

@property (nonatomic,strong)FQMessageDetailAuthorInfo*info;

@property (nonatomic,strong)FQMessageDetailClickButtonView*buttonView;
///文字内容


@end

@implementation FQMessageDetailTableHeadView


///文本
-(CGFloat)updateCharacterContentWithModel:(id)model{
    
    self.model = model;
    [self addSubview:self.info];
    //
    NSString * title = self.model.title;
    NSString*content = self.model.textcontent;
    
    
    self.titleLabel.text = title;
    CGFloat W = iPhone_Width - 26;
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(W, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PingFangSCM(18)} context:nil].size;
    self.titleLabel.frame = CGRectMake(13, CGRectGetMaxY(_info.frame), W, titleSize.height);
    [self addSubview:self.titleLabel];
    
    UILabel*contentLabel = [[UILabel alloc]init];
    contentLabel.numberOfLines = 0;

    NSMutableParagraphStyle*para = [[NSMutableParagraphStyle alloc]init];
    para.lineSpacing = 5;
    para.paragraphSpacing = 10;

    NSDictionary*attribute = @{NSFontAttributeName:PingFangSC(15),NSForegroundColorAttributeName:[UIColor blackColor],NSParagraphStyleAttributeName:para};
    NSMutableAttributedString*attributeString = [[NSMutableAttributedString alloc]initWithString:content attributes:attribute];
    CGSize contentSize =  [attributeString boundingRectWithSize:CGSizeMake(iPhone_Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    contentLabel.frame = CGRectMake(13, CGRectGetMaxY(_titleLabel.frame)+20, iPhone_Width-26, contentSize.height);
    
    contentLabel.attributedText = attributeString;
    [self addSubview:contentLabel];
    
    UIView*footbuttonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(contentLabel.frame)+20, iPhone_Width, 50)];
    footbuttonView.backgroundColor = [UIColor redColor];
    self.buttonView = [[UINib nibWithNibName:@"FQMessageDetailClickButtonView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    [footbuttonView addSubview:self.buttonView];
    [self addSubview:footbuttonView];
    
    [self.info.iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.head_portrait]];
    
    self.info.nickName.text = self.model.user_nikname;
    [self.buttonView.likeButton setSelected:self.model.is_dianzan];
    [self.buttonView.likeButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_dianzanncount] forState:UIControlStateNormal];
    [self.buttonView.shareButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_sharcount] forState:UIControlStateNormal];
    
    
    ////收藏次数
    [self.buttonView.collectButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_commentcount] forState:UIControlStateNormal];
    
    return CGRectGetMaxY(footbuttonView.frame);
    
}

-(CGFloat)updatePictureContentWithModel:(id)model{
    self.model = model;
    [self addSubview:self.info];
    //
//    NSString * title = @"测试标题";
    self.titleLabel.text = self.model.title;
    CGFloat W = iPhone_Width - 26;
    CGSize titleSize = [self.model.title boundingRectWithSize:CGSizeMake(W, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PingFangSCM(18)} context:nil].size;
    self.titleLabel.frame = CGRectMake(13, CGRectGetMaxY(_info.frame), W, titleSize.height);
    [self addSubview:self.titleLabel];
    
    CGFloat gridWidth = (iPhone_Width-26-10)/3.0;//格子的宽度
    CGFloat gridHeight = gridWidth;//格子的高度
    NSInteger rowNumber = 3;//每行几个
    //间距x,y
    CGFloat originX = 13;
    CGFloat originY = CGRectGetMaxY(_titleLabel.frame)+20;
    CGFloat marginX = 5;
    CGFloat marginY = 5;
    __block CGFloat maxY = 0;
    for (int i = 0 ;i<self.model.pictureArray.count;i++) {
        UIImageView*imageV = [[UIImageView alloc]init];
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.model.pictureArray[i]] placeholderImage:[UIImage imageNamed:@"图像默认"]];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
//        imageV.backgroundColor = [UIColor redColor];
        imageV.tag = i;
        imageV.userInteractionEnabled = YES;
        imageV.layer.masksToBounds = YES;
        [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBrower:)]];
        imageV.layer.masksToBounds = YES;
        [self addSubview:imageV];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(originX + i % rowNumber * (gridWidth + marginX));
            make.top.mas_equalTo(originY + i / rowNumber * (gridHeight + marginY));
            make.width.mas_equalTo(gridWidth);
            make.height.mas_equalTo(gridHeight);
            maxY  = originY+gridHeight + i / rowNumber * (gridHeight + marginY);
        }];
        
    }
    
    UIView*footbuttonView = [[UIView alloc]initWithFrame:CGRectMake(0, maxY+23, iPhone_Width, 50)];
    footbuttonView.backgroundColor = [UIColor redColor];
    self.buttonView = [[UINib nibWithNibName:@"FQMessageDetailClickButtonView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    [footbuttonView addSubview:self.buttonView];
    [self addSubview:footbuttonView];
    
    [self.info.iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.head_portrait]];
    
    self.info.nickName.text = self.model.user_nikname;
    [self.buttonView.likeButton setSelected:self.model.is_dianzan];
    [self.buttonView.likeButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_dianzanncount] forState:UIControlStateNormal];
    [self.buttonView.shareButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_sharcount] forState:UIControlStateNormal];
    
    
    ////收藏次数
    [self.buttonView.collectButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_commentcount] forState:UIControlStateNormal];
    
    return CGRectGetMaxY(footbuttonView.frame);
}

-(CGFloat)updateVedioContentWithModel:(id)model{
    
    self.model = model;
    [self addSubview:self.info];
    //
    NSString * title = self.model.title;
    
    self.titleLabel.text = title;
    CGFloat W = iPhone_Width - 26;
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(W, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PingFangSCM(18)} context:nil].size;
    self.titleLabel.frame = CGRectMake(13, CGRectGetMaxY(_info.frame), W, titleSize.height);
    [self addSubview:self.titleLabel];
    
    UIView*footbuttonView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+20, iPhone_Width, 50)];
    footbuttonView.backgroundColor = [UIColor redColor];
    self.buttonView = [[UINib nibWithNibName:@"FQMessageDetailClickButtonView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    [footbuttonView addSubview:self.buttonView];
    [self addSubview:footbuttonView];
    
    [self.info.iconImage sd_setImageWithURL:[NSURL URLWithString:self.model.head_portrait]];
    
    self.info.nickName.text = self.model.user_nikname;
    [self.buttonView.likeButton setSelected:self.model.is_dianzan];
    [self.buttonView.likeButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_dianzanncount] forState:UIControlStateNormal];
    [self.buttonView.shareButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_sharcount] forState:UIControlStateNormal];
    
    
    ////收藏次数
    [self.buttonView.collectButton setTitle:[NSString stringWithFormat:@"%d",self.model.community_commentcount] forState:UIControlStateNormal];
    
    return CGRectGetMaxY(footbuttonView.frame);
    
}

-(void)showBrower:(UITapGestureRecognizer*)tap{
    
    [XLPhotoBrowser showPhotoBrowserWithImages:self.model.pictureArray currentImageIndex:tap.view.tag];
}
-(FQMessageDetailAuthorInfo*)info{
    if (_info == nil) {
        FQMessageDetailAuthorInfo*info = [[UINib nibWithNibName:@"FQMessageDetailAuthorInfo" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
        info.frame = CGRectMake(0, 0, iPhone_Width, 68);
        _info = info;
    }
    return _info;
}
//-(FQMessageDetailClickButtonView*)buttonView{
//    if (_buttonView == nil) {
//        _buttonView = [[UINib nibWithNibName:@"FQMessageDetailClickButtonView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
//
//    }
//    return _buttonView;
//}
-(UILabel*)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = PingFangSCM(18);
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

@end
