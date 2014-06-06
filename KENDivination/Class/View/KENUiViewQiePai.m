//
//  KENUiViewQiePai.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-21.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewQiePai.h"
#import "KENModel.h"

@interface KENUiViewQiePai ()

@property (nonatomic, strong) UIImageView* paiTop;
@property (nonatomic, strong) UIImageView* paiMiddle;
@property (nonatomic, strong) UIImageView* paiBottom;

@end


@implementation KENUiViewQiePai

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeQiePai;
        
        [self initView];
    }
    return self;
}

-(void)initView{
    _paiBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiBottom.center = CGPointMake(160, 160);
    _paiBottom.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:_paiBottom];
    
    _paiTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiTop.center = CGPointMake(160, 160);
    _paiTop.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:_paiTop];
    
    _paiMiddle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiMiddle.center = CGPointMake(160, 160);
    _paiMiddle.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:_paiMiddle];
    
    [self startFirstAnimation];
}

-(void)timerOut{
    [[KENModel shareModel] playVoiceByType:KENVoiceXiPai];
}

-(void)startFirstAnimation{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiMiddle.center = CGPointMake(160, 240);
        _paiBottom.center = CGPointMake(160, 240);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                            [self bringSubviewToFront:_paiMiddle];
                            [self startSecondAnimation];
                         }
                     }];
}

-(void)startSecondAnimation{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiMiddle.center = CGPointMake(160, 80);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self sendSubviewToBack:_paiMiddle];
                             [self startThirdAnimation];
                         }
                     }];
}

-(void)startThirdAnimation{
    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiTop.center = CGPointMake(160, 240);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self startFourthAnimation];
                         }
                     }];
}

-(void)startFourthAnimation{
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiTop.center = CGPointMake(160, 80);
        _paiBottom.center = CGPointMake(160, 80);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self startFifthAnimation];
                         }
                     }];
}

-(void)startFifthAnimation{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiTop.transform = CGAffineTransformMakeRotation(M_PI*2);
        _paiMiddle.transform = CGAffineTransformMakeRotation(M_PI*2);
        _paiBottom.transform = CGAffineTransformMakeRotation(M_PI*2);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (self.delegate) {
                                 [self.delegate showViewWithType:KENUiViewTypeStartChouPai];
                             }
                         }
                     }];
}


-(void)animationTest{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 2.0f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 160, 160);
    CGPathAddLineToPoint(path, NULL, 160, 260);
    CGPathAddLineToPoint(path, NULL, 160, 60);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup.duration = 2.0f;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.repeatCount = 1;     //FLT_MAX
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_paiMiddle.layer addAnimation:animationgroup forKey:nil];
    _paiMiddle.center = CGPointMake(160, 60);
    
    
    CAKeyframeAnimation* positionAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation1.duration = 1.0f;
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 160, 160);
    CGPathAddLineToPoint(path1, NULL, 160, 260);
    positionAnimation.path = path1;
    CGPathRelease(path1);
    
    CAAnimationGroup* animationgroup1 = [CAAnimationGroup animation];
    animationgroup1.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup1.duration = 1.0f;
    animationgroup1.fillMode = kCAFillModeForwards;
    animationgroup1.repeatCount = 1;     //FLT_MAX
    animationgroup1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_paiBottom.layer addAnimation:animationgroup1 forKey:nil];
    _paiBottom.center = CGPointMake(160, 60);
    
    
    //    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    pulseAnimation.duration = 2.;
    //    pulseAnimation.toValue = [NSNumber numberWithFloat:1.15];
    //
    //    CABasicAnimation *pulseColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    //    pulseColorAnimation.duration = 1.;
    //    pulseColorAnimation.fillMode = kCAFillModeForwards;
    //    pulseColorAnimation.toValue = (id)[UIColorFromRGBA(0xFF0000, .75) CGColor];
    //
    //    CABasicAnimation *rotateLayerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //    rotateLayerAnimation.duration = .5;
    //    rotateLayerAnimation.beginTime = .5;
    //    rotateLayerAnimation.fillMode = kCAFillModeBoth;
    //    rotateLayerAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(45.)];
    //
    //    CAAnimationGroup *group = [CAAnimationGroup animation];
    //    group.animations = [NSArray arrayWithObjects:pulseAnimation, pulseColorAnimation, rotateLayerAnimation, nil];
    //    group.duration = 2.;
    //    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    group.autoreverses = YES;
    //    group.repeatCount = FLT_MAX;
    //    
    //    [pulseLayer_ addAnimation:group forKey:nil];
}
@end
