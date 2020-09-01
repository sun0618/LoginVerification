//
//  ViewController.m
//  LoginVerification
//
//  Created by yang.sun on 2020/8/28.
//  Copyright © 2020 sun. All rights reserved.
//

#import "ViewController.h"

#import "LoginSliderView.h"

#pragma mark -- 屏幕
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@property (nonatomic,strong)UIButton *puzzleButton;

@property (nonatomic,strong)UIButton *randomCharButton;

@property (nonatomic,strong)UIButton *sliderButton;

@property (nonatomic,strong)LoginSliderView *loginSliderView;

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

-(void)initView {
    
    self.puzzleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.puzzleButton.frame = CGRectMake(50, 200, SCREEN_WIDTH - 100, 45);
    self.puzzleButton.tag = 0;
    self.puzzleButton.layer.cornerRadius = 10;
    [self.puzzleButton setBackgroundColor:[UIColor orangeColor]];
    [self.puzzleButton setTitle:@"拼图验证" forState:UIControlStateNormal];
    [self.puzzleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.puzzleButton];
    
    self.randomCharButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.randomCharButton.frame = CGRectMake(50, 260, SCREEN_WIDTH - 100, 45);
    self.randomCharButton.tag = 1;
    self.randomCharButton.layer.cornerRadius = 10;
    [self.randomCharButton setBackgroundColor:[UIColor orangeColor]];
    [self.randomCharButton setTitle:@"随机字符验证" forState:UIControlStateNormal];
    [self.randomCharButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.randomCharButton];
    
    self.sliderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sliderButton.frame = CGRectMake(50, 320, SCREEN_WIDTH - 100, 45);
    self.sliderButton.tag = 2;
    self.sliderButton.layer.cornerRadius = 10;
    [self.sliderButton setBackgroundColor:[UIColor orangeColor]];
    [self.sliderButton setTitle:@"滑动解锁" forState:UIControlStateNormal];
    [self.sliderButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sliderButton];
   
    self.puzzleButton.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH - 100, 0);
    self.randomCharButton.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH + 100, 0);
    self.sliderButton.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH - 100, 0);
    
    /*
     Duration ： 动画时长
     delay：开始时间
     usingSpringWithDamping ：范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显（最好能被Duration除尽）
     initialSpringVelocity： 表示初始的速度，数值越大一开始移动越快
     options：动画效果
     */
//    动画效果
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.25 initialSpringVelocity:3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.puzzleButton.transform = CGAffineTransformIdentity;
        self.randomCharButton.transform = CGAffineTransformIdentity;
        self.sliderButton.transform = CGAffineTransformIdentity;
    } completion:nil];
}

-(void)buttonClick:(UIButton *)button {
    _loginSliderView = [[LoginSliderView alloc] initWithFrame:self.view.bounds];
    [_loginSliderView show:button.tag];
    
}

@end

