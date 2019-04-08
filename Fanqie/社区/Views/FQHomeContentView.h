//
//  FQHomeContentView.h
//  Fanqie
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQCommunityBaseCell.h"
#import "CoreManager+Home.h"
#import <MJRefresh.h>

@interface FQHomeContentView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIScrollView*scrollView;
@property (nonatomic,strong)UITableView*recommandTable;
@property (nonatomic,strong)UITableView*attentionTable;
-(void)initData;
@end
