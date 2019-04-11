//
//  FQUserInfoBottomView.h
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQUserInfoBottomView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;

-(void)fq_show;
-(void)fq_hiden;
@end
