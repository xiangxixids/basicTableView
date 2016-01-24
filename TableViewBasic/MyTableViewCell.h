//
//  MyTableViewCell.h
//  TableViewBasic
//
//  Created by xixi.xxx on 16/1/20.
//  Copyright © 2016年 xixi.xxx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *hint;

@end
