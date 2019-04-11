//
//  FQMessageDetailSectionHeader.h
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQMessageDetailSectionHeader : UIView
//最新
@property (weak, nonatomic) IBOutlet UIButton *ZuiXin;
//只看楼主
@property (weak, nonatomic) IBOutlet UISwitch *zhiKanLouZhu;

@end
