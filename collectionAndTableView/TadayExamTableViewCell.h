//
//  TadayExamTableViewCell.h
//  ExaminationPower
//
//  Created by 纵索科技 on 16/9/24.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TadayExamTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIButton *selectBtn;
@property (strong, nonatomic)  UILabel *connentLabel;
@property (nonatomic,assign)BOOL isSelected;
-(void)UpdateCellWithState:(BOOL)select;

@end
