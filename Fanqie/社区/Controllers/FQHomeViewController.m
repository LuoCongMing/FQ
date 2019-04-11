//
//  FQHomeViewController.m
//  Fanqie
//
//  Created by 周建波 on 2019/3/13.
//  Copyright © 2019 周建波. All rights reserved.
//



#import "FQHomeViewController.h"
#import "FQHomeContentView.h"
#import "FQPublishVC.h"
#import "FQMessageDetailController.h"
#import "FQVideoPlayerVC.h"
#import "FQUserInfoVC.h"


@interface FQHomeViewController ()

@property(nonatomic,strong)UIButton*selectButton;
@property (weak, nonatomic) IBOutlet UIView *headerSeachView;


@property (weak, nonatomic) IBOutlet UIButton *recommend;
//关注
@property (weak, nonatomic) IBOutlet UIButton *attention;

//指示
@property (weak, nonatomic) IBOutlet UIView *indicationView;
//当前类型
@property (nonatomic,assign) FQHomeType type;
//
@property (weak, nonatomic) IBOutlet FQHomeContentView *contentView;

@property (nonatomic,strong)CoreManager*task;



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
    [self.contentView initData];
    
}

-(void)initUI{
    _selectButton = _recommend;
    _recommend.selected = YES;
    [_recommend setTitleColor:RedFontColor forState:UIControlStateSelected];
    [_attention setTitleColor:RedFontColor forState:UIControlStateSelected];
    
//    UISearchBar *searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, iPhone_Width-44, 44)];
//    searchbar.barStyle = UISearchBarStyleMinimal;
//    [_headerSeachView addSubview:searchbar];
    
    
    UIButton*postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    postButton.frame = CGRectMake(iPhone_Width-44, 0, 44, 44);
    [postButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    @weakify(self)
    [[postButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self)
        if ([FQUserModel share].user_token.length>0) {
            [self performSegueWithIdentifier:@"post" sender:nil];
        }else{
            [self.task fq_LoginFirst];
        }
        
    }];
    [_headerSeachView addSubview:postButton];
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
    if ([eventName isEqualToString:fq_allCharacter]||[eventName isEqualToString:fq_commentDetail]) {
        //跳转到消息详情页面
        [self performSegueWithIdentifier:@"messageDetail" sender:dataInfo];
    }
    
    if ([eventName isEqualToString:fq_photoBrowser]) {
        UIViewController*browser = dataInfo[@"vc"];
        // Present
        [self.navigationController pushViewController:browser animated:YES];
    }
    
    if ([eventName isEqualToString:fq_vedioPlay]) {
        FQVideoPlayerVC*player = [[FQVideoPlayerVC alloc]init];
        player.url = dataInfo[@"url"];
        [self presentViewController:player animated:YES completion:nil];
    }
    if ([eventName isEqualToString:fq_ShowUserInfo]) {
        FQUserInfoVC*vc = [[UIStoryboard storyboardWithName:@"FQVideo" bundle:nil]instantiateViewControllerWithIdentifier:@"userInfo"];
        vc.hidesBottomBarWhenPushed = YES;
        FQCommunityIndexModel*model = dataInfo[@"model"];
        vc.user_id = model.user_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)search:(id)sender {
    
    [self performSegueWithIdentifier:@"search" sender:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"post"]) {
        FQPublishVC*public = segue.destinationViewController;
        public.pulicComplete = ^{
            [self.contentView.recommandTable.mj_header beginRefreshing];
        };
    }
    
    if ([segue.identifier isEqualToString:@"messageDetail"]) {
        FQMessageDetailController*detail = segue.destinationViewController;
        detail.model = [sender objectForKey:@"model"];
//        @weakify(self)
        detail.backBlock = ^{
//          @strongify(self)
            UITableView*table = [sender objectForKey:@"table"];
            NSInteger index = [[sender objectForKey:@"index"] integerValue];
            [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
    }
    
    
    

}

@end
