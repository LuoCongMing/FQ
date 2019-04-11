//
//  FQVideoCommentView.m
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQVideoCommentView.h"
#import "FQShortVideoCommentCell.h"

@implementation FQVideoCommentView
-(void)awakeFromNib{
    [super awakeFromNib];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *HUDView = [[UIVisualEffectView alloc] initWithEffect:blur];
    HUDView.alpha = 0.9f;
    [self.fqvideoCommentView addSubview:HUDView];
    [HUDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.fqvideoCommentView);
    }];
    
    self.fqvideoCommentView.layer.cornerRadius = 20;
    self.fqvideoCommentView.layer.masksToBounds = YES;
    
    
    _dataSource = [[NSMutableArray alloc]init];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.tableFooterView = [UIView new];
    self.table.estimatedRowHeight = 80;
    self.table.rowHeight = UITableViewAutomaticDimension;
    [self.table registerNib:[UINib nibWithNibName:@"FQShortVideoCommentCell" bundle:nil] forCellReuseIdentifier:@"FQShortVideoCommentCell"];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.textField.delegate = self;
    self.textField.bizType = BizTextFieldTypeWithoutEmoji;
    BizTextFieldDelegateHook *hook = self.textField.delegate;
    
    @weakify(self)
    hook.textfieldReturn = ^(NSString *text) {
        @strongify(self)
        [self.task fq_publicShortVideoCommenID:self.model.id Content:text CompleteBlock:^(id success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                hud.detailsLabel.text = @"评论成功";
                [hud hideAnimated:YES];
                [self getCommentList];
            });
        } FaildBlock:^(id error) {
            
        }];
    };
    
    
    
}
-(void)keyboardShow:(NSNotification*)notify{
    NSDictionary *userInfo = notify.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    @weakify(self)
    self.textFieldBottomConstant.constant = -height;
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        [self layoutIfNeeded];
    }];
}
-(void)keyboardHiden:(NSNotification*)notify{
    @weakify(self)
    self.textFieldBottomConstant.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        [self layoutIfNeeded];
    }];
}

-(void)fq_hiden{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setHidden:YES];
    ///重置评论列表
    [self.dataSource removeAllObjects];
    self.page = 1;
    [self.table reloadData];
    
    
    @weakify(self)
    self.topConstant.constant = iPhone_Height;
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        [self layoutIfNeeded];
    }];
}
- (IBAction)cancel:(id)sender {
    [self fq_hiden];
}
-(CoreManager*)task{
    if (_task == nil) {
        _task = [[CoreManager alloc]init];
    }
    return _task;
}

-(void)showWithModel:(FQVideoModel *)model{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHiden:) name:UIKeyboardWillHideNotification object:nil];
    ///
    [self setHidden:NO];
    self.model = model;
    @weakify(self)
    self.topConstant.constant = iPhone_Height/3.0;
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self)
        [self layoutIfNeeded];
    }];
    self.dataSource = [[NSMutableArray alloc]init];
    self.page = 1;
    
    [self getCommentList];
}

-(void)getCommentList{
    [self.task fq_shortVideoCommentWithId:self.model.id Page:self.page CompleteBlock:^(id success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.page == 1) {
                [self.dataSource removeAllObjects];
            }
            [self.dataSource addObjectsFromArray:success[@"array"]];
            [self.table reloadData];
        });
    } FaildBlock:^(id error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return 6;
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FQShortVideoCommentCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQShortVideoCommentCell"];
    [cell updateContentWithModel:self.dataSource[indexPath.row]];
    return cell;
    
}
@end
