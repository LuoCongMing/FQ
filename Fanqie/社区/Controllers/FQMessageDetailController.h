//
//  FQMessageDetailController.h
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQCommunityIndexModel.h"

typedef void(^DetailComplete)(void);
@interface FQMessageDetailController : UIViewController
@property (nonatomic,copy)DetailComplete backBlock;
@property (nonatomic,strong)FQCommunityIndexModel*model;
@end
