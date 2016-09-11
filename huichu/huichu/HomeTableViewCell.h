//
//  HomeTableViewCell.h
//  huichu
//
//  Created by 杨凡 on 16/9/10.
//  Copyright © 2016年 yf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *dishesView;//整个view

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;//菜的图片
@property (weak, nonatomic) IBOutlet UILabel *name;//菜的名字

@property (weak, nonatomic) IBOutlet UILabel *ctgTitles;//分类标签
@end
