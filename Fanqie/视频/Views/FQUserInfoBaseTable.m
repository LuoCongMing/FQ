//
//  FQUserInfoBaseTable.m
//  Fanqie
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQUserInfoBaseTable.h"

@implementation FQUserInfoBaseTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


@end
