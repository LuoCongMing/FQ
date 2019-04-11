//
//  FQLiveDetailVC.m
//  Fanqie
//
//  Created by mac on 2019/3/27.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQLiveDetailVC.h"
#import <SJVideoPlayer.h>

@interface FQLiveDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic,strong)SJVideoPlayer*player;

@end

@implementation FQLiveDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _player = [SJVideoPlayer player];
    _player.view.frame = _playerView.bounds;
    //    _player.hideBottomProgressSlider = YES;
    [self.view addSubview:_player.view];
    @weakify(self)
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self.playerView);
    }];
    // 初始化资源
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:self.model.url]];
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
