//
//  FQMessageDetailController.m
//  Fanqie
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQMessageDetailController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "FQMessageDetailTableHeadView.h"
#import "FQMessageDetailCell.h"
#import "FQMessageDetailSectionHeader.h"
#import "CoreManager+Home.h"
#import <MJRefresh.h>
#import "BizTextFieldDelegateHook.h"
#import <SJVideoPlayer.h>

@interface FQMessageDetailController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITextFieldDelegate>
///距离顶部的距离，当消息内容是视频的时候需要调节
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopMagin;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,assign)int page;
///排序方式
@property (nonatomic,assign)int sort;
@property (nonatomic,strong)CoreManager*task;
@property (nonatomic,strong)SJVideoPlayer*player;
@end

@implementation FQMessageDetailController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.model.type ==3) {
        [self.navigationController.navigationBar setHidden:YES];
        _tableViewTopMagin.constant = iPhone_Width*0.57;
    }else{
        [self.navigationController.navigationBar setHidden:NO];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableSetting];
    self.title = @"图文详情";
    _task = [[CoreManager alloc]init];
    _dataSource = [[NSMutableArray alloc]init];
    _page = 1;
    _sort = 1;
    if (self.model.type == 3) {
        [self addPlayerView];
    }
    [self bind];
    [self initRefresh];
    [self getData];
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addPlayerView{
    
    _player = [SJVideoPlayer player];
//    _player.view.frame = _contentView.bounds;
//    _player.hideBottomProgressSlider = YES;
    _player.showResidentBackButton = YES;
    [self.view addSubview:_player.view];
    @weakify(self)
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
//        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.tableView.mas_top);
        make.left.mas_equalTo(self.tableView.mas_left);
        make.right.mas_equalTo(self.tableView.mas_right);
        make.height.mas_equalTo(@(iPhone_Width*0.57));
    }];
    // 初始化资源
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.model.videocontent]];
}
-(void)bind{
    _textField.delegate = self;
    BizTextFieldDelegateHook *hook = _textField.delegate;
    @weakify(self)
    hook.textfieldReturn = ^(NSString *text) {
        @strongify(self)
        ///发送
        MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.task fq_communityCommentPublicCommunity_id:self.model.id Commentcontent:text CompleteBlock:^(id success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                self.textField.text = @"";
                [self.tableView.mj_header beginRefreshing];
            });
        } FaildBlock:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }];
    };
    
}
-(void)initRefresh{
    @weakify(self)
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.page = 1;
        [self getCommentListWithPage:self.page Header:YES Footer:NO];
    }];
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
       @strongify(self)
        self.page+=1;
        [self getCommentListWithPage:self.page Header:NO Footer:YES];
    }];
    
    [self.tableView.mj_footer setHidden:YES];
}
-(void)getData{
    
//    [_task fq_communityCommentDetailID:self.model.id CompleteBlock:^(id success) {
//
//    } FaildBlock:^(id error) {
//
//    }];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_task fq_communityCommentListWithPage:self.page Community_id:self.model.id Sort:1 CompleteBlock:^(id success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [self.dataSource addObjectsFromArray:success[@"array"]];
            [self.tableView reloadData];
        });
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
    
}
-(void)getCommentListWithPage:(int)page Header:(BOOL)header Footer:(BOOL)footer{
    
    [_task fq_communityCommentListWithPage:page Community_id:self.model.id Sort:self.sort CompleteBlock:^(id success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (header) {
                [self.tableView.mj_header endRefreshing];
                [self.dataSource removeAllObjects];
            }
            if (footer) {
                [self.tableView.mj_footer endRefreshing];
            }
            
            
        });
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (header) {
                [self.tableView.mj_header endRefreshing];
            }
            if (footer) {
                [self.tableView.mj_footer endRefreshing];
            }
        });
    }];
    
}
-(void)initTableSetting{
    FQMessageDetailTableHeadView*head = [[FQMessageDetailTableHeadView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, 200)];
    
    CGFloat headerHeight = 0.0;
    switch (self.model.type) {
        case 1:
        {
             headerHeight = [head updateCharacterContentWithModel:self.model];

        }
            break;
        case 2:
        {
             headerHeight = [head updatePictureContentWithModel:self.model];
        }
            break;
        case 3:
        {
            headerHeight = [head updateVedioContentWithModel:self.model];
        }
            break;
            
        default:
            break;
    }
    
    head.frame = CGRectMake(0, 0, iPhone_Width, headerHeight);
    self.tableView.tableHeaderView = head;
    self.tableView.tableFooterView = [UIView new];
    ///header太高了位置不正确
//    self.tableView.emptyDataSetSource = self;
//    self.tableView.emptyDataSetDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary*attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0x969696),NSFontAttributeName:PingFangSC(15)};
    NSAttributedString*title = [[NSAttributedString alloc]initWithString:@"快评论吧，万一火了呢" attributes:attribute];
    return title;
}
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
//    return 100;
//}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*header= [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, 50)];
    [header addSubview:[[UINib nibWithNibName:@"FQMessageDetailSectionHeader" bundle:nil]instantiateWithOwner:nil options:nil].firstObject];
    return header;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FQMessageDetailCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQMessageDetailCell"];
    if (cell == nil) {
        cell  = [[UINib nibWithNibName:@"FQMessageDetailCell" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    }
    [cell updateContentWithModel:self.dataSource[indexPath.row]];
    return cell;
}

- (IBAction)message:(id)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)emoji:(id)sender {
    
}



@end
