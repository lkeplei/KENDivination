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
    _paiBottom.center = CGPointMake(160, 160);
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
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _paiTop.center = CGPointMake(160, _paiTop.center.y == 70 ? 160 : 70);
        _paiBottom.center = CGPointMake(160, _paiBottom.center.y == 70 ? 160 : 70);
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
