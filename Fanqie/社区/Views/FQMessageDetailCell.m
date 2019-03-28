//
//  FQMessageDetailCell.m
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQMessageDetailCell.h"
#import "SJActionSheet.h"

@implementation FQMessageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImage.layer.cornerRadius = 20.5;
    _iconImage.layer.masksToBounds = YES;
}
- (IBAction)more:(id)sender {
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
