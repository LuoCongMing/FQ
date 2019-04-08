//
//  FQFindPSWVC.m
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQFindPSWVC.h"
#import <ReactiveCocoa.h>
#import "NSString+TRHString.h"
#import "CoreManager+Login.h"

@interface FQFindPSWVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (weak, nonatomic) IBOutlet UIView *firstStepView;


@property (weak, nonatomic) IBOutlet UITextField *pswTextfield;
@property (weak, nonatomic) IBOutlet UITextField *repeatPswTextfield;

@property (weak, nonatomic) IBOutlet UIView *nextStepView;

///
@property (weak, nonatomic) IBOutlet UIButton *configButton;

@property (nonatomic,strong)CoreManager*task;

@end

@implementation FQFindPSWVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_nextStepView setHidden:YES];
    _task = [[CoreManager alloc]init];
    [self bind];
}
-(void)bind{
    self.phoneTextfield.delegate = self;
    self.phoneTextfield.bizType = BizTextFieldTypeNum;
    self.phoneTextfield.bizMaxLength = 11;
    
    self.verifyCodeTextfield.delegate = self;
    self.verifyCodeTextfield.bizType = BizTextFieldTypeNum;
    
    self.pswTextfield.delegate = self;
    self.pswTextfield.bizType = BizTextFieldTypeWithoutCN;
    
    self.repeatPswTextfield.delegate = self;
    self.repeatPswTextfield.delegate = self;
    
    RACSignal * verifyEnableSignal = [RACSignal combineLatest:@[self.phoneTextfield.rac_textSignal] reduce:^id(NSString*phone){
        
        return @([NSString adjustIfEqualToPhoneNumberWithString:phone]);
    }];
    
    @weakify(self)
    self.verifyCodeButton.rac_command = [[RACCommand alloc]initWithEnabled:verifyEnableSignal signalBlock:^RACSignal *(id input) {
        @strongify(self)
        //获取验证码
        [self.task FQgetRegistCodeWithCount:self.phoneTextfield.text Type:2 CompleteBlock:^(id success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createTimer];
            });
        } FaildBlock:nil];
        return [RACSignal empty];
    }];
    
    
    RACSignal *nextSignal = [RACSignal combineLatest:@[_phoneTextfield.rac_textSignal,_verifyCodeTextfield.rac_textSignal] reduce:^id(NSString*phone,NSString*verifyCode){
        @strongify(self)
        BOOL set = [NSString adjustIfEqualToPhoneNumberWithString:phone]&&verifyCode.length>0;
        if (set){
            self.nextStepButton.backgroundColor = UIColorLoginButtonAble;
        }else{
            self.nextStepButton.backgroundColor = UIColorLoginButtonDisAble;
        }
        return @(set);
    }];
    
    self.nextStepButton.rac_command = [[RACCommand alloc]initWithEnabled:nextSignal signalBlock:^RACSignal *(id input) {
        @strongify(self)
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.firstStepView setHidden:YES];
            [self.nextStepView setHidden:NO];
        });
        
        return [RACSignal empty];
    }];
    
    RACSignal * configSignal = [RACSignal combineLatest:@[_pswTextfield.rac_textSignal,_repeatPswTextfield.rac_textSignal] reduce:^id(NSString*psw,NSString*repsw){
        @strongify(self)
        BOOL set = psw.length>0&&[psw isEqualToString:repsw];
        if (set){
            self.configButton.backgroundColor = UIColorLoginButtonAble;
        }else{
            self.configButton.backgroundColor = UIColorLoginButtonDisAble;
        }
        return @(set);
    }];
    
    self.configButton.rac_command = [[RACCommand alloc]initWithEnabled:configSignal signalBlock:^RACSignal *(id input) {
       //
        @strongify(self)
        MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.task fq_FindPswWithPhone:self.phoneTextfield.text Code:self.verifyCodeTextfield.text Password:self.pswTextfield.text RepeatPassword:self.repeatPswTextfield.text CompleteBlock:^(id success) {
            hud.detailsLabel.text = @"修改成功";
            dispatch_after(1.0, dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
            
        } FaildBlock:^(id error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }];
        
        return [RACSignal empty];
        
    }];
    
    
}

//倒计时
#pragma mark - 定时器 (GCD)
- (void)createTimer {
    
    
    __block int timeout = 91;
    
    
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    @weakify(self)
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        @strongify(self)
        timeout --;
        
        if (timeout <= 0) {
            
            //停止倒计时，button打开交互，背景颜色还原，title还原
            
            //关闭定时器
            dispatch_source_cancel(timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                
                self.verifyCodeButton.userInteractionEnabled = YES;
                [self.verifyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else {
            
            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                self.verifyCodeButton.userInteractionEnabled = NO;
                NSString * title = [NSString stringWithFormat:@"%d秒",timeout];
                [self.verifyCodeButton setTitle:title forState:UIControlStateNormal];
            });
        }
    });
    
    dispatch_resume(timer);
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
