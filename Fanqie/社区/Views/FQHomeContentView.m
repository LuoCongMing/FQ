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

@end


@implementation FQHomeContentView
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initUI];
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
        return 6;
    }else{
        return 0;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _recommandTable) {
        if (indexPath.row%2==0) {
            FQCommunityBaseCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQCharacterTCell"];
            if (cell == nil) {
                cell = [[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            [cell updateCharacterContentWithModel:nil];
            
            return cell;
        }
        if (indexPath.row%2==1) {
            FQCommunityBaseCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FQPctureTCell"];
            if (cell == nil) {
                cell = [[UINib nibWithNibName:@"FQCommunityBaseCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
            }
            [cell updatePictureContentWithModel:nil];
            return cell;
        }
    }
    
    return nil;
}

@end
