//
//  ViewController.m
//  KBCoinParabolaViewSimple
//
//  Created by 高文明 on 14/12/6.
//  Copyright (c) 2014年 北京浙星信息技术有限公司. All rights reserved.
//

#import "ViewController.h"

#import "KBCoinParabolaView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    KBCoinParabolaView *remind = [[KBCoinParabolaView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, self.view.frame.size.width/3, self.view.frame.size.width/3, self.view.frame.size.height/3)];

    [self.view addSubview:remind];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =  CGRectMake(remind.frame.origin.x, remind.frame.origin.y+remind.frame.size.height+44, remind.frame.size.width, 44);
    [btn setTitle:@"重置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(getCoinAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}

- (void)getCoinAction:(UIButton *)btn
{
    //"立即打开"按钮从视图上移除
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[KBCoinParabolaView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    KBCoinParabolaView *newRemind = [[KBCoinParabolaView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, self.view.frame.size.width/3, self.view.frame.size.width/3, self.view.frame.size.height/3)];
    
    [self.view addSubview:newRemind];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
