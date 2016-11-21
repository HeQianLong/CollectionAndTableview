//
//  MulChooseTable.m
//  ExaminationPower
//
//  Created by 纵索科技 on 16/9/28.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import "MulChooseTable.h"
#import "TadayExamTableViewCell.h"
#import "UIView+WHC_AutoLayout.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"

#import "Masonry.h"
#import "ZSSaveTools.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define FONT(a)  [UIFont fontWithName:@"Heiti SC" size:a]


#define HeaderHeight 50
#define CellHeight 50

@interface MulChooseTable (){

    /**
     *  题目
     */
    UILabel *titleLabel;

    
    NSArray *_chooseArr;
    
    NSArray *_noChooseArr;
    
    NSArray *_answerArr;
    
    TadayExamTableViewCell * cell;

    UIView *_myFootView;
    
    CGFloat _footHieght;
    
    UIButton *sureBtn;
    
    NSMutableArray *_myMuArr;
    
    NSInteger _teger;
    
}
@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)NSString *answerString;

@property(nonatomic,strong)UIView *footView;

@property(nonatomic,assign)NSInteger hideView;

@property(nonatomic,strong)NSString *practiceStr;

@end

@implementation MulChooseTable
+(MulChooseTable *)ShareTableWithFrame:(CGRect)frame HeaderTitle:(NSString *)title{
    MulChooseTable * shareInstance = [[MulChooseTable alloc] initWithFrame:frame HaveHeader:YES HeaderTitle:title];
    return  shareInstance;
}

+(MulChooseTable *)ShareTableWithFrame:(CGRect)frame{
    MulChooseTable *table = [[MulChooseTable alloc]initWithViewFrame:frame];
    return table;
}


-(instancetype)initWithViewFrame:(CGRect)frame{
    self = [super init];
    if(self){
        self.frame = frame;
        [self CreateTable];
    }
    return self;
}

//+(instancetype)ShareTableWithFrame:(CGRect)frame{
//    static MulChooseTable *shareInstance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        shareInstance = [[MulChooseTable alloc] initWithFrame:frame HaveHeader:NO HeaderTitle:nil];
//    });
//    return  shareInstance;
//}

-(instancetype)initWithFrame:(CGRect)frame HaveHeader:(BOOL)ifhHave HeaderTitle:(NSString *)title{
    self = [super init];
    if(self){
        self.frame = frame;
        [self CreateTable];
        if(ifhHave){
            UIView * view = [self CreateHeaderView_HeaderTitle:title];
            _MyMulTable.tableHeaderView = view;
            
            
        }
    }
    return self;
}

-(UIView *)createFootViewWithAnswer:(UILabel *)answerLabel andWithOtherAnswer:(UILabel *)otherLabel AndWith:(BOOL)isFlast andWithCorrent:(BOOL)isCorrent andResolve:(UILabel *)resolveLabel{
    
    UILabel *resloveLabel = [[UILabel alloc]init];
    
    
    if (isFlast) {
        
        if (!_footView) {
            _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
            // _footView.backgroundColor = [UIColor yellowColor];
            UILabel *myLabel  = [[UILabel alloc]init];
            myLabel.font = FONT(15);
            //回答正确
            if (isCorrent) {
                myLabel.text = [NSString stringWithFormat:@"正确答案是%@,你的答案是%@,回答正确",answerLabel.text,otherLabel.text];
                
            }else{
                
                myLabel.text = [NSString stringWithFormat:@"正确答案是%@,你的答案是%@,回答错误",answerLabel.text,otherLabel.text];
                
            }
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:myLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(5,answerLabel.text.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(answerLabel.text.length + 11,otherLabel.text.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(myLabel.text.length-2,2)];
            myLabel.attributedText = str;
            [_footView addSubview:myLabel];
            
            [myLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_footView.mas_top).offset = 15;
                make.left.equalTo(_footView.mas_left).offset = 10;
            }];
            /**
             *  解析
             */
            resloveLabel.text = @"解析";
            resloveLabel.textColor = [UIColor lightGrayColor];
            [_footView addSubview:resloveLabel];
            
            
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = [UIColor grayColor];
            [_footView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_footView);
                make.height.equalTo(@1);
                make.top.equalTo(myLabel.mas_bottom).offset = 10;
            }];
            [resloveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_footView.mas_left).offset = 10;
                make.top.equalTo(lineView.mas_bottom).offset = 10;
            }];
            
            UILabel *resloveDetailLabel = [[UILabel alloc]init];
            resloveDetailLabel.text = resolveLabel.text;
            resloveDetailLabel.textColor = [UIColor darkGrayColor];
            resloveDetailLabel.numberOfLines = 0;
            [_footView addSubview:resloveDetailLabel];
            [resloveDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_footView.mas_right).offset = -10;
                make.left.equalTo(_footView.mas_left).offset = 10;
                make.top.equalTo(resloveLabel.mas_bottom).offset = 5;
            }];
            
        }
        
        
        _MyMulTable.tableFooterView = _footView;
        
        
        
    }else{
        
        return nil;
    }
    
    
    return _footView;
}

-(void)CreateTable{
    
    _footHieght = 65.f;
    
    _hideView = 0 ;
    
    _chooseArr = @[@"a-_sel",@"b-_sel",@"c-_sel",@"d-_sel"];
    _noChooseArr = @[@"a",@"b",@"c",@"d"];

    _choosedArr = [[NSMutableArray alloc] initWithCapacity:0];
    _MyMulTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    _MyMulTable.dataSource = self;
    _MyMulTable.delegate = self;
    _MyMulTable.separatorStyle = NO;
    _MyMulTable.tableHeaderView = _headView;
    _MyMulTable.tableFooterView = _footView;
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationAcction:) name:@"ChooseAnswer" object:nil];
    
    //hideFootView
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideFootViewNotfication:) name:@"hideFootView" object:nil];
    
    [self addSubview:_MyMulTable];
}

-(void)hideFootViewNotfication:(NSNotification *)nafic{

    _hideView = 100;
    
    [_myFootView removeFromSuperview];
    _myFootView = nil;
    _footHieght = 0.01;
    sureBtn.hidden = YES;
    [sureBtn removeFromSuperview];
    sureBtn = nil;
    [self ReloadData];
    
}



-(void)notificationAcction:(NSNotification *)not{

    self.answerString = not.object;
    
    
    _answerArr = [NSArray array];
    _answerArr = [not.object componentsSeparatedByString:@","];
    
    //HQLAppLog(@"数组%@",_answerArr);
    for (int i = 0; i<_answerArr.count; i++) {
        
        cell.selectBtn.selected = YES;
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_chooseArr[i]]] forState:UIControlStateSelected];
        
    }

}


-(UIView *)createHeadViewWith:(NSString *)title{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _headView.backgroundColor = [UIColor whiteColor];
        

        
        UIButton *chooseBtn = [[UIButton alloc]init];
        [chooseBtn setTitle:@"多选题" forState:UIControlStateNormal];
        [chooseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [chooseBtn setBackgroundColor:[UIColor whiteColor]];
        chooseBtn.layer.cornerRadius = 3;
        chooseBtn.layer.masksToBounds = YES;
        chooseBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        chooseBtn.layer.borderWidth = 1.0f;
        
        chooseBtn.titleLabel.font  = FONT(15);
        [_headView addSubview:chooseBtn];
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headView.mas_left).offset = 10;
            make.top.equalTo(self.headView.mas_top).offset = 20;
            make.size.mas_equalTo(CGSizeMake(65, 23));
        }];
        
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        [_headView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(chooseBtn.mas_right).offset = 2;
            make.right.equalTo(_headView.mas_right).offset = -10;
            make.top.equalTo(self.headView.mas_top).offset = 20;
        }];
        
        
        

        
        
    }
    
    _MyMulTable.tableHeaderView = _headView;
    
    return _headView;
}


-(UIView *)CreateHeaderView_HeaderTitle:(NSString *)title{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderHeight)];
    UILabel * HeaderTitleLab = [[UILabel alloc]init];
    HeaderTitleLab.text = title;
    [headerView addSubview:HeaderTitleLab];
    [HeaderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.top.equalTo(headerView.mas_top).offset(0);
        make.height.mas_equalTo(headerView.mas_height);
    }];
    UIButton *chooseIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseIcon.tag = 10;
//    [chooseIcon setImage:[UIImage imageNamed:@"option_n"] forState:UIControlStateNormal];
//    [chooseIcon setImage:[UIImage imageNamed:@"option_y"] forState:UIControlStateSelected];
    chooseIcon.userInteractionEnabled = NO;
    [headerView addSubview:chooseIcon];
    [chooseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(HeaderTitleLab.mas_right).offset(10);
        make.right.equalTo(headerView.mas_right).offset(-15);
        make.top.equalTo(headerView.mas_top);
        make.height.mas_equalTo(headerView.mas_height);
        make.width.mas_equalTo(50);
    }];
    
    UIButton * chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height);
    [chooseBtn addTarget:self action:@selector(ChooseAllClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:chooseBtn];
    return headerView;
}


-(void)ChooseAllClick:(UIButton *)button{
    _ifAllSelecteSwitch = YES;
    UIButton * chooseIcon = (UIButton *)[_MyMulTable.tableHeaderView viewWithTag:10];
    chooseIcon.selected = !_ifAllSelected;
    _ifAllSelected = !_ifAllSelected;
    if (_ifAllSelected) {
        [_choosedArr removeAllObjects];
        [_choosedArr addObjectsFromArray:_dataArr];
    }
    else{
        [_choosedArr removeAllObjects];
    }
    [_MyMulTable reloadData];
    self.tableChooseBlock(@"All",_choosedArr);
    
}

#pragma UITableViewDelegate - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TadayExamTableViewCell whc_CellHeightForIndexPath:indexPath tableView:_MyMulTable]+10;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * identifier = [NSString stringWithFormat:@"cellId%ld",(long)indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TadayExamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.connentLabel.text = [_dataArr objectAtIndex:indexPath.row];
    
    
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_noChooseArr[indexPath.row]]] forState:UIControlStateNormal];
        [cell.selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_chooseArr[indexPath.row]]] forState:UIControlStateSelected];

    
    NSDictionary *answerDict = [ZSSaveTools getUserInfoValueForKey:@"answerDict"];
    NSString *string = [ZSSaveTools getUserPhoneAndPwdValueForKey:@"string"];
    NSString *tagIndex = [answerDict objectForKey:string];
    
    self.practiceStr = tagIndex;

    
//HQLAppLog(@"多选%@-----valve:%@---key:%@",answerDict,tagIndex,string);
    if (tagIndex != nil) {
        
        _myMuArr = [NSMutableArray array];
        
        
    if ([tagIndex rangeOfString:@","].location != NSNotFound) {
        
        NSArray *ansArr = [tagIndex componentsSeparatedByString:@","];
        
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in ansArr) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        
      //  HQLAppLog(@"多选删除相同的数据%@",listAry);
        
        
        for (int i = 0; i<listAry.count; i++) {
            if ([listAry[i]integerValue] == 1) {
                
                if (indexPath.row == 0) {
                    
                    [cell UpdateCellWithState:!cell.isSelected];
                    [_choosedArr addObject:[NSString stringWithFormat:@"1"]];
                }
                
            }else if ([listAry[i]integerValue] == 2){
                
                if (indexPath.row == 1) {
                    
                    [cell UpdateCellWithState:!cell.isSelected];
                     [_choosedArr addObject:[NSString stringWithFormat:@"2"]];
                }

            }else if ([listAry[i]integerValue] == 4){
                
                if (indexPath.row == 2) {
                    
                    [cell UpdateCellWithState:!cell.isSelected];
                     [_choosedArr addObject:[NSString stringWithFormat:@"4"]];
                }
                
            }else if ([listAry[i]integerValue] == 8){
                
                if (indexPath.row ==3) {
                    
                    [cell UpdateCellWithState:!cell.isSelected];
                     [_choosedArr addObject:[NSString stringWithFormat:@"8"]];
                }
                
            }
            
        }
        
        
    }else{
    
        if (tagIndex.length == 1) {
            
            if ([tagIndex integerValue] == 1) {
            
                if (indexPath.row == 0) {
                    
                    [cell UpdateCellWithState:!cell.isSelected];
                     [_choosedArr addObject:[NSString stringWithFormat:@"1"]];
                }

            }
            if ([tagIndex integerValue] == 2) {
                
                if (indexPath.row == 1) {
                    
                    [cell UpdateCellWithState:!cell.isSelected];
                     [_choosedArr addObject:[NSString stringWithFormat:@"2"]];
                }
                
            }
            if ([tagIndex integerValue] == 4) {
                
                if (indexPath.row == 2) {
                    
                    [cell UpdateCellWithState:!cell.isSelected];
                     [_choosedArr addObject:[NSString stringWithFormat:@"4"]];
                }
                
            }
            if ([tagIndex integerValue] == 8) {
                
                if (indexPath.row == 3) {
                    
                    [cell UpdateCellWithState:!cell.isSelected];
                     [_choosedArr addObject:[NSString stringWithFormat:@"8"]];
                }
                
            }




        }
        

    }
        
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in _choosedArr) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
}
    
    
    
    
    
    
    if (_ifAllSelecteSwitch) {
        [cell UpdateCellWithState:_ifAllSelected];
        if (indexPath.row == _dataArr.count-1) {
            _ifAllSelecteSwitch  = NO;
        }
    }
    
 //   HQLAppLog(@">>>>>>>>>>>>>>>>%@",_choosedArr);
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *historyExam = [ZSSaveTools getUserPhoneAndPwdValueForKey:@"historyExam"];
    if (self.dontSelectCell) {
        
        return;
    }

    if (self.practiceStr.length > 0 && self.preiceDontSelect) {
        
        return;
    }
    
    
    _teger = 100;
    
   cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell UpdateCellWithState:!cell.isSelected];
    
    NSInteger chooseIndex = 0;
    
    if (indexPath.row == 0) {
        chooseIndex = 1;
    }else if (indexPath.row == 1){
        chooseIndex = 2;
    }else if (indexPath.row == 2){
        chooseIndex = 4;
    }else if (indexPath.row == 3){
        chooseIndex = 8;
    }
    
    
    
    if (cell.isSelected) {
        
        [_choosedArr addObject:[NSString stringWithFormat:@"%ld",chooseIndex]];
    }
    else{
        
        [_choosedArr removeObject:[NSString stringWithFormat:@"%ld",chooseIndex]];
    }
    
    if (_choosedArr.count<_dataArr.count) {
        _ifAllSelected = NO;
        UIButton * chooseIcon = (UIButton *)[_MyMulTable.tableHeaderView viewWithTag:10];
        chooseIcon.selected = _ifAllSelected;
    }
    
    
    
    self.tableChooseBlock([NSString stringWithFormat:@"%ld",indexPath.row],_choosedArr);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.hideView == 100) {
        return nil;
    }else{
    
        _myFootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
        sureBtn = [[UIButton alloc]init];
        [sureBtn setTitle:@"确认答案" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setBackgroundColor:[UIColor orangeColor]];
        sureBtn.layer.masksToBounds = YES;
        sureBtn.layer.cornerRadius = 5.f;
        [sureBtn addTarget:self action:@selector(sureClickAcction) forControlEvents:UIControlEventTouchUpInside];
        [_myFootView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_myFootView.mas_right).offset = -45;
            make.left.equalTo(_myFootView.mas_left).offset = 45;
            make.height.equalTo(@45);
            make.bottom.equalTo(_myFootView.mas_bottom);
        }];
        
        
        return _myFootView;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return _footHieght;
}


-(void)sureClickAcction{

    
    if (_choosedArr.count == 0) {
        
       // [[TKAlertCenter defaultCenter]postAlertWithMessage:@"请选择答案后再确认"];

    }else{
       
        if (_teger !=100) {
            
//            HQLAppLog(@"没有更改选项");
//            [[TKAlertCenter defaultCenter]postAlertWithMessage:@"你的答案没有更改，请修改后确认"];
            
            
        }else{
            self.sureBlock();

        }
        
        
    }
    
}

-(void)ReloadData{
    [self.MyMulTable reloadData];
}


@end
