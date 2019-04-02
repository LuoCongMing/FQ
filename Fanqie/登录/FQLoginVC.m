//
//  FQLoginVC.m
//  Fanqie
//
//  Created by mac on 2019/4/2.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQLoginVC.h"
#import <ReactiveCocoa.h>
#import "NSString+TRHString.h"

@interface FQLoginVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *countLoginButton;

@end

@implementation FQLoginVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_countLoginButton setTitle:@"手机号登录" forState:UIControlStateSelected];
    
    _phoneTextfield.delegate = self;
    _phoneTextfield.bizType = BizTextFieldTypeNum;
    _phoneTextfield.bizMaxLength = 11;
    
    _passwordTextfield.delegate = self;
    _passwordTextfield.bizType = BizTextFieldTypeWithoutCN;
    
    [self bind];
    
    
}

-(void)bind{
    
    @weakify(self)
   RACSignal *enableSignal = [RACSignal combineLatest:@[self.phoneTextfield.rac_textSignal,self.passwordTextfield.rac_textSignal] reduce:^id(NSString*phone,NSString*psw){
        @strongify(self)
       
       BOOL set = NO;
        if(self.countLoginButton.selected){
            set = phone.length>0&&psw.length>=6;
        }else{
            if(phone.length>11){
                self.phoneTextfield.text = [phone substringFromIndex:11];
            }
            set = [NSString adjustIfEqualToPhoneNumberWithString:phone]&&psw.length>=6;
        }
       if (set){
           self.login.backgroundColor = UIColorLoginButtonAble;
       }else{
           self.login.backgroundColor = UIColorLoginButtonDisAble;

       }
       
       return @(set);
    }];
    self.login.rac_command = [[RACCommand alloc]initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        
        //login
        
        
        
        return [RACSignal empty];
    }];
    
    
}


- (IBAction)cancel:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)eyesClick:(UIButton*)sender {
    sender.selected = !sender.selected;
    _passwordTextfield.secureTextEntry = sender.selected;
}
- (IBAction)countLogin:(UIButton*)sender {
    sender.selected = !sender.selected;
    if(_countLoginButton.selected){
        _phoneTextfield.placeholder = @"请输入账号";
    }else{
        _phoneTextfield.placeholder = @"请输入手机号";
    }
    
}

- (IBAction)forgetPasswords:(id)sender {
    
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
