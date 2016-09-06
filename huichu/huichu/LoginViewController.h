//
//  LoginViewController.h
//  huichu
//
//  Created by 杨凡 on 16/9/1.
//  Copyright © 2016年 yf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Tel;//手机号
@property (weak, nonatomic) IBOutlet UITextField *password;//密码

- (IBAction)forgetPwAction:(UIButton *)sender forEvent:(UIEvent *)event;//忘记密码
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;//登录
- (IBAction)skipAction:(UIButton *)sender forEvent:(UIEvent *)event;//直接进入
- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event;//注册新账号

- (IBAction)QQAction:(UIButton *)sender forEvent:(UIEvent *)event;//QQ登录
- (IBAction)weiboAction:(UIButton *)sender forEvent:(UIEvent *)event;//微博登录
- (IBAction)weixinAction:(UIButton *)sender forEvent:(UIEvent *)event;//微信登录
- (IBAction)zhifubaoAction:(UIButton *)sender forEvent:(UIEvent *)event;//支付宝登录

@end
