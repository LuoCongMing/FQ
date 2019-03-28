//
//  FQLiveCell.h
//  Fanqie
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQLiveCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backGrandImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveTitle;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *liveNum;
@property (weak, nonatomic) IBOutlet UIView *redPoint;

@end
