//
//  LoginViewController.m
//  huichu
//
//  Created by 杨凡 on 16/9/1.
//  Copyright © 2016年 yf. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeTableViewController.h"
#import "RegisteredViewController.h"
#import "ViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _Tel.delegate = self;
    _password.delegate = self;
    
    //默认获取 textfield 焦点
    [_Tel becomeFirstResponder];
    
    
}
//视图已经出现时调用
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//忘记密码
- (IBAction)forgetPwAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
//登录
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if (_Tel.text.length == 11 && [_password.text isEqual: @"yangfan"]) {
        UIStoryboard *identity = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        HomeTableViewController *HomeVC = [identity instantiateViewControllerWithIdentifier:@"HomeVC"];
        [self presentViewController:HomeVC animated:YES completion:nil];
    } else {
        [Utilities judgeTel:@"请输入正确的账号密码" view:self.view];
    }
    
//    //登录接口（暂时用不了）
//    NSDictionary *dic = @{@"username":_Tel.text,
//                          @"password":_password.text};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    [manager POST:LoginURL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
}
//直接进入
- (IBAction)skipAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    UIStoryboard *identity = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *viewVC = [identity instantiateViewControllerWithIdentifier:@"ViewVC"];
    [self presentViewController:viewVC animated:YES completion:nil];
    
}
//注册
- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    UIStoryboard *identity = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisteredViewController *RegisteredVC = [identity instantiateViewControllerWithIdentifier:@"RegisteredVC"];
    [self.navigationController pushViewController:RegisteredVC animated:YES];
}

#pragma mark 第三方登录
//QQ登录
- (IBAction)QQAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    //例如QQ的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"授权成功");
             NSLog(@"用户标识uid=%@",user.uid);//用户标识
             NSLog(@"授权凭证%@",user.credential);//授权凭证， 为nil则表示尚未授权
             NSLog(@"用户令牌token=%@",user.credential.token);//用户令牌
             NSLog(@"昵称nickname=%@",user.nickname);//昵称
             //跳转主页面
             UIStoryboard *identity = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
             ViewController *viewVC = [identity instantiateViewControllerWithIdentifier:@"ViewVC"];
             [self presentViewController:viewVC animated:YES completion:nil];
         }
         
         else
         {
             NSLog(@"授权失败");
             NSLog(@"%@",error);
         }
         
     }];
    
}
//微博登录
- (IBAction)weiboAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [SSEThirdPartyLoginHelper loginByPlatform:SSDKPlatformTypeSinaWeibo
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                       //原始数据
                                       NSLog(@"dd%@",user.rawData);
                                       
                                       //授权凭证， 为nil则表示尚未授权
                                       NSLog(@"dd%@",user.credential);
                                       //跳转主页面
                                       UIStoryboard *identity = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                       ViewController *viewVC = [identity instantiateViewControllerWithIdentifier:@"ViewVC"];
                                       [self presentViewController:viewVC animated:YES completion:nil];
                                       
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    
                                    if (state == SSDKResponseStateSuccess)
                                    {
                                        
                                    }
                                    
                                }];
}
//微信登录
- (IBAction)weixinAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
//支付宝登录
- (IBAction)zhifubaoAction:(UIButton *)sender forEvent:(UIEvent *)event {
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
