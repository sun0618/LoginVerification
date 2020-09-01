//
//  LoginSliderView.m
//  LoginVerification
//
//  Created by yang.sun on 2020/8/28.
//  Copyright © 2020 sun. All rights reserved.
//

#import "LoginSliderView.h"

#pragma mark -- 屏幕
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//iPhone宽适配
#define WSXFrom8(x) ([[UIScreen mainScreen] bounds].size.width / 375.0 * x)

// 颜色定义
#define kColor(r,g,b) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0]
#define kColorA(r,g,b,a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

@interface LoginSliderView ()

@property (nonatomic,assign)ViewType viewType;

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *failLabel;

@property (nonatomic,assign)CGFloat backImageWhidth;
@property (nonatomic,assign)CGFloat leftWhidth;

@property (nonatomic,assign)CGFloat imageWhidth;
@property (nonatomic,assign)CGFloat leftImageWhidth;

@property (nonatomic,assign)CGPoint randomPoint;

@property(nonatomic,strong)NSTimer *myTimer;

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIImageView *leftImageView;
@property (nonatomic,strong)UIView *sliderBackView;
@property (nonatomic,strong)UIView *progressView;
@property (nonatomic,strong)UIImageView *thumbImgView;
@property (nonatomic,strong)UIView *hintView;

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,copy)NSString *titleString;
@property (nonatomic,copy)NSString *chooseString;

@end

@implementation LoginSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:SCREEN_BOUNDS];
    if (self) {
    }
    return self;
}

#pragma mark - 初始化
-(void)show:(ViewType)viewType {
    
    _viewType = viewType;
    
    [self initData];
    [self initView];

    //    拼图验证
    if (viewType == ViewTypePuzzle) {
        [self initPuzzleView];
    } else if (viewType == ViewTypeSlider) {
        [self initSliderView];
    } else if (viewType == ViewTypeRandomChar) {
        [self initCharView];
        
    }
    
}

#pragma mark - 数据初始化
-(void)initData {
    
    //    背景图片宽
    _backImageWhidth = WSXFrom8(260);
    //    左边距
    _leftWhidth = WSXFrom8(20);
    
    //    拼图验证截图大小
    _imageWhidth = WSXFrom8(50);
    //    拼图验证截图初始化左边距
    _leftImageWhidth = WSXFrom8(10);
    
    //    记录位置
    _randomPoint = CGPointZero;
}

#pragma mark - 通用背景
-(void)initView {
    
    /***************************背景模糊*********************************/
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.bounds;
    visualEffectView.alpha = 0.7;
    [self addSubview:visualEffectView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(WSXFrom8(75 / 2), SCREEN_HEIGHT / 2 - WSXFrom8(150), WSXFrom8(300), WSXFrom8(300))];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.clipsToBounds = YES;
    [self addSubview:_backView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(WSXFrom8(150), SCREEN_HEIGHT / 2 + WSXFrom8(180), WSXFrom8(75), WSXFrom8(45));
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor blueColor]];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    
    _failLabel = [[UILabel alloc] initWithFrame:CGRectMake(WSXFrom8(20), WSXFrom8(300), WSXFrom8(200), WSXFrom8(30))];
    _failLabel.textColor = [UIColor redColor];
    _failLabel.text = @"小伙子，不行啊!";
    [_backView addSubview:_failLabel];
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.frame = CGRectMake(WSXFrom8(250), WSXFrom8(250), WSXFrom8(32), WSXFrom8(32));
    [changeButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [changeButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:changeButton];
    
    if (_viewType == ViewTypeSlider) {
        changeButton.hidden = YES;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}


#pragma mark -
#pragma mark === 拼图验证 ===
#pragma mark -
-(void)initPuzzleView {
    
    //    背景图片
    _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backImage"]];
    _backImageView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(20), _backImageWhidth, WSXFrom8(150));
    [_backView addSubview:_backImageView];
    
    [self initRandPuzzleView];
    
    //    滑块背景
    _sliderBackView = [[UIView alloc] initWithFrame:CGRectMake(WSXFrom8(20), WSXFrom8(200), _backImageWhidth, WSXFrom8(20))];
    _sliderBackView.backgroundColor = kColor(222, 222, 222);
    _sliderBackView.layer.cornerRadius = WSXFrom8(10);
    [_backView addSubview:_sliderBackView];
    
    //    已经滑动部分
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(WSXFrom8(20), WSXFrom8(200), WSXFrom8(30), WSXFrom8(20))];
    _progressView.backgroundColor = [UIColor blueColor];
    _progressView.layer.cornerRadius = WSXFrom8(10);
    [_backView addSubview:_progressView];
    
    //    滑块
    _thumbImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WSXFrom8(30), WSXFrom8(185), _imageWhidth, _imageWhidth)];
    _thumbImgView.image = [UIImage imageNamed:@"slide_buttonn"];
    _thumbImgView.userInteractionEnabled = YES;
    [_backView addSubview:_thumbImgView];
    //    添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_thumbImgView addGestureRecognizer:pan];
    
    
    //    滑块上引导动画
    _hintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WSXFrom8(60), WSXFrom8(20))];
    [_sliderBackView addSubview:_hintView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)kColorA(222, 222, 222, 0).CGColor, (__bridge id)kColorA(255, 0, 0, 0.7).CGColor,(__bridge id)kColorA(222, 222, 222, 0).CGColor];
    gradientLayer.locations = @[@0, @0.5, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = _hintView.bounds;
    [_hintView.layer insertSublayer:gradientLayer atIndex:0];
    
    [self cycingHintView:YES];
}

#pragma mark - 拼图验证上面随机位置生成
-(void)initRandPuzzleView {
    
    //    移除上面子视图
    [_backImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_backImageView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    [self getRandomPoint];
    
    UIBezierPath *path = [self getCodePath];
    
    //    在背景图片上生成一个目标位置
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(self.randomPoint.x, self.randomPoint.y, WSXFrom8(50), WSXFrom8(50));
    maskLayer.path = path.CGPath;
    maskLayer.strokeColor = [UIColor orangeColor].CGColor;
    maskLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    [_backImageView.layer addSublayer:maskLayer];
    
    //    左边可滑动小图
    UIImage *leftImage = [self imageFromImage:_backImageView.image inRect:CGRectMake(self.randomPoint.x, self.randomPoint.y, _imageWhidth, _imageWhidth)];
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    leftImageView.frame = CGRectMake(WSXFrom8(10), self.randomPoint.y, _imageWhidth, _imageWhidth);
    [_backImageView addSubview:leftImageView];
    leftImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    // 设置阴影偏移量
    leftImageView.layer.shadowOffset = CGSizeMake(0,0);
    // 设置阴影透明度
    leftImageView.layer.shadowOpacity = 1;
    // 设置阴影半径
    leftImageView.layer.shadowRadius = 5;
    leftImageView.clipsToBounds = NO;
    
    //    截取图片
    CGSize size = CGSizeMake(_imageWhidth, _imageWhidth);
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //实现裁剪
    [path addClip];
    //把图片绘制到上下文中
    [leftImage drawAtPoint:CGPointMake(0, 0)];
    //从上下文中取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    leftImageView.image = newImage;
    _leftImageView = leftImageView;
}

#pragma mark - 生成随机位置
-(void)getRandomPoint {
    //    图片大小260*150
    //    中间截图大小50*50
    //    从80到80+130之间选一个点当起点
    CGFloat x = (arc4random() % 130) + 80;
    //    从0到100之间选一个点当起点
    CGFloat y = (arc4random() % 100);
    
    self.randomPoint = CGPointMake(WSXFrom8(x), WSXFrom8(y));
    
}

#pragma mark - 生产一个花边的Bezier曲线路径
-(UIBezierPath *)getCodePath {
    
    CGFloat codeSize = WSXFrom8(40);
    CGFloat offset = WSXFrom8(10);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, offset)];
    [path addLineToPoint:CGPointMake(codeSize * 0.5 - offset,offset)];
    //    曲线
    [path addQuadCurveToPoint:CGPointMake(codeSize * 0.5 + offset, offset) controlPoint:CGPointMake(codeSize * 0.5, -offset*2 + offset)];
    [path addLineToPoint:CGPointMake(codeSize, offset)];
    
    [path addLineToPoint:CGPointMake(codeSize,codeSize*0.5-offset + offset)];
    [path addQuadCurveToPoint:CGPointMake(codeSize, codeSize*0.5+offset + offset) controlPoint:CGPointMake(codeSize+offset*2, codeSize*0.5 + offset)];
    [path addLineToPoint:CGPointMake(codeSize, codeSize + offset)];
    
    [path addLineToPoint:CGPointMake(codeSize*0.5+offset,codeSize + offset)];
    [path addQuadCurveToPoint:CGPointMake(codeSize*0.5-offset, codeSize + offset) controlPoint:CGPointMake(codeSize*0.5, codeSize-offset*2 + offset)];
    [path addLineToPoint:CGPointMake(0, codeSize + offset)];
    
    [path addLineToPoint:CGPointMake(0,codeSize*0.5+offset + offset)];
    [path addQuadCurveToPoint:CGPointMake(0, codeSize*0.5-offset + offset) controlPoint:CGPointMake(0+offset*2, codeSize*0.5 + offset)];
    [path addLineToPoint:CGPointMake(0, offset)];
    
    [path stroke];
    return path;
}

#pragma mark - 根据图片和路径在图片上扣一个小图出来
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

#pragma mark - 手势处理
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    [self cycingHintView:NO];
    
    CGPoint point = [pan translationInView:_thumbImgView];
    //    手势结束
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        //        滑动位置跟目标位置重复度误差在+—5之内算通过
        if (point.x > (_randomPoint.x - WSXFrom8(15)) && point.x < (_randomPoint.x - WSXFrom8(5))) {
            [self.myTimer invalidate];
            self.myTimer = nil;
            [self removeFromSuperview];
        } else {
            //            滑动位置误差过大，提示错误
            [self cycingHintView:YES];
            [self faileHandle];
            _progressView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(200), WSXFrom8(30), WSXFrom8(20));
            _thumbImgView.frame = CGRectMake(WSXFrom8(30), WSXFrom8(185), _imageWhidth, _imageWhidth);
            _leftImageView.frame = CGRectMake(WSXFrom8(10), self.randomPoint.y, _imageWhidth, _imageWhidth);
        }
        
    } else {
        
        //        因为起始位置是10，所以小于10就滑出去了，将其设置为在0位置
        if (point.x < -WSXFrom8(10)) {
            
            _progressView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(200), WSXFrom8(20), WSXFrom8(20));
            _thumbImgView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(185), _imageWhidth, _imageWhidth);
            _leftImageView.frame = CGRectMake(0, self.randomPoint.y, _imageWhidth, _imageWhidth);
            
            //            大于200就超过右边了滑出去了，将其设置为在210位置
        } else if ( point.x > WSXFrom8(200)) {
            
            _progressView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(200), WSXFrom8(260), WSXFrom8(20));
            _thumbImgView.frame = CGRectMake(WSXFrom8(230), WSXFrom8(185), _imageWhidth, _imageWhidth);
            _leftImageView.frame = CGRectMake(WSXFrom8(210), self.randomPoint.y, _imageWhidth, _imageWhidth);
            
        } else {
            
            _progressView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(200), WSXFrom8(30) + point.x, WSXFrom8(20));
            _thumbImgView.frame = CGRectMake(WSXFrom8(30) + point.x, WSXFrom8(185), _imageWhidth, _imageWhidth);
            
            _leftImageView.frame = CGRectMake(WSXFrom8(10) + point.x, self.randomPoint.y, _imageWhidth, _imageWhidth);
            
        }
        
    }
}


#pragma mark -
#pragma mark === 滑动解锁 ===
#pragma mark -
//算是拼图验证简化版，为了方便理解，抽离出来，可以直接在拼图验证界面上处理
-(void)initSliderView {
    
    //    背景图片
    _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backImage"]];
    _backImageView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(20), _backImageWhidth, WSXFrom8(150));
    [_backView addSubview:_backImageView];
    
    _imageWhidth = WSXFrom8(40);
    
    //    滑块背景
    _sliderBackView = [[UIView alloc] initWithFrame:CGRectMake(WSXFrom8(20), WSXFrom8(200), WSXFrom8(260), WSXFrom8(40))];
    _sliderBackView.backgroundColor = kColor(222, 222, 222);
    _sliderBackView.layer.cornerRadius = WSXFrom8(20);
    _sliderBackView.clipsToBounds = YES;
    [_backView addSubview:_sliderBackView];
    
    //    滑块上动画
    _hintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WSXFrom8(50), WSXFrom8(40))];
    [_sliderBackView addSubview:_hintView];
    
    //   已经滑动部分
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WSXFrom8(30), WSXFrom8(40))];
    _progressView.backgroundColor = [UIColor blueColor];
    [_sliderBackView addSubview:_progressView];
    
    //    滑块
    _thumbImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WSXFrom8(30), WSXFrom8(200), _imageWhidth, _imageWhidth)];
    _thumbImgView.image = [UIImage imageNamed:@"slide_buttonn"];
    _thumbImgView.userInteractionEnabled = YES;
    [_backView addSubview:_thumbImgView];
    
    //    引导动画
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSlider:)];
    [_thumbImgView addGestureRecognizer:pan];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)kColorA(222, 222, 222, 0).CGColor, (__bridge id)kColorA(255, 0, 0, 0.7).CGColor,(__bridge id)kColorA(222, 222, 222, 0).CGColor];
    gradientLayer.locations = @[@0, @0.5, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = _hintView.bounds;
    [_hintView.layer insertSublayer:gradientLayer atIndex:0];
    
    [self cycingHintView:YES];
}

#pragma mark - 滑动解锁手势处理
- (void)panSlider:(UIPanGestureRecognizer *)pan {
    
    [self cycingHintView:NO];
    
    CGPoint point = [pan translationInView:_thumbImgView];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
//
//        结束了回到原位置
        [self cycingHintView:YES];
        [self faileHandle];
        _progressView.frame = CGRectMake(0, 0, WSXFrom8(30), WSXFrom8(40));
        _thumbImgView.frame = CGRectMake(WSXFrom8(30), WSXFrom8(200), _imageWhidth, _imageWhidth);
        
    } else {
        
        //        因为起始位置是10，所以小于10就滑出去了，将其设置为在0位置
        if (point.x < -WSXFrom8(10)) {
            
            _progressView.frame = CGRectMake(0, 0, WSXFrom8(20), WSXFrom8(40));
            _thumbImgView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(200), _imageWhidth, _imageWhidth);
    
        //            大于210，说明滑到头了，成功
        } else if ( point.x > WSXFrom8(210)) {
            
            [self.myTimer invalidate];
            self.myTimer = nil;
            [self removeFromSuperview];
            
        } else {
            
            _progressView.frame = CGRectMake(0, 0, WSXFrom8(30) + point.x, WSXFrom8(40));
            _thumbImgView.frame = CGRectMake(WSXFrom8(30) + point.x, WSXFrom8(200), _imageWhidth, _imageWhidth);
            
        }
        
    }

}


#pragma mark -
#pragma mark === 随机字符验证 ===
#pragma mark -
-(void)initCharView {
    
    //    背景图片
    _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backImage"]];
    _backImageView.frame = CGRectMake(WSXFrom8(20), WSXFrom8(20), _backImageWhidth, WSXFrom8(150));
    _backImageView.userInteractionEnabled = YES;
    [_backView addSubview:_backImageView];
    
    //    提示文字
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WSXFrom8(20), WSXFrom8(180), WSXFrom8(260), WSXFrom8(30))];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:_titleLabel];
    
    [self initRandomCharView];
    
}

-(void)initRandomCharView {
    
    NSInteger index = 8;
    NSString *chooseText = @"";
    NSMutableArray *dataArray = [NSMutableArray array];
//    生产8个汉字
    while (index) {
        
        NSString *randStr = [self getRandomChinese];
        if (![dataArray containsObject:randStr]) {
            [dataArray addObject:randStr];
            if (index > 4) {
                chooseText = [chooseText stringByAppendingFormat:@"%@",randStr];
            }
            index --;
        }
        
    }
    
//    提示文字显示
    NSMutableAttributedString *tipsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"请按顺序点击 %@ 完成验证",chooseText]];
    [tipsString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(7, 4)];
    _titleLabel.attributedText = tipsString;

    _titleString = chooseText;
    _chooseString = @"";
    _randomPoint = CGPointZero;
    
    //    移除上面子视图
    [_backImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    生成随机按钮
    for (NSInteger i = 0; i < 8; i ++) {
        NSInteger index = arc4random() % dataArray.count;
        NSString *titString = dataArray[index];
        [dataArray removeObject:titString];
        
        _randomPoint = [self getRanPoint:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_randomPoint.x, _randomPoint.y, WSXFrom8(32), WSXFrom8(32));
        button.tag = i;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.cornerRadius = WSXFrom8(16);
        [button setTitle:titString forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.transform = CGAffineTransformMakeRotation(M_PI / 100.0 * (arc4random() % 200));
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backImageView addSubview:button];
    }
}


#pragma mark - 生成一个随机汉字
-(NSString *)getRandomChinese {
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
    NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
    NSInteger number = (randomH<<8)+randomL;
    NSData *data = [NSData dataWithBytes:&number length:2];

    NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];

    return string;
    
}

#pragma mark - 生产一个随机起始位置
-(CGPoint)getRanPoint:(NSInteger)index {
    
    CGFloat defaultW = (index % 4 + 1) * WSXFrom8(65);
    CGFloat defaultH = index > 3 ? WSXFrom8(75) : 0;
    
    CGPoint randomPoint = CGPointZero;
    
    CGFloat fromX = (index % 4) == 0 ? 0 : (_randomPoint.x + WSXFrom8(32));
    
    randomPoint.x = [self getRandomNumberFrom:fromX To:defaultW - WSXFrom8(32)];
    randomPoint.y = [self getRandomNumberFrom:defaultH To:defaultH + WSXFrom8(75) - WSXFrom8(32)];
    
    return randomPoint;
}

-(CGFloat)getRandomNumberFrom:(CGFloat)from To:(CGFloat)to {
    
    NSInteger scope = [[NSString stringWithFormat:@"%lf",floorf(to - from)] integerValue];
    
    NSInteger rand = arc4random();
    
    CGFloat number = (rand % scope) + from;
    
    return number;
    
}

#pragma mark - 选择处理
-(void)buttonClick:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
        [button setBackgroundColor:[UIColor orangeColor]];
        NSLog(@"%@",button.titleLabel.text);
        
        _chooseString = [_chooseString stringByAppendingFormat:@"%@",button.titleLabel.text];
        if (_chooseString.length >= 4) {
            if ([_chooseString isEqualToString:_titleString]) {
                
                [self removeFromSuperview];
                
            } else {
                [self faileHandle];
                [self initRandomCharView];
            }
        }
        
    }
}

#pragma mark -
#pragma mark === 通用 ===
#pragma mark -

#pragma mark - 引导手势是否开启
-(void)cycingHintView:(BOOL)isSlide {
    
    if (isSlide) {
        if (!self.myTimer) {
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(upData) userInfo:nil repeats:YES];
        } else {
            [self.myTimer setFireDate:[NSDate distantPast]];
        }
    } else {
        [self.myTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)upData {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.hintView.transform = CGAffineTransformMakeTranslation(WSXFrom8(200), 0);
        
    } completion:^(BOOL finished) {
        
        self.hintView.transform = CGAffineTransformIdentity;
        
    }];
}

#pragma mark - 退出
-(void)cancelButtonClick:(UIButton *)button {
    [self.myTimer invalidate];
    self.myTimer = nil;
    [self removeFromSuperview];
}

#pragma mark - 刷新
-(void)refreshButtonClick:(UIButton *)button {
    
    if (_viewType == ViewTypePuzzle) {
        [self initRandPuzzleView];
    } else if (_viewType == ViewTypeRandomChar) {
        [self initRandomCharView];
        
    }
}

#pragma mark - 失败提示
-(void)faileHandle {
    
    _failLabel.frame = CGRectMake(WSXFrom8(20), WSXFrom8(250), WSXFrom8(200), WSXFrom8(30));
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(boom) object:nil];
    
    [self performSelector:@selector(boom) withObject:nil afterDelay:4];
    
}

-(void)boom {
    _failLabel.frame = CGRectMake(WSXFrom8(20), WSXFrom8(300), WSXFrom8(200), WSXFrom8(30));
}

@end
