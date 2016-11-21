//
//  SingChooseTableView.h
//  ExaminationPower
//
//  Created by 纵索科技 on 16/9/26.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseBlock) (NSString *chooseContent,NSIndexPath *indexPath);

@interface SingChooseTableView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * MyTable;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)NSIndexPath * currentSelectIndex;
@property(nonatomic,copy)ChooseBlock block;

@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)UIView *footView;
/**
 *  历史模考cell不能被选择
 */
@property(nonatomic,assign)BOOL dontSelectCell;


/**
 *  练习有答案后cell不能被选择
 */
@property(nonatomic,assign)BOOL preiceDontSelect;



-(UIView *)createHeadView:(NSString *)title;

-(UIView *)createFootViewWithAnswer:(UILabel *)answerLabel andWithOtherAnswer:(UILabel *)otherLabel AndWith:(BOOL)isFlast andWithCorrent:(BOOL)isCorrent andResolve:(UILabel *)resolveLabel;

+(SingChooseTableView *)ShareTableWithFrame:(CGRect)frame;

-(instancetype)initWithViewFrame:(CGRect)frame;

-(void)ReloadData;


@end
