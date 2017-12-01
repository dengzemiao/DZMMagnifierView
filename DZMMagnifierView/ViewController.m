//
//  ViewController.m
//  DZMMagnifierView
//
//  Created by 邓泽淼 on 2017/12/1.
//  Copyright © 2017年 邓泽淼. All rights reserved.
//

#import "ViewController.h"
#import "DZMMagnifierView.h"

@interface ViewController ()

@property (nonatomic,weak) DZMMagnifierView *magnifierView;

@property(nonatomic, strong) UILongPressGestureRecognizer *longGes;

@property(nonatomic, weak) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"违法数据阿萨德哈师大就爱上的空间按时间电话卡实践活动按时间汇顶科技爱仕达看见爱上打卡十多块加上快递";
    label.numberOfLines = 0;
    label.userInteractionEnabled = YES;
    label.backgroundColor = [UIColor greenColor];
    label.font = [UIFont systemFontOfSize:17];
    label.frame = CGRectMake(10, 100, 200, 200);
    [self.view addSubview:label];
    self.label = label;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.label addGestureRecognizer:longPress];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    
    CGPoint point = [longPress locationInView:self.label.window];
     
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        self.magnifierView = [DZMMagnifierView magnifierView];
        
        self.magnifierView.targetWindow = self.label.window;
        
        self.magnifierView.targetPoint = point;
        
    }else if (longPress.state == UIGestureRecognizerStateChanged) {
        
        self.magnifierView.targetPoint = point;
        
    }else{
        
        self.magnifierView.targetPoint = point;
        
        [self.magnifierView remove];
    }
}

@end
