//
//  FQLiveViewController.m
//  Fanqie
//
//  Created by 周建波 on 2019/3/13.
//  Copyright © 2019 周建波. All rights reserved.
//

#import "FQLiveViewController.h"
#import <SDCycleScrollView.h>
#import <Masonry.h>
#import "FQLiveCell.h"
#import "FQLiveHeaderView.h"

@interface FQLiveViewController ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *recommondButton;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet UIView *indicationView;

@property (nonatomic,strong)UIButton*selectButton;

@property (nonatomic, strong)SDCycleScrollView *cycle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic,strong)UICollectionView*recommondCollection;

@property (nonatomic,strong)UICollectionView*attentionCollection;

@property (nonatomic,strong)FQLiveHeaderView*headerView;

@end

@implementation FQLiveViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

-(void)initUI{
    _selectButton = _recommondButton;
    _recommondButton.selected = YES;
    [_recommondButton setTitleColor:RedFontColor forState:UIControlStateSelected];
    [_recommondButton setTitleColor:RedFontColor forState:UIControlStateSelected];
    
   
  
    
    _recommondCollection = [self collectionViewWithFrame:_scrollView.bounds];
    [self.scrollView addSubview:_recommondCollection];
    _attentionCollection= [self collectionViewWithFrame:_scrollView.bounds];
    CGRect rect = _attentionCollection.frame;
    rect.origin.x = _scrollView.bounds.size.width;
    _attentionCollection.frame = rect;
    [self.scrollView addSubview:_attentionCollection];
    
    
    @weakify(self)
    [_recommondCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.height.equalTo(self.scrollView.mas_height);
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.scrollView.mas_left);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    [_attentionCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.height.equalTo(self.scrollView.mas_height);
        make.top.equalTo(self.scrollView.mas_top);
        make.left.equalTo(self.recommondCollection.mas_right);
        make.width.equalTo(self.scrollView.mas_width);
    }];
    
    _scrollView.scrollEnabled = NO;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*2, _scrollView.bounds.size.height);
    [_recommondCollection registerClass:[FQLiveHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    UICollectionViewFlowLayout*layout = (UICollectionViewFlowLayout*)_recommondCollection.collectionViewLayout;
    layout.headerReferenceSize = CGSizeMake(iPhone_Width-30, (iPhone_Width-30)/3.0);
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (collectionView == _recommondCollection) {
            FQLiveHeaderView*view = (FQLiveHeaderView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
           
            return view;
        }
    }
    
    return nil;
}

-(UICollectionView*)collectionViewWithFrame:(CGRect)frame{
    UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat padding = 7;
    CGFloat W = (iPhone_Width-30-7)/2.0;
    layout.itemSize = CGSizeMake(W, W);
    layout.minimumLineSpacing = padding;
    layout.minimumInteritemSpacing = padding;
    UICollectionView*collection = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    [collection registerNib:[UINib nibWithNibName:@"FQLiveCell" bundle:nil] forCellWithReuseIdentifier:@"FQLiveCell"];
    collection.backgroundColor = [UIColor whiteColor];
    return collection;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FQLiveCell" forIndexPath:indexPath];
    return cell;
}

/**
 tag  1 推荐
 tag  2 关注
 */
- (IBAction)buttonClick:(UIButton*)sender {
    _selectButton.selected = NO;
    sender.selected = YES;
    _selectButton = sender;
    CGPoint center = _indicationView.center;
    center.x = sender.center.x;
    _indicationView.center = center;
    
    switch (sender.tag) {
        case 1:
        {
            [self.scrollView setContentOffset:CGPointZero animated:YES];
        }
            break;
        case 2:
        {
            [self.scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0) animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)search:(id)sender {
    
    
}


@end
