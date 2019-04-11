//
//  FQPostShortVideoVC.h
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^VideoPublicComplete)(void);
@interface FQPostShortVideoVC : UIViewController
@property (nonatomic,copy)VideoPublicComplete complete;
@end
