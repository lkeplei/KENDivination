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
    _paiMiddle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiMiddle.center = CGPointMake(160, 160);
    _paiMiddle.transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
    [self addSubview:_paiMiddle];
    
    _paiBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiBottom.center = CGPointMake(160, 160);
    _paiBottom.transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
    [self addSubview:_paiBottom];

    _paiTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiTop.center = CGPointMake(160, 160);
    _paiTop.transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
    [self addSubview:_paiTop];
    
    [self startFirstAnimation];
}

-(void)startFirstAnimation{
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        _paiMiddle.center = CGPointMake(160, 210);
//        _paiBottom.center = CGPointMake(160, 210);
//    }
//                     completion:^(BOOL finished) {
//                         if (finished) {
//                             
//                         }
//                     }];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_paiBottom.center];
    [path addLineToPoint:CGPointMake(160, 210)];
    CAKeyframeAnimation* keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframe.path = path.CGPath;
    keyframe.duration = 1;
    [_paiBottom.layer addAnimation:keyframe forKey:@"transtionKey"];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:keyframe, nil];
    group.duration = 2.;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.autoreverses = YES;
    group.repeatCount = FLT_MAX;
    
    [self.layer addAnimation:group forKey:nil];
    
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
