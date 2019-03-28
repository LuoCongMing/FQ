//
//  FQMessageDetailTableHeadView.m
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQMessageDetailTableHeadView.h"

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
    
    [self addSubview:self.info];
    //
    NSString * title = @"测试标题";
    NSString*content = @"法院判案，应该给原告、被告送达相同的裁判文书，这是基本的法律常识。然而，辽宁省绥中县人民法院在审理一起合同纠纷案件时，却给原被告送达了两份截然不同的裁判文书";
    
    
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
    
    return CGRectGetMaxY(footbuttonView.frame);
    
}

-(CGFloat)updatePictureContentWithModel:(id)model{
    [self addSubview:self.info];
    //
    NSString * title = @"测试标题";
    
    self.titleLabel.text = title;
    CGFloat W = iPhone_Width - 26;
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(W, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:PingFangSCM(18)} context:nil].size;
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
    for (int i = 0 ;i<9;i++) {
        UIImageView*imageV = [[UIImageView alloc]init];
        
        imageV.image = [UIImage imageNamed:@""];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.backgroundColor = [UIColor redColor];
        [self addSubview:imageV];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.mas_equalTo(originX + i % rowNumber * (gridWidth + marginX));
            make.top.mas_equalTo(originY + i / rowNumber * (gridHeight + marginY));
            make.width.mas_equalTo(gridWidth);
            make.height.mas_equalTo(gridHeight);
            maxY  = originY+gridHeight + i / rowNumber * (gridHeight + marginY);
        }];
        
    }
    
    UIView*footbuttonView = [[UIView alloc]initWithFrame:CGRectMake(0, maxY+20, iPhone_Width, 50)];
    footbuttonView.backgroundColor = [UIColor redColor];
    self.buttonView = [[UINib nibWithNibName:@"FQMessageDetailClickButtonView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    [footbuttonView addSubview:self.buttonView];
    [self addSubview:footbuttonView];
    
    return CGRectGetMaxY(footbuttonView.frame);
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
