//
//  FQPublishVC.h
//  Fanqie
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FQPulicComplete)(void);
@interface FQPublishVC : UIViewController
@property (nonatomic,copy)FQPulicComplete pulicComplete;
@end
