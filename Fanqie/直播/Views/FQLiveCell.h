//
//  FQLiveCell.h
//  Fanqie
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQLiveModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FQLiveCell : UICollectionViewCell

-(void)updateContentWithModel:(FQLiveModel*)model;
@end
