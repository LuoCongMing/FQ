//
//  FQSearchViewController.m
//  Fanqie
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQSearchViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "FQSearchRecordCell.h"
#import "FQSearchRecordModel.h"
#import <RLMRealm.h>
#import <RLMResults.h>
#import "FQCommunityBaseCell.h"
#import "FQUserCell.h"


static NSString*FQDelateAllRecord = @"FQDelateAllRecord";
@interface FQSearchHeaderView:UIView

@end

@implementation FQSearchHeaderView
///删除
- (IBAction)delate:(id)sender {
    
    [self routerEventWithName:FQDelateAllRecord dataInfo:nil];
}


@end

@interface FQSearchViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

///是否是搜索结果
@property (nonatomic,assign)BOOL searchResult;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,strong)NSMutableArray*searchRecordData;
@end

@implementation FQSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _search.delegate = self;
    _dataSource = [[NSMutableArray alloc]init];
    _searchRecordData= [[NSMutableArray alloc]init];
    [self initSearchData];
    [self tableViewSetting];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
-(void)tableViewSetting{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)initSearchData{
    RLMResults*results = [[FQSearchRecordModel allObjects]sortedResultsUsingKeyPath:@"date" ascending:YES];
    if (results.count>0) {
        for (FQSearchRecordModel*model in results) {
            [self.searchRecordData addObject:model];
        }
    }
    [self.tableView reloadData];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary*attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0x969696),NSFontAttributeName:PingFangSC(15)};
    NSAttributedString*title = [[NSAttributedString alloc]initWithString:@"暂无搜索记录" attributes:attribute];
    return title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_searchResult) {
        return 0;
    }
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_searchResult) {
        return nil;
    }
    UIView*head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width, 44)];
    FQSearchHeaderView*view = [[UINib nibWithNibName:@"FQSearchHeaderView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    view.frame= head.bounds;
    [head addSubview:view];

    return head;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_searchResult) {
        return 3;
    }else{
        return self.searchRecordData.count;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchResult) {
        if (indexPath.row%3==0) {
            FQCommunityBaseCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQCharacterTCell"];
            if (cell == nil) {
                cell = [[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            [cell updateCharacterContentWithModel:nil];
            
            return cell;
        }
        if (indexPath.row%3==1) {
            FQCommunityBaseCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQPctureTCell"];
            if (cell == nil) {
                cell = [[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            [cell updatePictureContentWithModel:nil];
            return cell;
        }
        
        if (indexPath.row%3==2) {
            FQUserCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQUserCell"];
            if (cell == nil) {
                cell = [[UINib nibWithNibName:@"FQUserCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            return cell;
        }
        
    }else{
        FQSearchRecordCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQSearchRecordCell"];
        if (cell == nil) {
            cell = [[UINib nibWithNibName:@"FQSearchRecordCell" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
            FQSearchRecordModel*model = self.searchRecordData[indexPath.row];
            cell.searchTitle.text = model.searchTitle;
            @weakify(self)
            [[cell.delateButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                @strongify(self)
                [self.searchRecordData removeObject:model];
                
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm]deleteObject:model];
                [[RLMRealm defaultRealm]commitWriteTransaction];
                [self.tableView reloadData];
            }];
            return cell;
        }
        
        
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchResult) {
        
    }else{
        _searchResult = YES;
        [self.tableView reloadData];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchWithText:searchBar.text];
    
    RLMResults*result = [FQSearchRecordModel objectsWhere:@"searchTitle == %@",searchBar.text];
    if (result.count>0) {
        return;
    }
    
    FQSearchRecordModel*model = [[FQSearchRecordModel alloc]init];
    RLMRealm*realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    model.searchTitle = searchBar.text;
    model.date = [NSDate date];
    [realm addObject:model];
    [realm commitWriteTransaction];
    
    [searchBar resignFirstResponder];
    
}

-(void)searchWithText:(NSString*)searchString{
    _searchResult = YES;
    [self.tableView reloadData];
}
-(void)routerEventWithName:(NSString *)eventName dataInfo:(NSDictionary *)dataInfo{
    if ([eventName isEqualToString:FQDelateAllRecord]) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [[RLMRealm defaultRealm]deleteObjects:self.searchRecordData];
        [[RLMRealm defaultRealm]commitWriteTransaction];
        [self.searchRecordData removeAllObjects];
        [self.tableView reloadData];
    }
}
@end
