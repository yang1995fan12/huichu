//
//  Utilities.m
//  huichu
//
//  Created by 杨凡 on 16/9/5.
//  Copyright © 2016年 yf. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

//提示错误小窗口
+ (void)judgeTel:(NSString *)Text view:(UIView *)view {
    
    // 声明一个 UILabel 对象
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/3, view.frame.size.height/3, 150, 70)];
    // 设置提示内容
    [tipLabel setText:Text];
    tipLabel.backgroundColor = [UIColor whiteColor];
    tipLabel.layer.cornerRadius = 5;
    tipLabel.layer.masksToBounds = YES;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor blackColor];
    [view addSubview:tipLabel];
    // 设置时间和动画效果
    [UIView animateWithDuration:2.0 animations:^{
        tipLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画完毕从父视图移除
        [tipLabel removeFromSuperview];
    }];
    
}
@end
