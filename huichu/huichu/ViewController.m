//
//  ViewController.m
//  huichu
//
//  Created by 杨凡 on 16/8/25.
//  Copyright © 2016年 yf. All rights reserved.
//

#import "ViewController.h"
#import "LeftTableViewController.h"
#import "HomeTableViewController.h"

@interface ViewController (){
    float speed_f;
    int condition_f;
    LeftTableViewController *LeftView;
    UIViewController *HomeView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //滑动速率
    speed_f = 0.5;
    //条件：什么时候显示中间的View 什么时候显示左边的View
    condition_f = 0;
    
    LeftView = [[LeftTableViewController alloc]init];
    //将中间视图添加到导航上
    HomeTableViewController *rootController = [[HomeTableViewController alloc]init];
    HomeView = [[UINavigationController alloc]initWithRootViewController:rootController];
    rootController.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:LeftView.view];
    [self.view addSubview:HomeView.view];
    
    //将左边的视图隐藏
    LeftView.view.hidden = YES;
    
    //添加滑动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [HomeView.view addGestureRecognizer:pan];
    
}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    
    //获取手指的位置
    CGPoint point = [sender translationInView:sender.view];
    
    condition_f = point.x * speed_f + condition_f;
    
    if (sender.view.frame.origin.x >= 0) {
        sender.view.center = CGPointMake(sender.view.center.x + point.x * speed_f, sender.view.center.y);
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        LeftView.view.hidden = NO;
    }
    
    //当手指离开屏幕时
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (condition_f > self.view.frame.size.width * 0.5 * speed_f) {
            [self showLeftView];
        } else {
            [self showMainView];
        }
    }
}

- (void)showLeftView {
    
    [UIView beginAnimations:nil context:nil];
    
    HomeView.view.center = CGPointMake(self.view.frame.size.width * 1.5 - 60, self.view.frame.size.height/2);
    [UIView commitAnimations];
}

- (void)showMainView {
    [UIView beginAnimations:nil context:nil];
    
    HomeView.view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [UIView commitAnimations];
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
