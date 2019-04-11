//
//  FQUserInfoVC.m
//  Fanqie
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQUserInfoVC.h"
#import <ReactiveCocoa.h>
#import <MXSegmentedPager.h>
#import "FQUserInfoHeaderView.h"
#import "FQUserInfoBottomView.h"
#import "CoreManager+Video.h"
#import "FQCommunityBaseCell.h"
#import "FQUserInfoView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface FQUserInfoVC ()<MXSegmentedPagerDelegate,MXSegmentedPagerDataSource,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)MXSegmentedPager*segmentedPager;
@property (nonatomic,strong)FQUserInfoHeaderView*headerView;
@property (nonatomic,strong)UITableView*firstTable;
@property (nonatomic,strong)FQUserInfoView*secondTabel;
@property (nonatomic,strong)UIView*navigationBar;

@property (nonatomic,strong)UIButton*moreButton;
@property (nonatomic,strong)UIButton*backButton;
@property (nonatomic,strong)UIButton*modifyButton;

@property (nonatomic,strong)FQUserInfoBottomView*bottomView;
@property (nonatomic,strong)CoreManager*task;

@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,assign)int page;
@end

@implementation FQUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
    [self initTableView];
    [self bind];
    [self initData];
}
-(void)initData{
    _dataSource = [[NSMutableArray alloc]init];
    _page = 1;
    _task = [[CoreManager alloc]init];
    
    @weakify(self)
    [_task fq_SeeUser_info:self.user_id CompleteBlock:^(id success) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            FQUserInfoModel*model = success;
            [self.secondTabel updatecontentWithModel:success];
            [self.headerView updateContentWithModel:model];
        });
    } FaildBlock:^(id error) {
        
    }];
    
    [_task fq_SeeUser_dyanmic:self.user_id CompleteBlock:^(id success) {
        @strongify(self)

        [self.dataSource addObjectsFromArray:success[@"array"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.firstTable reloadData];
        });
    } FaildBlock:^(id error) {

    }];
}
-(void)initTableView{
    CGFloat H = iPhone_Height - self.segmentedPager.parallaxHeader.minimumHeight;
    CGRect frame = CGRectMake(0, 0, iPhone_Width, H);
    _firstTable = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    _firstTable.delegate = self;
    _firstTable.dataSource = self;
    _firstTable.frame = frame;
    _firstTable.estimatedRowHeight = 150;
    _firstTable.emptyDataSetSource = self;
    _firstTable.emptyDataSetDelegate = self;
    _firstTable.rowHeight = UITableViewAutomaticDimension;
    _firstTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_firstTable registerNib:[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] forCellReuseIdentifier:@"FQCharacterTCell"];
    [_firstTable registerNib:[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] forCellReuseIdentifier:@"FQPctureTCell"];
    [_firstTable registerNib:[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] forCellReuseIdentifier:@"FQVedioCell"];
    
    
    _secondTabel = [[UINib nibWithNibName:@"FQUserInfoView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    _secondTabel.frame = CGRectMake(0, 0, iPhone_Width, H);
    
}

-(FQUserInfoBottomView*)bottomView{
    if (_bottomView == nil) {
        
        _bottomView = [[UINib nibWithNibName:@"FQUserInfoBottomView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
        _bottomView.frame = CGRectMake(0, 0, iPhone_Width,iPhone_Height);
        
        [[UIApplication sharedApplication].keyWindow addSubview:_bottomView];
        
    }
    
    return _bottomView;
}
-(FQUserInfoHeaderView*)headerView{
    if (_headerView == nil) {
        _headerView = [[UINib nibWithNibName:@"FQUserInfoHeaderView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
        _headerView.frame = CGRectMake(0, 0, iPhone_Width, 311);
        _modifyButton = _headerView.modifyButton;
    }
    return _headerView;
}
-(void)setUI{
    // 头部
    self.segmentedPager = [[MXSegmentedPager alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.segmentedPager.parallaxHeader.view = self.headerView; // 注意这里加载平行头部
    // MXParallaxHeaderModeCenter MXParallaxHeaderModeCenter MXParallaxHeaderModeTop  MXParallaxHeaderModeBottom四个，大家可以自己测试
    self.segmentedPager.parallaxHeader.mode = MXParallaxHeaderModeBottom; // 平行头部填充模式
    self.segmentedPager.parallaxHeader.height = 311; // 头部高度
     // 头部最小高度
    if (@available(iOS 11.0, *)) {
        CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        if(a){
            self.segmentedPager.parallaxHeader.minimumHeight = 88;
        }else{
            self.segmentedPager.parallaxHeader.minimumHeight = 64;
        }
    } else {
         self.segmentedPager.parallaxHeader.minimumHeight = 64;
    }
    
    // 选择栏控制器属性
    self.segmentedPager.segmentedControl.borderWidth = 1.0; // 边框宽度
    self.segmentedPager.segmentedControl.borderColor = [UIColor redColor]; // 边框颜色
    self.segmentedPager.segmentedControl.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44); // frame
    self.segmentedPager.segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);// 间距
    self.segmentedPager.segmentedControl.selectionIndicatorHeight = 2;// 底部是否需要横条指示器，0的话就没有了，如图所示
    self.segmentedPager.segmentedControl.selectionIndicatorColor = [UIColor redColor];
    // 底部指示器的宽度是否根据内容
    self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //HMSegmentedControlSelectionIndicatorLocationNone 不需要底部滑动指示器
    self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedPager.segmentedControl.verticalDividerEnabled = NO;// 不可以垂直滚动
    // fix的枚举说明宽度是适应屏幕的，不会根据字体   HMSegmentedControlSegmentWidthStyleDynamic则是字体多大就多宽
    self.segmentedPager.segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    
    // 默认状态的字体
    self.segmentedPager.segmentedControl.titleTextAttributes =
    @{NSForegroundColorAttributeName : UIColorFromRGB(0x969696),
      NSFontAttributeName : [UIFont systemFontOfSize:16]};
    // 选择状态下的字体
    self.segmentedPager.segmentedControl.selectedTitleTextAttributes =
    @{NSForegroundColorAttributeName : UIColorFromRGB(0xff5252),
      NSFontAttributeName : [UIFont systemFontOfSize:16]};
    self.segmentedPager.segmentedControlEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.segmentedPager.delegate = self;
    self.segmentedPager.dataSource = self;
    [self.view addSubview:self.segmentedPager];
    [self.segmentedPager mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(self.view.mas_top).with.offset(0);
         make.left.equalTo(self.view.mas_left);
         make.bottom.equalTo(self.view.mas_bottom);
         make.right.equalTo(self.view.mas_right);
         make.width.equalTo(self.view.mas_width);
     }];
    
    
    [self.view addSubview:self.navigationBar];
    
    [self.bottomView fq_hiden];
}

-(UIView*)navigationBar{
    if (_navigationBar == nil) {
        _navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, self.segmentedPager.parallaxHeader.minimumHeight)];
        _navigationBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"zuo 拷贝"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(0, self.segmentedPager.parallaxHeader.minimumHeight-44, 44, 44);
        [_backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar addSubview:_backButton];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setImage:[UIImage imageNamed:@"三个点 拷贝"] forState:UIControlStateNormal];
        _moreButton.frame = CGRectMake(iPhone_Width-44, self.segmentedPager.parallaxHeader.minimumHeight-44, 44, 44);
        [_moreButton addTarget:self action:@selector(showMoreButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_navigationBar addSubview:_moreButton];
    }
    return _navigationBar;
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showMoreButtonClick{
    [self.bottomView fq_show];
}
-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary*attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0x969696),NSFontAttributeName:PingFangSC(15)};
    NSAttributedString*title = [[NSAttributedString alloc]initWithString:@"快评论吧，万一火了呢" attributes:attribute];
    return title;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FQCommunityIndexModel*model = self.dataSource[indexPath.row];
    switch (model.type) {
        case 1:
        {
            ///文字
            FQCommunityBaseCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQCharacterTCell"];
            if (cell == nil) {
                cell = [[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            [cell updateCharacterContentWithModel:model];
            
            return cell;
            
        }
            break;
        case 2:
        {
            ///图片
            FQCommunityBaseCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQPctureTCell"];
            if (cell == nil) {
                cell = [[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            [cell updatePictureContentWithModel:model];
            return cell;
        }
            break;
        case 3:
        {
            ///视频
            FQCommunityBaseCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQVedioCell"];
            if (cell == nil) {
                cell = [[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            [cell updateVedioContentWithModel:model];
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    return nil;
}

#pragma -mark <MXSegmentedPagerDelegate>

- (CGFloat)heightForSegmentedControlInSegmentedPager:(MXSegmentedPager *)segmentedPager
{
    // 指示栏的高度
    return 44.0f;
}

#pragma -mark <MXSegmentedPagerDataSource>

- (NSInteger)numberOfPagesInSegmentedPager:(MXSegmentedPager *)segmentedPager
{
    // 需要多少个界面
    return 2;
}

- (NSString *)segmentedPager:(MXSegmentedPager *)segmentedPager titleForSectionAtIndex:(NSInteger)index
{
    // 指示栏的文字数组
    return [@[@"动态", @"档案"] objectAtIndex:index];
}

- (UIView *)segmentedPager:(MXSegmentedPager *)segmentedPager viewForPageAtIndex:(NSInteger)index
{
    // 第一个是控制器的View 第二个是WebView  第三个是自定义的View 这个也是最关键的，通过懒加载把对应控制的初始化View加载到框架上面去
    return [@[self.firstTable,self.secondTabel] objectAtIndex:index];
    
}

- (void)segmentedPager:(MXSegmentedPager *)segmentedPager didScrollWithParallaxHeader:(MXParallaxHeader *)parallaxHeader
{
    // 通过拿到滚动的对应的View
    UIScrollView *scrollView = (UIScrollView *)segmentedPager.subviews[0];
    NSLog(@"%lf",scrollView.contentOffset.y);
    CGFloat headAlpha = 0;
    
    if ((int)(-scrollView.contentOffset.y)==311) {
        headAlpha = 0;
    }else{
        if ((-scrollView.contentOffset.y)<=150) {
            headAlpha = 1;
        }else{
            headAlpha = (311+scrollView.contentOffset.y)/150.0;
        }
        
    }
    
    /// -311 0   -88/-64
//    // 计算alpha值
     self.navigationBar.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:headAlpha];
    if ((int)(-scrollView.contentOffset.y)==311) {
        [self.backButton setImage:[UIImage imageNamed:@"zuo 拷贝"] forState:UIControlStateNormal];
    }
    if ((-scrollView.contentOffset.y)<=150) {
        [self.backButton setImage:[UIImage imageNamed:@"返回黑"] forState:UIControlStateNormal];

    }
    
//    self.headView.alpha = 1 - headAlpha;
//    if (self.headView.alpha == 0)
//    {
//        self.navigationController.navigationBar.hidden = NO;
//    }
//    else
//    {
//        self.navigationController.navigationBar.hidden = YES;
//    }
}

-(void)bind{
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
