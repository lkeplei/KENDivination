//
//  KENUiViewEndXiPai.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-18.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewEndXiPai.h"
#import "KENUtils.h"
#import "KENConfig.h"
#import "KENViewPaiZhen.h"

@interface KENUiViewEndXiPai (){
    BOOL willJump;
    BOOL animating;
    
    int step;
    BOOL canTrans;
    BOOL trans;
}

@property (nonatomic, strong) UIImageView* paiTop;
@property (nonatomic, strong) UIImageView* paiBottom;
@property (nonatomic, strong) UIButton* endButton;

@end

@implementation KENUiViewEndXiPai

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeEndXiPai;
        willJump = NO;
        animating = NO;
        
        step = 1;
        canTrans = YES;
        trans = NO;
        [self initView];
    }
    return self;
}

-(void)initView{
    _paiTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiTop.center = CGPointMake(160, 80);

    _paiTop.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:_paiTop];
    
    _paiBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiBottom.center = CGPointMake(160, 80);
    _paiBottom.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [self addSubview:_paiBottom];
    
    _endButton = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"button_end_xipai.png"]
                                      imagesec:[UIImage imageNamed:@"button_end_xipai_sec.png"]
                                        target:self
                                        action:@selector(btnClicked:)];
    _endButton.center = CGPointMake(160, 340);
    [self addSubview:_endButton];
    
    [self startAnimation];
}

-(void)startTransAnimation:(NSTimeInterval)duration{
    self.animationStep = 2;
    static int times = 1;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiBottom.transform = CGAffineTransformRotate(_paiBottom.transform, M_PI_2);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (times % 2 == 0) {
                                 [self startAnimation];
                             } else {
                                 [self startTransAnimation:0.5];
                             }
                             times++;
                         }
                     }];
}

-(void)startAnimation{
    int random = [KENUtils getRandomNumber:0 to:1];
    if (random == 1 && step % 2 == 0 && canTrans) {
        [self startTransAnimation:0.75];
        trans = YES;
        canTrans = NO;
    } else {
        self.animationStep = 1;
        if (step % 2 == 0) {
            [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(timerOut) userInfo:nil repeats:NO];
        }
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (step % 2 == 1) {
                animating = YES;
                trans = NO;
                _paiBottom.center = CGPointMake(160, 160);
            } else {
                _paiBottom.center = CGPointMake(160, 80);
            }
            canTrans = YES;
            step++;
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 if (step % 2 == 1) {
                                     animating = NO;
                                     
                                     if (trans) {
                                         _paiBottom.transform = CGAffineTransformRotate(_paiBottom.transform, M_PI);
                                     }
                                     [self sendSubviewToBack:_paiTop];
                                 } else {
                                     [self bringSubviewToFront:_paiTop];
                                 }
                                 
                                 if (willJump && !animating) {
                                     [self btnClicked:nil];
                                 } else {
                                     [self startAnimation];
                                 }
                             }
                         }];
    }
}

-(void)timerOut{
    [[KENModel shareModel] playVoiceByType:KENVoiceXiPai];
}

-(void)viewDealWithAd{

}

-(void)startBaseAnimation{
    if (self.animationStep == 2) {
        _paiBottom.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    [self startAnimation];
}

#pragma mark - button
-(void)btnClicked:(UIButton*)button{
    if (button) {
        //按键声音
        [[KENModel shareModel] playVoiceByType:KENVoiceAnJian];
    }
    
    if (willJump && !animating) {
        [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _endButton.alpha = 0;
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 if (self.delegate) {
                                     [self.delegate showViewWithType:KENUiViewTypeStartQiePai];
                                 }
                             }
                         }];
    } else {
        willJump = YES;
    }
}

@end
