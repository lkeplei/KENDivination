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
}

@property (nonatomic, strong) UIImageView* paiTop;
@property (nonatomic, strong) UIImageView* paiBottom;

@end

@implementation KENUiViewEndXiPai

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeEndXiPai;
        willJump = NO;
        animating = NO;
        [self initView];
    }
    return self;
}

-(void)initView{
    _paiTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiTop.center = CGPointMake(160, 70);
    _paiTop.transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
    [self addSubview:_paiTop];
    
    _paiBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    _paiBottom.center = CGPointMake(160, 70);
    _paiBottom.transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
    [self addSubview:_paiBottom];
    
    UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"button_end_xipai.png"]
                                      imagesec:[UIImage imageNamed:@"button_end_xipai_sec.png"]
                                        target:self
                                        action:@selector(btnClicked:)];
    button.center = CGPointMake(160, 340);
    [self addSubview:button];
    
    [self startAnimation];
}

-(void)startTransAnimation:(NSTimeInterval)duration{
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
    static int step = 1;
    static BOOL canTrans = YES;
    int trans = [KENUtils getRandomNumber:0 to:1];
    if (trans == 1 && step % 2 == 0 && canTrans) {
        [self startTransAnimation:0.75];
        canTrans = NO;
    } else {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (step % 2 == 1) {
                animating = YES;
                _paiBottom.center = CGPointMake(160, 160);
            } else {
                _paiBottom.center = CGPointMake(160, 70);
            }
            canTrans = YES;
            step++;
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 if (step % 2 == 1) {
                                     animating = NO;
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

//-(void)startAnimation{
//    static int step = 1;
//    static int times = 1;
//    static BOOL canTrans = YES;
//    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//        animating = YES;
//        
//        int trans = [KENUtils getRandomNumber:0 to:1];
//        if (trans == 1 && step % 2 == 0 && canTrans) {
////            _paiBottom.transform = CGAffineTransformMakeRotation(M_PI_2 + M_PI * times);
//            DebugLog(@"times = %d", times);
////            _paiBottom.transform = CGAffineTransformMakeRotation(times * M_PI);
//            int angle = times * 180 + 90;
////            angle = (angle - 90) / 360 == 0 ? angle - 1 : angle;
//            _paiBottom.transform = CGAffineTransformMakeRotation(angle / 180.0 * M_PI);
//            times++;
//            canTrans = NO;
//        } else {
//            if (step % 2 == 1) {
//                _paiBottom.center = CGPointMake(160, 160);
//            } else {
//                _paiBottom.center = CGPointMake(160, 70);
//            }
//            step++;
//            canTrans = YES;
//        }
//    }
//                     completion:^(BOOL finished) {
//                         if (finished) {
//                             animating = NO;
//                             if (willJump) {
//                                 [self btnClicked:nil];
//                             } else {
//                                [self startAnimation];
//                             }
//                         }
//                     }];
//}

#pragma mark - button
-(void)btnClicked:(UIButton*)button{
    if (willJump && !animating) {
        if (self.delegate) {
            [self.delegate showViewWithType:KENUiViewTypeStartQiePai];
        }
    } else {
        willJump = YES;
    }
}

@end
