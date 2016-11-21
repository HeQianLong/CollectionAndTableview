//
//  MulChooseTable.h
//  ExaminationPower
//
//  Created by 纵索科技 on 16/9/28.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^ChooseBlock) (NSString *chooseContent,NSMutableArray *chooseArr);


//typedef void (^chooseMyBlock)(NSString *chooseCount,NSMutableArray *chooseArr);

typedef void (^tableChooseBlock)(NSString *titleStr,NSMutableArray *chooseArray);

typedef void(^sureBlock)();

@interface MulChooseTable : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * MyMulTable;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)NSMutableArray * choosedArr;
@property(nonatomic,strong)tableChooseBlock tableChooseBlock;
@property (nonatomic,assign)BOOL ifAllSelected;
@property (nonatomic,assign)BOOL ifAllSelecteSwitch;

@property(nonatomic,strong)sureBlock sureBlock;

/**
 *  cell不能被选择
 */
@property(nonatomic,assign)BOOL dontSelectCell;
/**
 *  练习有答案后cell不能被选择
 */
@property(nonatomic,assign)BOOL preiceDontSelect;


+(MulChooseTable *)ShareTableWithFrame:(CGRect)frame HeaderTitle:(NSString *)title;//有Header

+(instancetype)ShareTableWithFrame:(CGRect)frame;//无Header

-(UIView *)createFootViewWithAnswer:(UILabel *)answerLabel andWithOtherAnswer:(UILabel *)otherLabel AndWith:(BOOL)isFlast andWithCorrent:(BOOL)isCorrent andResolve:(UILabel *)resolveLabel;

-(UIView *)createHeadViewWith:(NSString *)title;

-(void)ReloadData;


@end
