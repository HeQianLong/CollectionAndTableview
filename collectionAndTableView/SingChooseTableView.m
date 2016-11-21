//
//  SingChooseTableView.m
//  ExaminationPower
//
//  Created by 纵索科技 on 16/9/26.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import "SingChooseTableView.h"
#import "TadayExamTableViewCell.h"
#import "UIView+WHC_AutoLayout.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"
#import "Masonry.h"
#import "ZSSaveTools.h"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)



#define HeaderHeight 50
#define CellHeight 50
#define Ktimer 10
#define FONT(a)  [UIFont fontWithName:@"Heiti SC" size:a]

@interface SingChooseTableView (){

    /**
     *  题目
     */
    UILabel *titleLabel;
    
    NSArray *_chooseArr;
    
    NSArray *_noChooseArr;

    BOOL _isHistoryExam;
    
   // TadayExamTableViewCell  * cell;
}

@property(nonatomic,copy)NSString *string;

@property(nonatomic,assign)NSInteger dex;

@property(nonatomic,strong)NSString *practiceStr;


@end

@implementation SingChooseTableView
+(SingChooseTableView *)ShareTableWithFrame:(CGRect)frame{
    
    SingChooseTableView *table = [[SingChooseTableView alloc]initWithViewFrame:frame];
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


-(UIView *)createHeadView:(NSString *)title{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        _headView.backgroundColor = [UIColor whiteColor];
        
       // MyAttributedStringBuilder *builder = nil;

        
        UIButton *chooseBtn = [[UIButton alloc]init];
        [chooseBtn setTitle:@"单选题" forState:UIControlStateNormal];
        [chooseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [chooseBtn setBackgroundColor:[UIColor whiteColor]];
        chooseBtn.layer.cornerRadius = 3;
        chooseBtn.layer.masksToBounds = YES;
        chooseBtn.layer.borderColor = [UIColor blueColor].CGColor;
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
        titleLabel.font = FONT(16);
        [_headView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.equalTo(chooseBtn.mas_right).offset = 2;
            make.right.equalTo(_headView.mas_right).offset = -15;
            make.left.equalTo(chooseBtn.mas_right).offset = 5;
            make.top.equalTo(self.headView.mas_top).offset = 20;
        }];
     
        
        
    }
    _MyTable.tableHeaderView = _headView;

    return _headView;
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
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(5,1)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(12,1)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(16,2)];
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
            
            
        _MyTable.tableFooterView = _footView;

        
        
    }else{
    
        return nil;
    }
    
    
    return _footView;
}


-(void)CreateTable{

    
    

    
    //先初始化赋值
    self.dex = 100;
    
    _chooseArr = @[@"a-_sel",@"b-_sel",@"c-_sel",@"d-_sel"];
    _noChooseArr = @[@"a",@"b",@"c",@"d"];
    
    _MyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    _MyTable.dataSource = self;
    _MyTable.delegate = self;
    _MyTable.tableFooterView = _footView;
    _MyTable.tableHeaderView = _headView;
    
    _MyTable.separatorStyle = NO;
    [self addSubview:_MyTable];
    

    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UnableIsHistoryExam:) name:@"UnableIsHistoryExam" object:nil];


    

}

- (void)dealloc
{
  //  HQLAppLog(@"移除通知");
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyChooseAnswer" object:nil];
//    [ZSSaveTools removeObject:@"answerTagIndex"];
}

-(void)UnableIsHistoryExam:(NSNotification *)notion{

    //HQLAppLog(@"tag收到通知了---%@---",notion.object);
//    [ZSSaveTools setObject:notion.object forKey:@"answerTagIndex"];
    _isHistoryExam = YES;
    
  //  [self.MyTable reloadData];
    
    
}


#pragma UITableViewDelegate - UITableViewDataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TadayExamTableViewCell whc_CellHeightForIndexPath:indexPath tableView:_MyTable]+10;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   // HQLAppLog(@"****--------*****");
    
    return  self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TadayExamTableViewCell  * cell =[tableView dequeueReusableCellWithIdentifier:@"TadayExamTableViewCell"];
    
    if (!cell) {
        
        cell = [[TadayExamTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TadayExamTableViewCell"];
    }
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
     //   cell.connentLabel.text = [_dataArr objectAtIndex:indexPath.row];
    cell.connentLabel.text = [NSString stringWithFormat:@"%@",_dataArr[indexPath.row]];
  //  HQLAppLog(@"***%ld***",self.dex);
    
    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_noChooseArr[indexPath.row]]] forState:UIControlStateNormal];
    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_chooseArr[indexPath.row]]] forState:UIControlStateSelected];

    
    NSDictionary *answerDict = [ZSSaveTools getUserInfoValueForKey:@"answerDict"];
    NSString *string = [ZSSaveTools getUserPhoneAndPwdValueForKey:@"string"];
    
    NSString *tagIndex = [answerDict objectForKey:string];
    
    self.practiceStr = tagIndex;
    
  //  HQLAppLog(@"我是单选%@-----valve答案:%@---key题号:%@",answerDict,tagIndex,string);

    
        if (tagIndex != nil) {
            
            if (indexPath.row == [tagIndex integerValue]-1) {
                
                [cell UpdateCellWithState:!cell.isSelected];
                _currentSelectIndex = indexPath;
                
            }
            
        }
        

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
     *  历史模考不能再次选择答案
     */
    //NSString *historyExam = [ZSSaveTools getUserPhoneAndPwdValueForKey:@"historyExam"];
    if (self.dontSelectCell) {
     
        return;
    }
    
    if (self.practiceStr.length > 0 && self.preiceDontSelect) {
        
        return;
    }
    
    
    
    if (_currentSelectIndex!=nil&&_currentSelectIndex != indexPath) {
      TadayExamTableViewCell  *cell = [tableView cellForRowAtIndexPath:_currentSelectIndex];
        [cell UpdateCellWithState:NO];
    }
    

    TadayExamTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell UpdateCellWithState:!cell.isSelected];
    _currentSelectIndex = indexPath;
    
    _block(cell.connentLabel.text,indexPath);
}

-(void)ReloadData{
    [self.MyTable reloadData];
}

@end
