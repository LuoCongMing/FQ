//
//  FQHomeContentView.m
//  Fanqie
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQHomeContentView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface FQHomeContentView()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)CoreManager*task;
@property (nonatomic,assign)int recommendPage;
@property (nonatomic,assign)int attentionPage;
@property (nonatomic,strong)NSMutableArray*recommendArray;
@property (nonatomic,strong)NSMutableArray*attentionArray;
@end


@implementation FQHomeContentView
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initUI];
}
-(void)initMJRefresh{
    @weakify(self)
    self.recommandTable.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.recommendPage = 1;
        [self getcommunityIndexWithheader:YES footer:NO];
    }];
    
    self.recommandTable.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.recommendPage +=1;
        [self getcommunityIndexWithheader:NO footer:YES];
    }];
    
    self.attentionTable.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.attentionPage = 1;
        [self getAttentionListWithHeader:YES Footer:NO];
    }];
    
    self.attentionTable.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        @strongify(self)
        self.attentionPage +=1;
        [self getAttentionListWithHeader:NO Footer:YES];
    }];
    
    [self.recommandTable.mj_footer setHidden:YES];
    [self.attentionTable.mj_footer setHidden:YES];
    
}
-(void)initData{
    [self initMJRefresh];
    _task = [[CoreManager alloc]init];
    _recommendPage = 1;
    _attentionPage = 1;
    _recommendArray = [[NSMutableArray alloc]init];
    _attentionArray = [[NSMutableArray alloc]init];
    
    @weakify(self)
    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [_task getCommunityindexPage:_recommendPage CompleteBlock:^(id success) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if ([success[@"page"] intValue]==1) {
                [self.recommandTable.mj_footer setHidden:YES];
            }else{
                [self.recommandTable.mj_footer setHidden:NO];
            }
            [self.recommendArray addObjectsFromArray:success[@"array"]];
            [self.recommandTable reloadData];
        });
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [self.recommandTable.mj_footer setHidden:YES];
        });
    }];
    
    [_task fq_myfollowlcommunityistPage:_attentionPage CompleteBlock:^(id success) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if ([success[@"page"] intValue]==1) {
                [self.attentionTable.mj_footer setHidden:YES];
            }else{
                [self.attentionTable.mj_footer setHidden:NO];
            }
            [self.attentionArray addObjectsFromArray:success[@"array"]];
            [self.attentionTable reloadData];
        });
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [self.attentionTable.mj_footer setHidden:YES];
        });
    }];
}

///获取推荐列表
-(void)getcommunityIndexWithheader:(BOOL)header footer:(BOOL)footer{
    @weakify(self)
    [_task getCommunityindexPage:_recommendPage CompleteBlock:^(id success) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([success[@"page"] intValue]<=self.recommendPage) {
                [self.recommandTable.mj_footer setHidden:YES];
            }else{
                [self.recommandTable.mj_footer setHidden:NO];
            }
            if (header) {
                [self.recommendArray removeAllObjects];
                [self.recommandTable.mj_header endRefreshing];
            }else{
                [self.recommandTable.mj_footer endRefreshing];
            }
            [self.recommendArray addObjectsFromArray:success[@"array"]];
            [self.recommandTable reloadData];
        });
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recommandTable.mj_footer setHidden:YES];
            if (header) {
                
                [self.recommandTable.mj_header endRefreshing];
            }else{
                [self.recommandTable.mj_footer endRefreshing];
            }
        });
    }];
}
#pragma mark 关注列表
-(void)getAttentionListWithHeader:(BOOL)header Footer:(BOOL)footer{
    @weakify(self)
    [_task fq_myfollowlcommunityistPage:self.attentionPage CompleteBlock:^(id success) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([success[@"page"] intValue]<=self.recommendPage) {
                [self.attentionTable.mj_footer setHidden:YES];
            }else{
                [self.attentionTable.mj_footer setHidden:NO];
            }
            if (header) {
                [self.attentionArray removeAllObjects];
                [self.attentionTable.mj_header endRefreshing];
            }else{
                [self.attentionTable.mj_footer endRefreshing];
            }
            [self.recommendArray addObjectsFromArray:success[@"array"]];
            [self.recommandTable reloadData];
        });
        
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.recommandTable.mj_footer setHidden:YES];
            if (header) {
                
                [self.attentionTable.mj_header endRefreshing];
            }else{
                [self.attentionTable.mj_footer endRefreshing];
            }
        });
    }];
}
-(void)initUI{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(iPhone_Width*2, self.bounds.size.height);
    _scrollView.contentOffset = CGPointZero;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    
    [_scrollView addSubview:self.recommandTable];
    [_scrollView addSubview:self.attentionTable];
}
-(UITableView*)recommandTable{
    if (_recommandTable == nil) {
        _recommandTable = [self tableWithFrame:_scrollView.bounds];
//        _recommandTable.emptyDataSetSource = self;
//        _recommandTable.emptyDataSetDelegate = self;
        _recommandTable.tableFooterView = [UIView new];
    }
    return _recommandTable;
}
-(UITableView*)attentionTable{
    if (_attentionTable == nil) {
        CGRect rect = _scrollView.bounds;
        rect.origin.x = _scrollView.bounds.size.width;
        _attentionTable = [self tableWithFrame:rect];
        _attentionTable.emptyDataSetSource = self;
        _attentionTable.emptyDataSetDelegate = self;
        _attentionTable.tableFooterView = [UIView new];
    }
    return _attentionTable;
}
-(UIImage*)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"图层 2"];
}
-(NSAttributedString*)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary*attribute = @{NSForegroundColorAttributeName:UIColorFromRGB(0x969696),NSFontAttributeName:PingFangSC(15)};
    NSAttributedString*title = [[NSAttributedString alloc]initWithString:@"你还没有关注\n快去关注" attributes:attribute];
    return title;
}

-(UITableView*)tableWithFrame:(CGRect)frame{
    UITableView*table = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.frame = frame;
    table.estimatedRowHeight = 150;
    table.rowHeight = UITableViewAutomaticDimension;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    return table;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _recommandTable) {
        return self.recommendArray.count;
    }else{
        return self.attentionArray.count;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FQCommunityIndexModel*model;
    if (tableView == _recommandTable) {
        model = self.recommendArray[indexPath.row];
    }else{
        model = self.attentionArray[indexPath.row];
    }
    
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
}

@end
