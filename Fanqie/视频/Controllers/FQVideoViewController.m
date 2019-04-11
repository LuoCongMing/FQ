//
//  FQVideoViewController.m
//  Fanqie
//
//  Created by 周建波 on 2019/3/13.
//  Copyright © 2019 周建波. All rights reserved.
//

#import "FQVideoViewController.h"
#import <JPVideoPlayerKit.h>
#import "FQVideoTCell.h"
#import "CoreManager+Video.h"
#import <SJVideoPlayer.h>
#import "FQPostShortVideoVC.h"
#import "FQVideoBottomView.h"
#import "FQVideoCommentView.h"
#import "FQUserInfoVC.h"

@interface FQVideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView*tableView;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,strong)CoreManager*task;
@property (nonatomic,assign)int page;
///没有更多视频
@property (nonatomic,assign)BOOL noMoreData;

//@property (nonatomic,strong)SJVideoPlayer*player;

@property (nonatomic,strong)FQVideoBottomView*bottomView;

@property (nonatomic,strong)FQVideoCommentView*commentView;

///tabbar黑色
@property (nonatomic,strong)UIView*tabbarBottomView;
@end

@implementation FQVideoViewController

-(UIView*)tabbarBottomView{
    if (_tabbarBottomView == nil) {
        _tabbarBottomView = [[UIView alloc]init];
        _tabbarBottomView.backgroundColor = [UIColor blackColor];
        [self.tabBarController.tabBar  insertSubview:_tabbarBottomView atIndex:0];
        _tabbarBottomView.frame = self.tabBarController.tabBar.bounds;
    }
    return _tabbarBottomView;
}
-(FQVideoBottomView*)bottomView{
    if (_bottomView == nil) {
        
        _bottomView = [[UINib nibWithNibName:@"FQVideoBottomView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
        _bottomView.frame = CGRectMake(0, 0, iPhone_Width,iPhone_Height);
        
        [[UIApplication sharedApplication].keyWindow addSubview:_bottomView];
        
    }
    
    return _bottomView;
}
-(FQVideoCommentView*)commentView{
    if (_commentView == nil) {
        _commentView = [[UINib nibWithNibName:@"FQVideoCommentView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
        _commentView.frame = CGRectMake(0, 0, iPhone_Width,iPhone_Height);
        
        [[UIApplication sharedApplication].keyWindow addSubview:_commentView];
    }
    return _commentView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    NSIndexPath*indexpath = [self.tableView indexPathForRowAtPoint:self.tableView.contentOffset];
    FQVideoTCell*cell = [self.tableView cellForRowAtIndexPath:indexpath];
    if (cell!=nil) {
        [cell.player play];
    }
    [self.tabbarBottomView setHidden:NO];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSIndexPath*indexpath = [self.tableView indexPathForRowAtPoint:self.tableView.contentOffset];
    FQVideoTCell*cell = [self.tableView cellForRowAtIndexPath:indexpath];
    if (cell!=nil) {
        [cell.player pause];
    }
    [self.tabbarBottomView setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initUI];
    [self initData];

}
-(void)initData{
    _task = [[CoreManager alloc]init];
    _page = 1;
    _dataSource = [[NSMutableArray alloc]init];
    [self getData];
}
-(void)getData{
    @weakify(self)
    [_task fq_getVideoListWithPage:self.page CompleteBlock:^(id success) {
        @strongify(self)
        NSArray*modelArray = success[@"array"];
        if (self.page == 1) {
            [self.dataSource removeAllObjects];
        }
        [self.dataSource addObjectsFromArray:success[@"array"]];
        if (self.page>=[success[@"page"] intValue]) {
            self.noMoreData = YES;
        }
        if (self.page == 1) {
            [self.tableView reloadData];
        }else{
            NSMutableArray*indexPathArray = [[NSMutableArray alloc]init];
            for (int i = (int)(self.dataSource.count-1-modelArray.count); i<self.dataSource.count; i++) {
                NSIndexPath*indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPathArray addObject:indexPath];
            }
            [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
        }
    } FaildBlock:^(id error) {
        
    }];

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.y/scrollView.bounds.size.height;
    if (index==self.dataSource.count-2) {
        ///请求更多数据
        
        if (self.noMoreData) {
            
        }else{
            self.page += 1;
            [self getData];
        }
        
    }
    if (index==self.dataSource.count-1&&self.noMoreData) {
        //没有更多数据源了
//        [self getData];
    }
    NSIndexPath*indexpath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
    FQVideoTCell*cell = [self.tableView cellForRowAtIndexPath:indexpath];
    if (cell!=nil) {
        [cell playIndexpath:indexpath Table:self.tableView];
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSIndexPath*indexpath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
    FQVideoTCell*cell = [self.tableView cellForRowAtIndexPath:indexpath];
    if (cell!=nil) {
        [cell.player pause];
    }
}


-(void)initUI{
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, iPhone_Height) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.pagingEnabled = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _tableView.estimatedRowHeight = iPhone_Height;
    
    [_tableView registerNib:[UINib nibWithNibName:@"FQVideoTCell" bundle:nil] forCellReuseIdentifier:@"FQVideoTCell"];
    [self.view addSubview:_tableView];
    @weakify(self)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        if(@available(iOS 11.0, *)) {
            //方法一适配
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft); make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight); make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            
        }else{
            make.edges.equalTo(self.view);
            
        }
    }];
    
    //添加拍照按钮
    UIButton*postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setImage:[UIImage imageNamed:@"视频"] forState:UIControlStateNormal];
    [self.view addSubview:postButton];
    [postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@(CGSizeMake(35, 30)));
        make.right.mas_equalTo(-13);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(22);
        } else {
            make.top.equalTo(@(22));
        }
    }];
    [postButton addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    
    //添加分享视图
    
    [self.bottomView fq_hiden];
    
    ///添加评论视图
    
    [self.commentView fq_hiden];
    
    
}
-(void)post{
    [self routerEventWithName:fq_PostVedio dataInfo:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableView.bounds.size.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
  
    return self.dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FQVideoTCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQVideoTCell"];
    [cell updateContentWithModel:self.dataSource[indexPath.row]];
    if (indexPath.row == 0) {
        [cell playIndexpath:indexPath Table:tableView];
    }
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"shortPublic"]) {
        FQPostShortVideoVC *vc = segue.destinationViewController;
        @weakify(self)
        vc.complete = ^{
            @strongify(self)
            self.page = 1;
            [self getData];
        };
    }
    
    if ([segue.identifier isEqualToString:@"userInfo"]) {
        FQUserInfoVC*vc = segue.destinationViewController;
        FQVideoModel*model = [sender objectForKey:@"model"];
        vc.user_id = model.user_id;
        vc.hidesBottomBarWhenPushed = YES;
    }
    
}

-(void)routerEventWithName:(NSString *)eventName dataInfo:(NSDictionary *)dataInfo{
    if ([eventName isEqualToString:fq_PostVedio]) {
        if ([FQUserModel share].userid>0) {
            [self performSegueWithIdentifier:@"shortPublic" sender:nil];
        }else{
            [self.task fq_LoginFirst];
        }
    }
    
    if ([eventName isEqualToString:fq_share]) {
        [self.bottomView fq_show];
    }
    
    if ([eventName isEqualToString:fq_comment]) {
        FQVideoModel*model = dataInfo[@"model"];
        ///评论数量实时修改
        UIButton*commentButton = dataInfo[@"sender"];
        [self.commentView showWithModel:model];
        
    }
    
    if ([eventName isEqualToString:fq_UserInfo]) {
        [self performSegueWithIdentifier:@"userInfo" sender:dataInfo];
    }
}
@end
