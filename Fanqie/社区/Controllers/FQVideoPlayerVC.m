//
//  FQVideoPlayerVC.m
//  Fanqie
//
//  Created by mac on 2019/4/8.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQVideoPlayerVC.h"
#import <SJVideoPlayer.h>
#import "FQPlayerBottomView.h"

@interface FQVideoPlayerVC ()
@property (nonatomic,strong)SJVideoPlayer*player;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong)FQPlayerBottomView*bottomView;
@end

@implementation FQVideoPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view from its nib.
    _player = [SJVideoPlayer player];
    _player.view.frame = _contentView.bounds;
//    _player.hideBottomProgressSlider = YES;
    [self.view addSubview:_player.view];
    @weakify(self)
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    // 初始化资源
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.url]];
    
    
    UIButton*more = [UIButton buttonWithType:UIButtonTypeCustom];
    more.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-49, 0, 49, 49);
    [more setImage:[UIImage imageNamed:@"三个点 拷贝"] forState:UIControlStateNormal];
    [more addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    [_player.defaultEdgeControlLayer.topContainerView addSubview:more];
    

}

-(FQPlayerBottomView*)bottomView{
    if (_bottomView == nil) {
        
        _bottomView = [[UINib nibWithNibName:@"FQPlayerBottomView" bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
        _bottomView.frame = CGRectMake(0, iPhone_Height-175, iPhone_Width, 175);
        [_bottomView setHidden:YES];
        [self.view addSubview:_bottomView];
    }
    
    return _bottomView;
}
-(void)more{
    
    [self.bottomView setHidden:NO];
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
