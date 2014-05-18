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
    UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"button_end_xipai.png"]
                                      imagesec:[UIImage imageNamed:@"button_end_xipai_sec.png"]
                                        target:self
                                        action:@selector(btnClicked:)];
    button.center = CGPointMake(160, 390);
    [self addSubview:button];
}

#pragma mark - button
-(void)btnClicked:(UIButton*)button{
    if (self.delegate) {
        [self.delegate showVIewWithType:KENUiViewTypeStartQiePai];
    }
}

@end
