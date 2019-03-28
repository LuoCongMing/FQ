//
//  FQHomeViewController.m
//  Fanqie
//
//  Created by 周建波 on 2019/3/13.
//  Copyright © 2019 周建波. All rights reserved.
//



#import "FQHomeViewController.h"
#import "FQHomeContentView.h"

@interface FQHomeViewController ()
@property(nonatomic,strong)UIButton*selectButton;
@property (weak, nonatomic) IBOutlet UIButton *recommend;
//关注
@property (weak, nonatomic) IBOutlet UIButton *attention;

//指示
@property (weak, nonatomic) IBOutlet UIView *indicationView;
//当前类型
@property (nonatomic,assign) FQHomeType type;
//
@property (weak, nonatomic) IBOutlet FQHomeContentView *contentView;


@end

@implementation FQHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self initData];
}
-(void)initData{
    _type = FQHomeTypeRecommend;
    
}
-(void)initUI{
    _selectButton = _recommend;
    _recommend.selected = YES;
    [_recommend setTitleColor:RedFontColor forState:UIControlStateSelected];
    [_attention setTitleColor:RedFontColor forState:UIControlStateSelected];

    
}

///发布内容
- (IBAction)publish:(id)sender {
    
    
    
}

- (IBAction)headButtonTypeClick:(UIButton*)sender {
    _selectButton.selected = NO;
    sender.selected = YES;
    _selectButton = sender;
    
    CGPoint indicationCenter = _indicationView.center;
    indicationCenter.x = sender.center.x;
    _indicationView.center = indicationCenter;
    
    _type = sender.tag;
    switch (_type) {
        case FQHomeTypeRecommend:
        {
            [_contentView.scrollView setContentOffset:CGPointZero animated:YES];
        }
            break;
            case FQHomeTypeAttention:
        {
            [_contentView.scrollView setContentOffset:CGPointMake(iPhone_Width, 0) animated:YES];
        }
            break;
        default:
            break;
    }
}


-(void)routerEventWithName:(NSString *)eventName dataInfo:(NSDictionary *)dataInfo{
    if ([eventName isEqualToString:fq_allCharacter]) {
        //跳转到消息详情页面
        [self performSegueWithIdentifier:@"messageDetail" sender:nil];
    }
    if ([eventName isEqualToString:fq_commentDetail]) {
        //跳转到消息评论页面
        [self performSegueWithIdentifier:@"messageDetail" sender:nil];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
}

@end
