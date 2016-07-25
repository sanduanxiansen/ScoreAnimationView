//
//  DNJScoreHeaderView.m
//  dnj
//
//  Created by CC on 16/7/21.
//  Copyright © 2016年 CC. All rights reserved.
//

#import "ScoreView.h"
#import "Masonry.h"
#import "BlocksKit+UIKit.h"
#define WeakObj(o) __weak typeof(o) o##Weak = o;

#define colorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ScoreView ()

@property (nonatomic, strong) AnimateButton *scoreButton;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, assign) BOOL isInit;

@end

@implementation ScoreView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    WeakObj(self)
    
    self.backgroundColor = colorFromRGB(0x2594e9);
    
    _scoreButton = [[AnimateButton alloc] init];
    [self addSubview:_scoreButton];
    [_scoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(17);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_subBtn setImage:[UIImage imageNamed:@"score_minus"] forState:UIControlStateNormal];
    [_subBtn setImage:[UIImage imageNamed:@"score_minus_disable"] forState:UIControlStateDisabled];
    [self addSubview:_subBtn];
    [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_scoreButton);
        make.right.equalTo(_scoreButton.mas_left).offset(-14);
    }];
    [_subBtn bk_whenTapped:^{
        
        selfWeak.score --;
        [selfWeak.scoreButton animationWithIsAdd:NO];
    }];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setImage:[UIImage imageNamed:@"score_plus"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"score_plus_disable"] forState:UIControlStateDisabled];
    [self addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_scoreButton);
        make.left.equalTo(_scoreButton.mas_right).offset(14);
    }];
    [_addBtn bk_whenTapped:^{
        
        selfWeak.score ++;
        [selfWeak.scoreButton animationWithIsAdd:YES];
    }];
    
    UILabel *title = [UILabel new];
    title.text = @"评分";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:15];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.height.equalTo(@15);
        make.top.equalTo(_scoreButton.mas_bottom).offset(15);
    }];

    [self addRac];
}

- (void)setScore:(NSInteger)score {
    _score = score;
    self.subBtn.enabled = !(self.score == 1);
    self.addBtn.enabled = !(self.score == 10);
    if (!_isInit) {
        [self.scoreButton setInitProgress:score];
        _isInit = !_isInit;
    }
}

- (void)addRac {
    WeakObj(self)
    
    [self bk_addObserverForKeyPath:@"score" task:^(id target) {
        [selfWeak.scoreButton setTitle:@(selfWeak.score).stringValue forState:UIControlStateNormal];
    }];
}

@end


@interface AnimateButton ()

@property (nonatomic, strong) CAShapeLayer *circleLayer1;
@property (nonatomic, strong) CAShapeLayer *circleLayer2;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) CGFloat startProgress;
@property (nonatomic, assign) CGFloat endProgress;

@property (nonatomic, assign) CGFloat duration;
@end

@implementation AnimateButton


- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self drawBackBgCircle];
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:45];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setInitProgress:(NSInteger)score {
    self.startProgress = 0;
    self.endProgress = (score-1)/10.f;
    self.duration = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self animationWithIsAdd:YES];
    });
}

- (void)animationWithIsAdd:(BOOL)isAdd {
    
    self.endProgress = isAdd ? (self.endProgress+0.1):(self.endProgress-0.1);
    
    CGPoint center = [self center];
    CGFloat radius = 50;
    CGFloat startAngle = -90;
    
    if (!self.circleLayer1) {
        UIBezierPath *path1 = [[UIBezierPath alloc] init];
        [path1 addArcWithCenter:center radius:radius- 9 startAngle:[self degreesToRadiansWithValue:startAngle] endAngle:[self degreesToRadiansWithValue:startAngle + 360] clockwise:YES];
        
        UIBezierPath *path2 = [[UIBezierPath alloc] init];
        [path2 addArcWithCenter:center radius:radius- 4 startAngle:[self degreesToRadiansWithValue:startAngle] endAngle:[self degreesToRadiansWithValue:startAngle + 360] clockwise:YES];
        
        _circleLayer1 = [[CAShapeLayer alloc] init];
        _circleLayer1.path = path1.CGPath;
        _circleLayer1.fillColor = [UIColor clearColor].CGColor;
        _circleLayer1.strokeColor = colorFromRGB(0x4fa9ed).CGColor;
        _circleLayer1.lineWidth = 5;
        
        _circleLayer2 = [[CAShapeLayer alloc] init];
        _circleLayer2.path = path2.CGPath;
        _circleLayer2.fillColor = [UIColor clearColor].CGColor;
        _circleLayer2.strokeColor = colorFromRGB(0xb0d9f7).CGColor;
        _circleLayer2.lineWidth = 4;
        
        [_circleLayer1 removeAllAnimations];
        [_circleLayer1 removeFromSuperlayer];
        
        [_circleLayer2 removeAllAnimations];
        [_circleLayer2 removeFromSuperlayer];
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = @(self.startProgress);
    animation.toValue = @(self.endProgress);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [_circleLayer1 addAnimation:animation forKey:@"drawCircleAnimation1"];
    [_circleLayer2 addAnimation:animation forKey:@"drawCircleAnimation2"];
    
    self.startProgress = self.endProgress;
    if (self.duration != 0.5) self.duration = 0.5;
    
    [self.layer addSublayer:_circleLayer1];
    [self.layer addSublayer:_circleLayer2];
}

- (void)drawBackBgCircle {
    CGPoint center = [self center];
    CGFloat radius = 50;
    CGFloat startAngle = -90;
    
    UIBezierPath *path1 = [[UIBezierPath alloc] init];
    [path1 addArcWithCenter:center radius:radius- 9 startAngle:[self degreesToRadiansWithValue:startAngle] endAngle:[self degreesToRadiansWithValue:startAngle + 360] clockwise:YES];
    
    UIBezierPath *path2 = [[UIBezierPath alloc] init];
    [path2 addArcWithCenter:center radius:radius- 4 startAngle:[self degreesToRadiansWithValue:startAngle] endAngle:[self degreesToRadiansWithValue:startAngle + 360] clockwise:YES];
    
    CAShapeLayer *circleLayer1 = [[CAShapeLayer alloc] init];
    circleLayer1.path = path1.CGPath;
    circleLayer1.fillColor = [UIColor clearColor].CGColor;
    circleLayer1.strokeColor = colorFromRGB(0x3b9feb).CGColor;
    circleLayer1.lineWidth = 5;
    
    CAShapeLayer *circleLayer2 = [[CAShapeLayer alloc] init];
    circleLayer2.path = path2.CGPath;
    circleLayer2.fillColor = [UIColor clearColor].CGColor;
    circleLayer2.strokeColor = colorFromRGB(0x7cbff2).CGColor;
    circleLayer2.lineWidth = 4;
    
    [self.layer addSublayer:circleLayer1];
    [self.layer addSublayer:circleLayer2];
}

- (CGPoint)center {
    return CGPointMake(50, 50);
}

- (CGFloat)degreesToRadiansWithValue:(CGFloat)value {
    return value * M_PI / 180.f;
}

@end