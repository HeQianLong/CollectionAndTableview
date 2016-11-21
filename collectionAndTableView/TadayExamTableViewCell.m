//
//  TadayExamTableViewCell.m
//  ExaminationPower
//
//  Created by 纵索科技 on 16/9/24.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import "TadayExamTableViewCell.h"
#import "WHC_StackView.h"
#import "UIView+WHC_AutoLayout.h"
#define HorizonGap 15
#define TilteBtnGap 10
#define ColorRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface TadayExamTableViewCell (){

    NSArray *_chooseArr;
    
    NSArray *_noChooseArr;

}

@end

@implementation TadayExamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    CGContextSetStrokeColorWithColor(context, ColorRGB(0xf7f7f7).CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5));
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle: style reuseIdentifier:reuseIdentifier]) {
        
        [self createCellView];
    }
    
    return self;
}

-(void)createCellView{
    
    self.connentLabel = [[UILabel alloc]init];
   // self.connentLabel.font = FONT(17);
    self.connentLabel.textColor = [UIColor darkGrayColor];
    self.connentLabel.text = @"016年菲华先生、菲华小姐选拔赛结果当地时间7月31日晚出炉，摘下菲律宾华人小姐后冠的吴茜莉妙答参议员针对“南海仲裁”的提问年仅20岁的王汉民，则在帅哥阵中杀出重围，当选菲华先生。";

    [self.contentView addSubview:self.connentLabel];
//    [self.connentLabel whc_LeftSpace:10 toView:self.selectBtn];
//    [self.connentLabel whc_TopSpace:5 toView:self.contentView];
    [self.connentLabel whc_RightSpace:10];
    [self.connentLabel whc_LeftSpace:50];
    [self.connentLabel whc_TopSpace:10];
    [self.connentLabel whc_HeightAuto];

    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.selectBtn setImage:[UIImage imageNamed:@"option_n"] forState:UIControlStateNormal];
//    [self.selectBtn setImage:[UIImage imageNamed:@"option_y"] forState:UIControlStateSelected];
    self.selectBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.selectBtn];
    [self.selectBtn whc_RightSpace:15 toView:self.connentLabel];
    [self.selectBtn whc_TopSpace:10];
    [self.selectBtn whc_Size:CGSizeMake(25, 25)];


}


-(void)UpdateCellWithState:(BOOL)select{
    
    self.selectBtn.selected = select;
    _isSelected = select;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
