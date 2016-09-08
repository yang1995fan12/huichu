//
//  HomeTableViewController.m
//  huichu
//
//  Created by 杨凡 on 16/8/25.
//  Copyright © 2016年 yf. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];

    [self data];
    
    
}

//请求数据
- (void)data {
    NSDictionary *dic = @{@"key":huichuAppKey};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"http://apicloud.mob.com/v1/cook/category/query" parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"----%@", dic);
        
        if ([dic[@"retCode"] integerValue] == 200) {
            NSLog(@"成功");
            
            NSDictionary *result = dic[@"result"];
            
            NSDictionary *categoryInfo = result[@"categoryInfo"];
            NSLog(@"cotegoryInfo---%@",categoryInfo);
            
            NSArray *childs = result[@"childs"];
            //NSLog(@"childs---%@",childs);
            
            for (int a = 0;a<childs.count;a++) {
                
                for (int i = 0;i<childs.count;i++) {
                NSDictionary *categoryInfo = childs[i][@"categoryInfo"];
                NSLog(@"categoryInfo%@",categoryInfo);
                NSArray *childsArr = childs[i][@"childs"];
                NSLog(@"childsArr%@",childsArr);
                
                    for (int f = 0;f<childsArr.count;f++) {
                    NSDictionary *categoryInfoDic = childsArr[f][@"categoryInfo"];
                    NSLog(@"categoryInfoDic%@",categoryInfoDic);
                }
            }
            
        }
    }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        switch (error.code) {
            case 10001: {
                NSLog(@"appKey不合法");
            }
                break;
            case 10020: {
                NSLog(@"接口维护");
            }
                break;
            case 10021: {
                NSLog(@"接口停用");
            }
                break;
            default: {
                NSLog(@"未知错误");
            }
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
