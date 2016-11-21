//
//  ViewController.m
//  collectionAndTableView
//
//  Created by 纵索科技 on 16/11/19.
//  Copyright © 2016年 贺乾龙. All rights reserved.
//

#import "ViewController.h"
#import "tadayExamViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我是标题";
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(60, 120, 50, 70)];
    [btn setTitle:@"进入" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn addTarget:self action:@selector(optenClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    

}


-(void)optenClick{

    tadayExamViewController *vc = [[tadayExamViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
