//
//  FQRegistVC.m
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQRegistVC.h"
#import "NSString+TRHString.h"
#import <ReactiveCocoa.h>
#import "CoreManager+Login.h"

@interface FQRegistVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *configPswTextfield;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *verfiycodeButton;
@property (weak, nonatomic) IBOutlet UITextField *inviteCodeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong)CoreManager *task;

@end

@implementation FQRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bind];
    
    _task = [[CoreManager alloc]init];
}

-(void)bind{
    _phoneTextfield.delegate = self;
    _phoneTextfield.bizType = BizTextFieldTypeNum;
    _phoneTextfield.bizMaxLength = 11;
    
    _passwordTextfield.delegate = self;
    _passwordTextfield.bizType= BizTextFieldTypeWithoutCN;
    
    _configPswTextfield.delegate = self;
    _configPswTextfield.bizType = BizTextFieldTypeWithoutCN;
    
    _verifyCodeTextfield.delegate = self;
    _verifyCodeTextfield.bizType = BizTextFieldTypeNum;
    
    _inviteCodeTextfield.delegate = self;
    _inviteCodeTextfield.bizType = BizTextFieldTypeWithoutCN;
    
    RACSignal * verifyEnableSignal = [RACSignal combineLatest:@[self.phoneTextfield.rac_textSignal] reduce:^id(NSString*phone){
       
        return @([NSString adjustIfEqualToPhoneNumberWithString:phone]);
    }];
    
    @weakify(self)
    self.verfiycodeButton.rac_command = [[RACCommand alloc]initWithEnabled:verifyEnableSignal signalBlock:^RACSignal *(id input) {
       @strongify(self)
        //获取验证码
        [self.task FQgetRegistCodeWithCount:self.phoneTextfield.text Type:1 CompleteBlock:^(id success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createTimer];
            });
        } FaildBlock:nil];
        return [RACSignal empty];
    }];
    
    
    
    RACSignal * enableSignal = [RACSignal combineLatest:@[self.phoneTextfield.rac_textSignal,self.passwordTextfield.rac_textSignal,self.configPswTextfield.rac_textSignal,self.verifyCodeTextfield.rac_textSignal] reduce:^id(NSString*phone,NSString*psw,NSString*configPSW,NSString*verifyCode){
        @strongify(self)
        
        BOOL set = NO;
        
        set = [NSString adjustIfEqualToPhoneNumberWithString:phone]&&psw.length>=6&&[psw isEqualToString:configPSW]&&verifyCode.length>0;
        
        if (set){
            self.nextButton.backgroundColor = UIColorLoginButtonAble;
        }else{
            self.nextButton.backgroundColor = UIColorLoginButtonDisAble;
        }
        
        return @(set);
        
    }];
    
    RACCommand *command = [[RACCommand alloc]initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
       @strongify(self)
        
        ///注册
        [self.task FQRegistCodeWithUserName:self.phoneTextfield.text code:[self.verifyCodeTextfield.text intValue] Tusername:[self.inviteCodeTextfield.text intValue] Password:self.passwordTextfield.text Repeatpassword:self.configPswTextfield.text CompleteBlock:^(id success) {
            [self performSegueWithIdentifier:@"next" sender:nil];
        } FaildBlock:nil];
        
        return [RACSignal empty];
    }];
    
    self.nextButton.rac_command = command;
    
}

- (IBAction)cancel:(id)sender {
    
   [ self.navigationController popViewControllerAnimated:YES];
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
                
                self.verfiycodeButton.userInteractionEnabled = YES;
                [self.verfiycodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else {
            
            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                self.verfiycodeButton.userInteractionEnabled = NO;
                NSString * title = [NSString stringWithFormat:@"%d秒",timeout];
                [self.verfiycodeButton setTitle:title forState:UIControlStateNormal];
            });
        }
    });
    
    dispatch_resume(timer);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
