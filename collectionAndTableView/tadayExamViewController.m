//
//  tadayExamViewController.m
//  ExaminationPower
//
//  Created by 纵索科技 on 16/9/24.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import "tadayExamViewController.h"
#import "TadayExamTableViewCell.h"

#import "SingChooseTableView.h"
#import "MulChooseTable.h"
#import "ZSSaveTools.h"
#import "tadayExamCollectionViewCell.h"
#import "Masonry.h"
#import "UIView+WHC_AutoLayout.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define FONT(a)  [UIFont fontWithName:@"Heiti SC" size:a]


#define Ktimer 10
@interface tadayExamViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{

    UILabel *timeLabel;
    
    NSArray *_titleArr;
    //正确的
    UILabel *correntLabel;
    /**
     *  错误的个数
     */
    UILabel *errorLabel;
    
    /**
     *  题目
     */
    UILabel *titleLabel;
    
    TadayExamTableViewCell *cell;
    
  //  SingChooseTableView *MyTable;
    
//    MulChooseTable *mulchooseTabView;
    
  //  NSMutableArray * dataArr;
    /**
     *  目录
     */
    UIButton *catalogBtn;
    /**
     *  答题卡view
     */
    UIView *anmitionView;
    
    
    /**
     *  scrollView偏移量
     */
//    NSInteger indexPage;
    
   // NSInteger index;
    
    
}

@property(nonatomic,assign) NSInteger Current;

@property(nonatomic,strong)NSTimer *countTimer;

@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)    SingChooseTableView *MyTable;
@property(nonatomic,strong) MulChooseTable *mulchooseTabView;
/**
 *  存放答案的字典
 */
@property(nonatomic,strong)NSMutableDictionary *answerDict;

@property(nonatomic,assign)NSInteger tableIndex;
/**
 *  scrollView偏移量
 */

@property(nonatomic,assign)  NSInteger indexPage;
/**
 *  多选答案的数组
 */
@property(nonatomic,strong)NSMutableArray *mulChooseArr;
/**
 *  答案数组
 */
@property(nonatomic,strong)NSMutableArray *dataArr;
/**
 *  存放题目选项数组
 */
@property(nonatomic,strong)NSMutableArray *bigArr;
/**
 *  存放问题的题目数组
 */
@property(nonatomic,strong)NSMutableArray *titlequestArr;
/**
 *  存放block回调的多选答案数组
 */
@property(nonatomic,strong)NSArray *pathArr;


/**
 *  正确答案数组
 */
@property(nonatomic,strong)NSMutableArray *trueAnsArr;

/**
 *  错误答案数组
 */
@property(nonatomic,strong)NSMutableArray *errorAnsArr;

/**
 *  模考回答正确的数组
 */
@property(nonatomic,strong)NSMutableArray *scoreArr;
/**
 *  交卷数组
 */
@property(nonatomic,strong)NSMutableArray *handArr;

@property(nonatomic,assign)NSInteger removeTag;

@end


@implementation tadayExamViewController

//-(NSMutableArray *)handArr{
//    if (!_handArr) {
//        _handArr = [NSMutableArray array];
//    }
//    return _handArr;
//}

-(NSMutableArray *)scoreArr{
    if (!_scoreArr) {
        _scoreArr = [NSMutableArray array];
    }
    return _scoreArr;
}

-(NSMutableArray *)titlequestArr{
    if (!_titlequestArr) {
        _titlequestArr = [NSMutableArray array];
    }
    return _titlequestArr;
}

-(NSMutableArray *)bigArr{
    if (!_bigArr) {
        _bigArr = [NSMutableArray array];
    }
    return _bigArr;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

-(NSMutableArray *)mulChooseArr{
    if (!_mulChooseArr) {
        _mulChooseArr = [NSMutableArray array];
    }
    return _mulChooseArr;
}

-(NSMutableDictionary *)answerDict{
    if (!_answerDict) {
        _answerDict = [NSMutableDictionary dictionary];
    }
    return _answerDict;
}

-(void)viewWillAppear:(BOOL)animated{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"MyChooseAnswer"];
    [defaults removeObjectForKey:@"scrollViewAnswer"];
    [defaults removeObjectForKey:@"answerDict"];
    [defaults removeObjectForKey:@"cellTagIndex"];
    [defaults removeObjectForKey:@"string"];
  // [defaults removeObjectForKey:@"historyExam"];
    
    [defaults synchronize];
}



- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    if (self.IsPractice || self.isHistory) {
      //  [self getCategoryNetwork];

        
    }else{
        
        [self createTitileView];
//        [self tadayExamNetwork];
        
    }
    
    
    self.IsPractice = YES;
    

    _indexPage = 1;
    
    _handArr = [NSMutableArray array];

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //确定水平滑动方向
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
 //   [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];垂直方向
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册Cell，必须要有
    [self.collectionView registerClass:[tadayExamCollectionViewCell class] forCellWithReuseIdentifier:@"tadayExamCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
    

_dataArr = [NSMutableArray arrayWithObjects:@"后冠的吴茜莉妙答参议员针对“南海仲裁”的提问年仅20岁的王汉民",@"吴茜莉妙答参议员针对“南海仲裁",@"后冠的吴茜莉妙答参议员针对“南海仲裁”的提问年仅20岁的王汉",@"后冠的吴茜莉妙答参议员针对“南海仲裁”的提问年仅20岁的王汉民", nil];
    
    
    
}


#pragma mark - scrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    /**
     *  视图滚动时将存储到本地的答案删除
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"MyChooseAnswer"];

    
    CGPoint point = scrollView.contentOffset;
    
    _indexPage = (int)point.x/SCREEN_WIDTH + 1;

    
    [defaults synchronize];

    
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *Idenfire = @"tadayExamCollectionViewCell";
    UICollectionViewCell *mycell = [collectionView dequeueReusableCellWithReuseIdentifier:Idenfire forIndexPath:indexPath];

    if (mycell) {
       
        for (UIView *view in mycell.contentView.subviews) {
            if (view) {
                [view removeFromSuperview];
            }}}
    
    
    __weak typeof(self)weakSelf = self;

    /**
     *  答案A1 B2 C4 D8   ABC7 ABD11 BCD14  AB3 AC5 AD9 BC6 BD10 ABCD15
     */
    
    self.pathArr = [NSMutableArray array];
    
  //  HQLAppLog(@"大数组%@",_bigArr);
    
    if (indexPath.row %2 == 0) {
        
        //单选
        _MyTable = [SingChooseTableView ShareTableWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, self.view.frame.size.height-120)];
        _MyTable.dataArr =  self.dataArr;

        [_MyTable createHeadView:[NSString stringWithFormat:@"我是单选就问你怕不怕"]];
        /**
         *  历史已返回答案不能再次选择
         */
        if (self.isHistory) {
            _MyTable.dontSelectCell = YES;
        }
        /**
         *  练习已有选择的答案后，不能选择
         */
        if (self.IsPractice) {
            
            _MyTable.preiceDontSelect = YES;
        }
        
        
        NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        [ZSSaveTools setObject:str forKey:@"string"];

        
        
        //选中内容
        _MyTable.block = ^(NSString *chooseContent,NSIndexPath *indePath){
            
            
            //weakSelf.removeTag = 1024;
            
            
            weakSelf.tableIndex = indePath.row+1;
            
           // HQLAppLog(@"数据----第%ld行",indePath.row);
            
            if (weakSelf.IsPractice ){
                //ABCD四个选项分别用 1 2 4 8 来表示
                /**
                 *  第一个参数代表用户选择的答案
                    第二个参数:服务器返回的正确答案
                    第三个参数:答案的解析
                    第四个参数:第几题
                    第五个参数:题目的id（根据服务器返回）
                 */
               [weakSelf ExamAnswerWith:[NSString stringWithFormat:@"%ld",indePath.row+1] andWith:@"8" AndWith:@"我是答案的解析，屌不屌" andWithTitle:[NSString stringWithFormat:@"%ld",indexPath.row+1]andWith:@"4"];
            }
            
            //存储答案
            [weakSelf.answerDict setValue:[NSString stringWithFormat:@"%ld",weakSelf.tableIndex]forKey:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:weakSelf.answerDict forKey:@"answerDict"];
            [defaults synchronize];
            NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row+1];
            [ZSSaveTools setObject:str forKey:@"string"];

            
           // HQLAppLog(@"------%@",weakSelf.answerDict);
            
        };
            
                
        
            
            if ([self.answerDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]]) {
                
                
                NSString *str = [self.answerDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
                //*显示用户之前选择的答案*/
                //str代表用户已经选的答案 8是正确答案此处写死
                [weakSelf ExamAnswerWith:str andWith:@"8" AndWith:@"我是答案的解析，屌不屌"andWithTitle:[NSString stringWithFormat:@"%ld",indexPath.row+1]andWith:@"12"];

                
//                [weakSelf ExamAnswerWith:[NSString stringWithFormat:@"%ld",indexPath.row+1] andWith:@"8" AndWith:@"我是答案的解析，屌不屌" andWithTitle:[NSString stringWithFormat:@"%ld",indexPath.row+1]andWith:@"4"];
                
                
            }

        
        [mycell.contentView addSubview:self.MyTable];

    }else {
    
        
        
        //多选的tableview
       _mulchooseTabView = [MulChooseTable ShareTableWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
        _mulchooseTabView.dataArr = self.dataArr;
        _mulchooseTabView.tag = indexPath.row;
        [_mulchooseTabView createHeadViewWith:@"我是多选，别选错了啊"];
       // [mulchooseTabView ReloadData];
        
        NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        [ZSSaveTools setObject:str forKey:@"string"];
        /**
         *  历史模考不能再次选择
         */
        if (self.isHistory) {
            _mulchooseTabView.dontSelectCell = YES;
        }
        if (self.IsPractice) {
            
            _mulchooseTabView.preiceDontSelect = YES;
        }

        
        _mulchooseTabView.tableChooseBlock = ^(NSString *chooseConent,NSMutableArray *chooseArr){
            
            NSMutableArray *listAry = [[NSMutableArray alloc]init];
            for (NSString *str in chooseArr) {
                if (![listAry containsObject:str]) {
                    [listAry addObject:str];
                }
            }

            
           // HQLAppLog(@"--*****---%@",listAry);
            /**
             *  答案A1 B2 C4 D8   ABC7 ABD11 BCD14  AB3 AC5 AD9 BC6 BD10 CD12 ABCD15 ACD13
             */

            
           weakSelf.mulchooseTabView.sureBlock = ^{
               
               if (weakSelf.IsPractice || weakSelf.isHistory || weakSelf.IsTadayExam){
                   
                  [weakSelf myMulChooseAnswerWith:chooseArr AndWithBackAnswer:@"13" AndWithJieXi:@"我是多选的答案解析" andWithTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1]AndWithSeq:@"456"];
                   
                   
               }
               
               NSMutableString * string = [[NSMutableString alloc] init];
               
               NSString *string333 = [chooseArr componentsJoinedByString:@","];
               
               for (int i = 0; i<chooseArr.count; i++) {
                   
                   [string stringByAppendingString:string333];
                   
               }
               
               [weakSelf.answerDict setValue:[NSString stringWithFormat:@"%@",string333]forKey:[NSString stringWithFormat:@"%ld",(indexPath.row+1)]];
               

               
               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
               [defaults setValue:weakSelf.answerDict forKey:@"answerDict"];
               NSString *str = [NSString stringWithFormat:@"%ld",(indexPath.row+1)];
               [defaults setValue:str forKey:@"string"];
               [defaults synchronize];
               
              // HQLAppLog(@"%@------%@-----%@",weakSelf.answerDict,str,weakSelf.handArr);

               /**
                *  回答发送通知隐藏TableViewfootview
                */
               [[NSNotificationCenter defaultCenter]postNotificationName:@"hideFootView" object:nil];

               
               
             //  HQLAppLog(@"%@------%@",weakSelf.answerDict,str);

            };

            
        };
        
        
        
        
    if (weakSelf.IsPractice || weakSelf.isHistory || weakSelf.IsTadayExam){
        
        if ([weakSelf.answerDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]]) {
            
                /**
                 *  回答发送通知隐藏TableViewfootview
                 */
                [[NSNotificationCenter defaultCenter]postNotificationName:@"hideFootView" object:nil];

            NSDictionary *myAnswerDict = [ZSSaveTools getUserInfoValueForKey:@"answerDict"];
            NSString *string = [ZSSaveTools getUserPhoneAndPwdValueForKey:@"string"];
            NSString *tagIndex = [myAnswerDict objectForKey:string];

          //  [self.pathArr addObject:tagIndex];
            self.pathArr = [tagIndex componentsSeparatedByString:@","];
            
            
            [weakSelf myMulChooseAnswerWith:self.pathArr  AndWithBackAnswer:@"13" AndWithJieXi:@"我是多选的答案解析" andWithTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1]AndWithSeq:@"456"];

//            [weakSelf myMulChooseAnswerWith:chooseArr AndWithBackAnswer:@"13" AndWithJieXi:@"我是多选的答案解析" andWithTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1]AndWithSeq:@"456"];

            
            
        }
        /**
         *  历史模考有自己已经选过的答案oldanswer
         */
        /*
        if (self.isHistory) {
            
            
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            if ([model.oldanswer integerValue] == 7) {
                
                //correctLabel.text = @"ABC";
                [dict setValue:@"1,2,4" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
                
            }else if ([model.oldanswer integerValue] == 11){
                
               // correctLabel.text = @"ABD";
                [dict setValue:@"1,2,8" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }else if ([model.oldanswer integerValue] == 14){
                
               // correctLabel.text = @"BCD";
                [dict setValue:@"2,4,8" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }else if ([model.oldanswer integerValue] == 3){
                
                //correctLabel.text = @"AB";
                [dict setValue:@"1,2" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

                
            }else if ([model.oldanswer integerValue] == 5){
                
               // correctLabel.text = @"AC";
                [dict setValue:@"1,4" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }else if ([model.oldanswer integerValue] == 9){
                
                //correctLabel.text = @"AD";
                [dict setValue:@"1,8" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }else if ([model.oldanswer integerValue] == 6){
                
                //correctLabel.text = @"BC";
                [dict setValue:@"2,4" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }else if ([model.oldanswer integerValue] == 10){
                
                //correctLabel.text = @"BD";
                [dict setValue:@"2,8" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }else if ([model.oldanswer integerValue] == 12){
                
                //correctLabel.text = @"CD";
                [dict setValue:@"4,8" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }else if ([model.oldanswer integerValue] == 13){
                
               // correctLabel.text = @"ACD";
                [dict setValue:@"1,4,8" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

                
            }else if ([model.oldanswer integerValue] == 15){
                
                //correctLabel.text = @"ABCD";
                [dict setValue:@"1,2,4,8" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }
            else if ([model.oldanswer integerValue] == 1){
                
                //correctLabel.text = @"A";
                [dict setValue:@"1" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }else if ([model.oldanswer integerValue] == 2){
                
              //  correctLabel.text = @"B";
                [dict setValue:@"2" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

                
            }else if ([model.oldanswer integerValue] == 4){
                
                //correctLabel.text = @"C";
                [dict setValue:@"4" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

                
            }else if ([model.oldanswer integerValue] == 8){
                
              //  correctLabel.text = @"D";
                [dict setValue:@"8" forKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

            }
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:dict forKey:@"answerDict"];
            NSString *str = [NSString stringWithFormat:@"%ld",(indexPath.row+1)];
            [defaults setValue:str forKey:@"string"];
            [defaults synchronize];

            
            
            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:model.answer];
            
            [weakSelf myMulChooseAnswerWith:arr  AndWithBackAnswer:model.oldanswer AndWithJieXi:model.analyze andWithTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1]AndWithSeq:model.eid];

            
            
            
        }
        */

        
    }
        
        [mycell.contentView addSubview:_mulchooseTabView];

        
    }
    
    
    
    
    
    return mycell;
}

#pragma mark - 用户单选的时候
/**
 *  单选
 *
 *  @param flast      错误答案
 *  @param tureAnswer 正确答案
 *  @param JieXi      解析
 */
-(void)ExamAnswerWith:(NSString *)flast andWith:(NSString *)tureAnswer AndWith:(NSString *)JieXi andWithTitle:(NSString *)title andWith:(NSString *)seqStr{
    
    
  //  HQLAppLog(@"%@------%@",flast,tureAnswer);
    
    
    NSString *myStr = nil;
    
        UILabel *labelll = [[UILabel alloc]init];
//        labelll.text = flast;
        labelll.textColor = [UIColor blueColor];
        /**
         *  正确答案
         */
        UILabel *correctLabel = [[UILabel alloc]init];
        correctLabel.textColor = [UIColor redColor];
        //correctLabel.text = tureAnswer;
        
        UILabel *resloveLabel = [[UILabel alloc]init];
        resloveLabel.text = JieXi;//@"你选择错了，再交点学费继续学习一下吧，你选择错了，再交点学费继续学习一下吧";
        resloveLabel.textColor = [UIColor darkGrayColor];
    
    if ([flast integerValue] == 1) {
        labelll.text = @"A";
        myStr = @"1";
        
    }else if ([flast integerValue] == 2 ){
        labelll.text = @"B";
        myStr = @"2";

    }else if ([flast integerValue] == 3 ){
        labelll.text = @"C";
        myStr = @"4";

    }else if ([flast integerValue] == 4 ){
        labelll.text = @"D";
        myStr = @"8";

    }
    
    if (self.isHistory) {
        
        if ([flast integerValue] == 1) {
            labelll.text = @"A";
            myStr = @"1";
            
        }else if ([flast integerValue] == 2 ){
            labelll.text = @"B";
            myStr = @"2";
            
        }else if ([flast integerValue] == 4 ){
            labelll.text = @"C";
            myStr = @"4";
            
        }else if ([flast integerValue] == 8 ){
            labelll.text = @"D";
            myStr = @"8";
            
        }

    }
    
    
    
    
    if ([tureAnswer integerValue] == 1) {
        correctLabel.text = @"A";
    }else if([tureAnswer integerValue] == 2){
        correctLabel.text = @"B";
    }else if([tureAnswer integerValue] == 4){
        correctLabel.text = @"C";
    }else if([tureAnswer integerValue] == 8){
        correctLabel.text = @"D";
    }
    
    
//    HQLAppLog(@"%@---%@---%@",labelll.text,correctLabel.text,title);
    
    /**
     *  重新选择答案时，移除以前的
     */
    if (self.handArr.count !=0) {
        for (int i = 0; i < self.handArr.count; i++) {
            NSArray *aa = [self.handArr[i] allKeys];
            if ([aa containsObject:seqStr]) {
                [self.handArr removeObjectAtIndex:i];
            }
        }
        
        
        for (int i = 0; i< self.handArr.count; i++) {
            NSDictionary *dict1 = self.handArr[i];
            if (dict1[@"eid"] == seqStr) {
                [self.handArr removeObjectAtIndex:i];

            }
            
        }
        
    }
    

    
    
    /**
     *  回答正确
     */
    if ([labelll.text isEqualToString:correctLabel.text]) {
        
        NSMutableArray *pathMuArr  =[ NSMutableArray array];
        
        if (self.IsTadayExam) {
            
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:myStr forKey:@"answer"];
            [dict setObject:seqStr forKey:@"eid"];

            [dict setObject:@"1" forKey:@"isright"];
            [self.handArr addObject:dict];

            
            [pathMuArr addObject:title];
            
            NSMutableArray *listAry = [[NSMutableArray alloc]init];
            for (NSString *str in self.scoreArr) {
                if (![listAry containsObject:str]) {
                    [listAry addObject:str];
                }
            }

            [self.scoreArr addObject:pathMuArr];
            
        }else{
            
            [_MyTable createFootViewWithAnswer:correctLabel andWithOtherAnswer:labelll AndWith:YES andWithCorrent:YES andResolve:resloveLabel];
            
        }
        [self.trueAnsArr addObject:title];

        

        /**
         只记录题号，如果题号相同就移除
         */
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in self.trueAnsArr) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        
        
        correntLabel.text = [NSString stringWithFormat:@"%ld",listAry.count];

        

    }else{

        if (self.IsTadayExam){
        
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:seqStr forKey:@"eid"];
            [dict setObject:myStr forKey:@"answer"];
            [dict setObject:@"0" forKey:@"isright"];
            [self.handArr addObject:dict];

            
        }else{
        
            /**
             *  用户没有选择答案的时候
             */
          //  HQLAppLog(@"---%@",labelll.text);
            if (labelll.text == nil) {
                UILabel *nullLabel = [[UILabel alloc]init];
                nullLabel.text = @"空";
                [_MyTable createFootViewWithAnswer:correctLabel andWithOtherAnswer:nullLabel AndWith:YES andWithCorrent:NO andResolve:resloveLabel];

                
            }else{
            
                [_MyTable createFootViewWithAnswer:correctLabel andWithOtherAnswer:labelll AndWith:YES andWithCorrent:NO andResolve:resloveLabel];
 
            }
            
            
  
        }
        
        
          [self.errorAnsArr addObject:title];
        /**
         只记录题号，如果题号相同就移除
         */
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in self.errorAnsArr) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        errorLabel.text = [NSString stringWithFormat:@"%ld",listAry.count];

    }
    

}
#pragma mark - 多选
/**
 *  练习多选
 *
 *  @param muArr       用户自己选择的答案数组
 *  @param backAnswer 服务器返回的正确答案
 *  @param JX         答案解析
 */
-(void)myMulChooseAnswerWith:(NSArray *)muArr AndWithBackAnswer:(NSString *)backAnswer AndWithJieXi:(NSString *)JX andWithTitle:(NSString *)title AndWithSeq:(NSString *)SeqStr{
    
    
    /**
     *  数组内答案之和
     */
    NSInteger sumAnswer = 0;
    NSInteger ans = 0;
    
  //  HQLAppLog(@"---------%@",backAnswer);
    
    NSMutableArray *listAry = [[NSMutableArray alloc]init];
    for (NSString *str in muArr) {
        if (![listAry containsObject:str]) {
            [listAry addObject:str];
        }
    }

    
    for (int i = 0; i<listAry.count; i++) {
        
         ans = [listAry[i]integerValue];
        sumAnswer += ans;
    }
    
    
    /**
     *  答案A1 B2 C4 D8   ABC7 ABD11 BCD14  AB3 AC5 AD9 BC6 BD10 CD12 ABCD15
     */

    
    UILabel *labelll = [[UILabel alloc]init];
    labelll.textColor = [UIColor blueColor];
    /**
     *  正确答案
     */
    UILabel *correctLabel = [[UILabel alloc]init];
    correctLabel.textColor = [UIColor redColor];
    //correctLabel.text = tureAnswer;
    
    UILabel *resloveLabel = [[UILabel alloc]init];
    resloveLabel.text = JX;//@"你选择错了，再交点学费继续学习一下吧，你选择错了，再交点学费继续学习一下吧";
    resloveLabel.textColor = [UIColor darkGrayColor];

    
    if (sumAnswer == 7) {
        
        labelll.text = @"ABC";
        
    }else if (sumAnswer == 11){
    
        labelll.text = @"ABD";

    }else if (sumAnswer == 14){
        
        labelll.text = @"BCD";
        
    }else if (sumAnswer == 3){
        
        labelll.text = @"AB";
        
    }else if (sumAnswer == 5){
        
        labelll.text = @"AC";
        
    }else if (sumAnswer == 9){
        
        labelll.text = @"AD";
        
    }else if (sumAnswer == 6){
        
        labelll.text = @"BC";
        
    }else if (sumAnswer == 10){
        
        labelll.text = @"BD";
        
    }else if (sumAnswer == 12){
        
        labelll.text = @"CD";
        
    }else if (sumAnswer == 13){
        
        labelll.text = @"ACD";
        
    }
    else if (sumAnswer == 15){
        
        labelll.text = @"ABCD";
        
    }
    else if (sumAnswer == 1){
        
        labelll.text = @"A";
        
    }else if (sumAnswer == 2){
        
        labelll.text = @"B";
        
    }else if (sumAnswer == 4){
        
        labelll.text = @"C";
        
    }else if (sumAnswer == 8){
        
        labelll.text = @"D";
        
    }else if (sumAnswer == 0){
        
        labelll.text = @"空";
        
    }
/***********************服务端返回的答案*************************/
    if ([backAnswer integerValue] == 7) {
        
        correctLabel.text = @"ABC";
        
    }else if ([backAnswer integerValue] == 11){
        
        correctLabel.text = @"ABD";
        
    }else if ([backAnswer integerValue] == 14){
        
        correctLabel.text = @"BCD";
        
    }else if ([backAnswer integerValue] == 3){
        
        correctLabel.text = @"AB";
        
    }else if ([backAnswer integerValue] == 5){
        
        correctLabel.text = @"AC";
        
    }else if ([backAnswer integerValue] == 9){
        
        correctLabel.text = @"AD";
        
    }else if ([backAnswer integerValue] == 6){
        
        correctLabel.text = @"BC";
        
    }else if ([backAnswer integerValue] == 10){
        
        correctLabel.text = @"BD";
        
    }else if ([backAnswer integerValue] == 12){
        
        correctLabel.text = @"CD";
        
    }else if ([backAnswer integerValue] == 13){
        
        correctLabel.text = @"ACD";
        
    }else if ([backAnswer integerValue] == 15){
        
        correctLabel.text = @"ABCD";
        
    }
    else if ([backAnswer integerValue] == 1){
        
        correctLabel.text = @"A";
        
    }else if ([backAnswer integerValue] == 2){
        
        correctLabel.text = @"B";
        
    }else if ([backAnswer integerValue] == 4){
        
        correctLabel.text = @"C";
        
    }else if ([backAnswer integerValue] == 8){
        
        correctLabel.text = @"D";
        
    }else if ([backAnswer integerValue] == 0){
        
        correctLabel.text = @"空";
        
    }
    
    
    /**
     *  回答发送通知隐藏TableViewfootview
     */
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"hideFootView" object:nil];

    /**
     *  重新选择答案时，移除以前的
     */
    if (self.handArr.count !=0) {
        for (int i = 0; i < self.handArr.count; i++) {
            NSArray *aa = [self.handArr[i] allKeys];
            if ([aa containsObject:SeqStr]) {
                [self.handArr removeObjectAtIndex:i];
            }
        }

        
        for (int i = 0; i< self.handArr.count; i++) {
            NSDictionary *dict1 = self.handArr[i];
            if (dict1[@"eid"] == SeqStr) {
                [self.handArr removeObjectAtIndex:i];
                
            }
            
        }

        
        
        
    }
    /**
     *  答案选择正确
     */
    if (sumAnswer == [backAnswer integerValue]) {
        
        if (!self.IsTadayExam) {
        
            /**
             *  回答发送通知隐藏TableViewfootview
             */
            [[NSNotificationCenter defaultCenter]postNotificationName:@"hideFootView" object:nil];

            [_mulchooseTabView createFootViewWithAnswer:correctLabel andWithOtherAnswer:labelll AndWith:YES andWithCorrent:YES andResolve:resloveLabel];
 
        }else{
        
            if (self.isHistory || self.IsPractice) {
                
                [_mulchooseTabView createFootViewWithAnswer:correctLabel andWithOtherAnswer:labelll AndWith:YES andWithCorrent:YES andResolve:resloveLabel];

                
            }
            
            
            
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSString stringWithFormat:@"%ld",sumAnswer] forKey:@"answer"];
            [dict setObject:SeqStr forKey:@"eid"];
            
            [dict setObject:@"1" forKey:@"isright"];
            [self.handArr addObject:dict];

            
            NSMutableArray *pathMuArr  =[ NSMutableArray array];
            
            [pathMuArr addObject:title];
            
            NSMutableArray *listAry = [[NSMutableArray alloc]init];
            for (NSString *str in self.scoreArr) {
                if (![listAry containsObject:str]) {
                    [listAry addObject:str];
                }
            }
            
            [self.scoreArr addObject:pathMuArr];
        }
        
        [self.trueAnsArr addObject:title];
        
        
      //  HQLAppLog(@">>>>>%@",self.handArr);
        
        /**
         只记录题号，如果题号相同就移除
         */
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in self.trueAnsArr) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        correntLabel.text = [NSString stringWithFormat:@"%ld",listAry.count];
        
    }else{
    
        if (self.IsTadayExam) {
            
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setObject:[NSString stringWithFormat:@"%ld",sumAnswer] forKey:@"answer"];
            [dict setObject:SeqStr forKey:@"eid"];

            [dict setObject:@"0" forKey:@"isright"];
            
            [self.handArr addObject:dict];
            
        }else{
        
            if (self.isHistory) {
                
               // [_mulchooseTabView createFootViewWithAnswer:correctLabel andWithOtherAnswer:labelll AndWith:YES andWithCorrent:NO andResolve:resloveLabel];
                
//                if (labelll.text == nil) {
//                    UILabel *nullLabel = [[UILabel alloc]init];
//                    nullLabel.text = @"空";
//                    [_mulchooseTabView createFootViewWithAnswer:correctLabel andWithOtherAnswer:nullLabel AndWith:YES andWithCorrent:NO andResolve:resloveLabel];
//                    
//                    
//                }else{
                
                
                
                    [_mulchooseTabView createFootViewWithAnswer:labelll andWithOtherAnswer:correctLabel AndWith:YES andWithCorrent:NO andResolve:resloveLabel];
                    
               // }

            }else if (self.IsPractice){
                [_mulchooseTabView createFootViewWithAnswer:correctLabel andWithOtherAnswer:labelll AndWith:YES andWithCorrent:NO andResolve:resloveLabel];

            }

            
            

            
            /**
             *  回答发送通知隐藏TableViewfootview
             */
            [[NSNotificationCenter defaultCenter]postNotificationName:@"hideFootView" object:nil];

        }
        
        [self.errorAnsArr addObject:title];
        
        
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in self.errorAnsArr) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        
        errorLabel.text = [NSString stringWithFormat:@"%ld",listAry.count];

    }
    
    
 
    
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //HQLAppLog(@"点击%ld",indexPath.row);
    
}

#pragma mark --UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // 上, 左, 下, y右
}


#pragma mark --设置每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT-50);
}

//定义每个UICollectionView 的 margin
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}






-(void)createTitileView{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 40)];
    self.navigationItem.titleView = titleView;
    
    timeLabel = [[UILabel alloc]init];
    [titleView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).offset = (SCREEN_WIDTH/2-80);
        make.centerY.equalTo(titleView);
    }];
    [self startCountTimer];
}

-(void)startCountTimer{
    _Current = Ktimer;
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownStart) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_countTimer forMode:NSDefaultRunLoopMode];
    [_countTimer setFireDate:[NSDate date]];
    
}
/**
 *  开始倒计时
 */
-(void)countDownStart{
    
    if (_Current !=0) {

        timeLabel.text = [NSString stringWithFormat:@"倒计时:%ld",_Current];
        _Current--;
    }else{
        [_countTimer invalidate];
        _countTimer = nil;
        timeLabel.text = [NSString stringWithFormat:@"倒计时:0"];
     //   HQLAppLog(@"交卷了啊");
    }
}

#pragma mark - 字典转json
-(NSString *)changeJsonStrWith:(NSMutableArray *)hanArr{

    //将字典转为json格式的数据
    // NSJSONWritingPrettyPrinted 转化的json数据有换位符 /n
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:hanArr options:0 error:nil];
    NSMutableData *data = [NSMutableData dataWithData:jsonData];
    NSString *JsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return JsonStr;
    
}

-(NSMutableArray *)trueAnsArr{
    if (!_trueAnsArr) {
        _trueAnsArr = [NSMutableArray array];
    }
    return _trueAnsArr;
}
-(NSMutableArray *)errorAnsArr{
    if (!_errorAnsArr) {
        _errorAnsArr = [NSMutableArray array];
    }
    return _errorAnsArr;
}

@end
