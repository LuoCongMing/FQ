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
#import "CoreManager+Home.h"
#import <MJRefresh.h>


static NSString*FQDelateAllRecord = @"FQDelateAllRecord";
@interface FQSearchHeaderView:UIView

@end

@implementation FQSearchHeaderView
///删除
- (IBAction)delate:(id)sender {
    
    [self routerEventWithName:FQDelateAllRecord dataInfo:nil];
}


@end

@interface FQSearchViewController ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

///是否是搜索结果
@property (nonatomic,assign)BOOL searchResult;
@property (nonatomic,strong)NSMutableArray*dataSource;
@property (nonatomic,strong)NSMutableArray*searchRecordData;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)CoreManager*task;
@end

@implementation FQSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSource = [[NSMutableArray alloc]init];
    _searchRecordData= [[NSMutableArray alloc]init];
    [self initSearchData];
    [self tableViewSetting];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    _task = [[CoreManager alloc]init];
    
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
    
    _searchField.delegate = self;
    
    BizTextFieldDelegateHook*hook = _searchField.delegate;
    @weakify(self)
    hook.textfieldReturn = ^(NSString *text) {
        @strongify(self)
          [self searchWithText:text];
    };
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.page +=1 ;
        [self.task getCommunitysearchindexPage:self.page SearchString:self.searchField.text CompleteBlock:^(id success) {
            @strongify(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([success[@"page"] intValue]<=self.page) {
                    [self.tableView.mj_footer setHidden:YES];
                }else{
                    [self.tableView.mj_footer setHidden:NO];
                }
                self.searchResult = YES;
                [self.dataSource addObjectsFromArray:success[@"array"]];
                [self.tableView reloadData];
            });
        } FaildBlock:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer setHidden:YES];
            });
        }];
    }];
    
    [self.tableView.mj_footer setHidden:YES];
    
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
        return self.dataSource.count;
    }else{
        return self.searchRecordData.count;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_searchResult) {
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
                FQCommunityBaseCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQPctureTCell"];
                if (cell == nil) {
                    cell = [[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
                }
                [cell updatePictureContentWithModel:nil];
                return cell;
                
            }
                break;
                
            default:
                break;
        }
        
        return nil;
        
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
        FQSearchRecordModel*model = self.searchRecordData[indexPath.row];
        [self searchWithText:model.searchTitle];
    }
}



-(void)searchWithText:(NSString*)searchString{
    
    RLMResults*result = [FQSearchRecordModel objectsWhere:@"searchTitle == %@",searchString];
    if (result.count>0) {
        
    }else{
        FQSearchRecordModel*model = [[FQSearchRecordModel alloc]init];
        RLMRealm*realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        model.searchTitle = searchString;
        model.date = [NSDate date];
        [realm addObject:model];
        [realm commitWriteTransaction];
    }
    
    
    
    
     _page = 1;
    [self.dataSource removeAllObjects];
    ///网络请求
    @weakify(self)
    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [_task getCommunitysearchindexPage:self.page SearchString:searchString CompleteBlock:^(id success) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if ([success[@"page"] intValue]<=self.page) {
                [self.tableView.mj_footer setHidden:YES];
            }else{
                [self.tableView.mj_footer setHidden:NO];
            }
            self.searchResult = YES;
            [self.dataSource addObjectsFromArray:success[@"array"]];
            [self.tableView reloadData];
        });
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
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
