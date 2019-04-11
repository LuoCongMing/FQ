//
//  FQUserInfoBottomView.m
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQUserInfoBottomView.h"

@implementation FQUserInfoBottomView
- (IBAction)jubao:(id)sender {
}

- (IBAction)attention:(id)sender {
}

- (IBAction)pingbi:(id)sender {
    
}

- (IBAction)cancel:(id)sender {
    [self fq_hiden];
}
- (IBAction)viewClick:(id)sender {
    [self fq_hiden];
}


-(void)fq_show{
    [self setHidden:NO];
    @weakify(self)
    self.bottomConstant.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        [self layoutIfNeeded];
    }];
}
-(void)fq_hiden{
    
    [self setHidden:YES];
    @weakify(self)
    self.bottomConstant.constant = -175;
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        [self layoutIfNeeded];
    }];
}
@end
