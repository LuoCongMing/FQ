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

@interface FQMessageDetailController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
///距离顶部的距离，当消息内容是视频的时候需要调节
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopMagin;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FQMessageDetailController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableSetting];
    self.title = @"图文详情";
    
    
}
-(void)initTableSetting{
    FQMessageDetailTableHeadView*head = [[FQMessageDetailTableHeadView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, 200)];
//   CGFloat headerHeight = [head updateCharacterContentWithModel:nil];
    CGFloat headerHeight = [head updatePictureContentWithModel:nil];
    head.frame = CGRectMake(0, 0, iPhone_Width, headerHeight);
    self.tableView.tableHeaderView = head;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
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
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return 100;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
    
    return cell;
}

- (IBAction)message:(id)sender {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)emoji:(id)sender {
    
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
