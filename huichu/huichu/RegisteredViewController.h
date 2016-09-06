//
//  RegisteredViewController.h
//  huichu
//
//  Created by 杨凡 on 16/9/1.
//  Copyright © 2016年 yf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisteredViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *Tel;//手机号
@property (weak, nonatomic) IBOutlet UITextField *validation;//验证码
@property (weak, nonatomic) IBOutlet UITextField *password;//密码
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//获取验证码

- (IBAction)obtainAction:(UIButton *)sender forEvent:(UIEvent *)event;//获取验证码
- (IBAction)finishAction:(UIButton *)sender forEvent:(UIEvent *)event;//完成
@end
