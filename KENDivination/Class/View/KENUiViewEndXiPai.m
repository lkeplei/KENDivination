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

@interface KENUiViewEndXiPai ()

@property (nonatomic, strong) UIImageView* paiTop;
@property (nonatomic, strong) UIImageView* paiBottom;

@end

@implementation KENUiViewEndXiPai

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeEndXiPai;
        
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

-(void)startAnimation{
    static int step = 1;
    static int times = 0;
    static BOOL canTrans = YES;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        int trans = [KENUtils getRandomNumber:0 to:1];
        if (trans == 1 && step % 2 == 0 && canTrans) {
            _paiTop.transform = CGAffineTransformMakeRotation(M_PI_2 + M_PI * times);
            times++;
            canTrans = NO;
        } else {
            if (step % 2 == 1) {
                _paiTop.center = CGPointMake(160, 160);
            } else {
                _paiTop.center = CGPointMake(160, 70);
            }
            step++;
            canTrans = YES;
        }
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self startAnimation];
                         }
                     }];
}

#pragma mark - button
-(void)btnClicked:(UIButton*)button{
    if (self.delegate) {
        [self.delegate showViewWithType:KENUiViewTypeStartQiePai];
    }
}

@end