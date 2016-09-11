//
//  HomeViewController.m
//  huichu
//
//  Created by 杨凡 on 16/9/9.
//  Copyright © 2016年 yf. All rights reserved.
//

#import "HomeViewController.h"
#import "JSDropDownMenu.h"
@interface HomeViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    
    NSMutableArray *abc;
    NSMutableArray *c;
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    abc = [NSMutableArray new];
    c = [NSMutableArray new];
    [self theMenuCategoryLabels];
    
    
}

#pragma mark 选择分类

//选择栏
- (void)choose {
    
    //NSArray *food = @[@"全部菜品", @"火锅", @"川菜", @"西餐", @"自助餐"];
    NSArray *travel = @[@"全部旅游", @"周边游", @"景点门票", @"国内游", @"境外游"];
    NSLog(@"-----------------------------------------------abc%@",abc);
    NSLog(@"------------ccc-----%@",c);
    
    [abc addObjectsFromArray:c];
    _data1 = [NSMutableArray arrayWithObjects:@{@"title":@"菜谱", @"data":abc}, @{@"title":@"旅游", @"data":travel}, nil];
    _data2 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"不限人数", @"单人餐", @"双人餐", @"3~4人餐", nil];
    
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 65) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 3;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    if (column==2) {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==0) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==0) {
        return 0.3;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column==0) {
        
        return _currentData1Index;
        
    }
    if (column==1) {
        
        return _currentData2Index;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==0) {
        if (leftOrRight==0) {
            
            return _data1.count;
        } else{
            
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1){
        
        return _data2.count;
        
    } else if (column==2){
        
        return _data3.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 0: return [[_data1[0] objectForKey:@"data"] objectAtIndex:0];
            break;
        case 1: return _data2[0];
            break;
        case 2: return _data3[0];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
        
    } else {
        
        return _data3[indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if(indexPath.leftOrRight==0){
            
            _currentData1Index = indexPath.row;
            
            return;
        }
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}

#pragma mark 数据请求

//请求菜谱分类标签数据
- (void)theMenuCategoryLabels {
    
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
            NSString * a = [categoryInfo objectForKey:@"name"];
            [abc addObject:a];
            
            NSArray *childs = result[@"childs"];
            
            NSDictionary *sdgs = [NSDictionary new];
            NSString *ccc;
            for (int a = 0;a<childs.count;a++) {
                sdgs = childs[a][@"categoryInfo"];
                ccc = sdgs[@"name"];
                [c addObject:ccc];
                for (int i = 0;i<childs.count;i++) {

                    NSArray *childsArr = childs[i][@"childs"];
                    //NSLog(@"childsArr%@",childsArr);
                    
                    for (int f = 0;f<childsArr.count;f++) {
                        NSDictionary *categoryInfoDic = childsArr[f][@"categoryInfo"];
                        //NSLog(@"categoryInfoDic%@",categoryInfoDic);
                        
                        
                    }
                    
                }
                
            }
            
        }
        
        [self choose];
        
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
//按标签查询菜谱数据
- (void)labelQueryRecipes {
    
}
//菜谱查询数据
- (void)theMenuQuery {
    
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
