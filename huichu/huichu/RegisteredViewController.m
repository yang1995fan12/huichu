//
//  RegisteredViewController.m
//  huichu
//
//  Created by 杨凡 on 16/9/1.
//  Copyright © 2016年 yf. All rights reserved.
//

#import "RegisteredViewController.h"
#import "HomeTableViewController.h"
//第三方短信头文件
#import <SMS_SDK/SMSSDK.h>
//SVP
#import <SVProgressHUD/SVProgressHUD.h>



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
        [self judgeTel:@"请输入11位的手机号"];
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


//提示错误小窗口
- (void)judgeTel:(NSString *)Text {
    
        // 声明一个 UILabel 对象
        UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, self.view.frame.size.height/3, 150, 70)];
        // 设置提示内容
        [tipLabel setText:Text];
        tipLabel.backgroundColor = [UIColor whiteColor];
        tipLabel.layer.cornerRadius = 5;
        tipLabel.layer.masksToBounds = YES;
        tipLabel.numberOfLines = 0;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.textColor = [UIColor blackColor];
        [self.view addSubview:tipLabel];
        // 设置时间和动画效果
        [UIView animateWithDuration:2.0 animations:^{
            tipLabel.alpha = 0.0;
        } completion:^(BOOL finished) {
            // 动画完毕从父视图移除
            [tipLabel removeFromSuperview];
        }];

}

- (IBAction)finishAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
    
    [self SubmitVerificationCode:^(Boolean complete) {
        if (complete != true) {
            [self judgeTel:@"验证码错误"];
            return;
        } else {
            //请求参数
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_Tel.text,_password.text, nil];
            //初始化Manager
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            //post请求
            [manager POST:@"http://localhost:8080/api/register" parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求成功，解析数据
                NSLog(@"%@",responseObject);
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
                NSLog(@"%@",dic);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",[error localizedDescription]);
            }];
        }
    }];
    
    UIStoryboard *identity = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HomeTableViewController *HomeVC = [identity instantiateViewControllerWithIdentifier:@"HomeVC"];
    [self presentViewController:HomeVC animated:YES completion:nil];

}
@end