//
//  RegisteredViewController.m
//  huichu
//
//  Created by 杨凡 on 16/9/1.
//  Copyright © 2016年 yf. All rights reserved.
//

#import "RegisteredViewController.h"
#import "HomeViewController.h"
#import "ViewController.h"

@interface RegisteredViewController ()<UITextFieldDelegate>
{
    NSInteger count;
}
@property (strong,nonnull) NSTimer *timer;

@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    _Tel.delegate = self;
    _validation.delegate = self;
    _password.delegate = self;
    
    count = 60;
    
    //默认获取 textfield 焦点
    [_Tel becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------
- (IBAction)obtainAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_Tel.text.length != 11) {
        //提示框
        [Utilities judgeTel:@"请输入11位的手机号" view:self.view];
        return;
    }
    //获取验证码(测试)
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_Tel.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [self setTime];
            NSLog(@"获取验证码成功");
        } else {
            NSLog(@"错误信息:%@",error);
        }
    }];
    
}

#pragma mark - Timer

- (void)setTime{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
}

- (void)changeTime{
    
    if (count > 0) {
        [_codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",count] forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = NO;
        count --;
    }else{
        [_codeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = YES;
    }
}

//提交短信验证码
-(void)SubmitVerificationCode:(void(^)(Boolean complete) )complete {
    
    [SMSSDK commitVerificationCode:_validation.text phoneNumber:_Tel.text zone:@"86" result:^(NSError *error) {
        
        if (!error) {
            complete(true);
            NSLog(@"验证成功");
            
        }
        else
        {
            complete(false);
            NSLog(@"错误信息：%@",error);
            
        }
    }];
    
}


- (IBAction)finishAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    [self SubmitVerificationCode:^(Boolean complete) {
        if (complete != true) {
            //提示框
            [Utilities judgeTel:@"验证码错误" view:self.view];
            return;
        } else {
            
            //跳转首页
            UIStoryboard *identity = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ViewController *viewVC = [identity instantiateViewControllerWithIdentifier:@"ViewVC"];
            [self presentViewController:viewVC animated:YES completion:nil];
            
            //请求参数（接口有问题，暂时用不了）
            NSDictionary *dic = @{@"username":_Tel.text,
                                  @"password":_password.text};
            //初始化Manager
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            //post请求
            [manager POST:logonURL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求成功，解析数据
                NSLog(@"%@",responseObject);
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",[error localizedDescription]);

                //提示框
                [Utilities judgeTel:@"注册失败" view:self.view];
            }];
        }
    }];
}

#pragma mark - TextField

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//当文本输入框中输入的内容变化是调用该方法，返回值为NO不允许调用
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
@end