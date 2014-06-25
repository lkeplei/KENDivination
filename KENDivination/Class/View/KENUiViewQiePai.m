//
//  KENUiViewQiePai.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-21.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewQiePai.h"
#import "KENModel.h"
#import "KENConfig.h"

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
    _paiBottom.center = CGPointMake(160, KPaiCenter.y + 80);
    _paiBottom.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:_paiBottom];
    
    _paiTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiTop.center = CGPointMake(160, KPaiCenter.y + 80);
    _paiTop.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:_paiTop];
    
    _paiMiddle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiMiddle.center = CGPointMake(160, KPaiCenter.y + 80);
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
        _paiMiddle.center = CGPointMake(160, KPaiCenter.y + 160);
        _paiBottom.center = CGPointMake(160, KPaiCenter.y + 160);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                            [self bringSubviewToFront:_paiMiddle];
                            self.animationStep++;
                            [self startBaseAnimation];
//                            [self startSecondAnimation];
                         }
                     }];
}

-(void)startSecondAnimation{
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiMiddle.center = KPaiCenter;
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self sendSubviewToBack:_paiMiddle];
                             self.animationStep++;
                             [self startBaseAnimation];
//                             [self startThirdAnimation];
                         }
                     }];
}

-(void)startThirdAnimation{
    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiTop.center = CGPointMake(160, KPaiCenter.y + 160);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.animationStep++;
                             [self startBaseAnimation];
//                             [self startFourthAnimation];
                         }
                     }];
}

-(void)startFourthAnimation{
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiTop.center = KPaiCenter;
        _paiBottom.center = KPaiCenter;
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             self.animationStep++;
                             [self startBaseAnimation];
//                             [self startFifthAnimation];
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

-(void)viewDealWithAd{
    
}

-(void)startBaseAnimation{
    switch (self.animationStep) {
        case 0:
            [self startFirstAnimation];
            break;
        case 1:
            [self startSecondAnimation];
            break;
        case 2:
            [self startThirdAnimation];
            break;
        case 3:
            [self startFourthAnimation];
            break;
        case 4:
            [self startFifthAnimation];
            break;
        default:
            break;
    }
}
@end
