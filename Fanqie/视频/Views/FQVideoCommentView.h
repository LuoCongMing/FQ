//
//  FQVideoCommentView.h
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQVideoModel.h"
#import "CoreManager+Video.h"
#import "BizTextFieldDelegateHook.h"
@interface FQVideoCommentView : UIView<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldBottomConstant;

///高斯模糊效果View
@property (weak, nonatomic) IBOutlet UIView *fqvideoCommentView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,strong)CoreManager * task;
@property (nonatomic,assign)int page;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong)FQVideoModel*model;

-(void)showWithModel:(FQVideoModel*)model;
-(void)fq_hiden;
@end
