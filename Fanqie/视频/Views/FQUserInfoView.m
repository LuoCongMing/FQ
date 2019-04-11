//
//  FQUserInfoView.m
//  Fanqie
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQUserInfoView.h"
#import "NSDate+Extend.h"
@interface FQUserInfoView()
@property (weak, nonatomic) IBOutlet UILabel *userLevel;
@property (weak, nonatomic) IBOutlet UILabel *jinyan;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *regTime;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UILabel *sexualorientation;
@property (weak, nonatomic) IBOutlet UILabel *hunyin;
@property (weak, nonatomic) IBOutlet UILabel *friendship;
@property (weak, nonatomic) IBOutlet UILabel *countState;
@property (weak, nonatomic) IBOutlet UILabel *sign;

@end

@implementation FQUserInfoView

-(void)updatecontentWithModel:(FQUserInfoModel *)model{
    switch (model.sex) {
        case 1:
        {
            _sexLabel.text = @"男";
        }
            break;
        case 2:
        {
             _sexLabel.text = @"女";
        }
            break;

            
        default:
            _sexLabel.text = @"未知";
            break;
    }
    
    _address.text = model.address;
    _regTime.text = [NSDate getDateStringWithAllDate:model.reg_time];
    _birthday.text = [NSDate getDateStringWithAllDate:model.birthday];
    _sexualorientation.text = model.sexualorientation;
    
    switch (model.hunyin) {
        case 1:
        {
            _hunyin.text = @"单身";
        }
            break;
        case 2:
        {
            _hunyin.text = @"已婚";
        }
            break;
            
            
        default:
            _hunyin.text = @"恋爱中";
            break;
    }
    _friendship.text = model.friendsintention;
    _sign.text = model.autograph;
    
    
}

@end
