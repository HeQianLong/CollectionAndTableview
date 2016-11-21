//
//  tadayExamViewController.h
//  ExaminationPower
//
//  Created by 纵索科技 on 16/9/24.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tadayExamViewController : UIViewController


typedef void(^chooseAnswerTagBlock)(NSString *chooseAnswerStr);

/**
 *  如果是练习则会有答案解析
 */
@property(nonatomic,assign)BOOL IsPractice;

/**
 *  历史模考只有答题卡，无解析和交卷选项
 */
@property(nonatomic,assign)BOOL isHistory;

/**
 *  题库分类的id
 */
@property(nonatomic,strong)NSString *categoryId;

/**
 * 参加 今日模考
 */
@property(nonatomic,assign)BOOL IsTadayExam;
/**
 *  获取今日模考题目
 */
@property(nonatomic,strong)NSString *isJoinTaday;
/**
 *  今日模考和历史模考需要
 */
@property(nonatomic,strong)NSString *examSeq;

/**
 *  个人中心我的错题
 */
@property(nonatomic,assign)BOOL myPreice;

@property(nonatomic,strong)chooseAnswerTagBlock chooseAnswerTagBlock;
@end
