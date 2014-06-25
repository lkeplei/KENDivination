//
//  KENUiViewBase.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-18.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewBase.h"
#import "KENUtils.h"

@interface KENUiViewBase ()
@property (nonatomic, strong) UIButton* fullButton;
@end

@implementation KENUiViewBase

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _viewType = KENViewTypeBase;
        
        _animationStep = 0;
        _fullButton = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                        image:nil
                                     imagesec:nil
                                       target:self
                                       action:@selector(fullBtnClicked:)];
        _fullButton.frame = self.frame;
        [_fullButton setEnabled:NO];
        [self addSubview:_fullButton];
    }
    return self;
}

-(void)dealWithAd{
    [_fullButton setEnabled:YES];
    [self viewDealWithAd];
}

-(void)startBaseAnimation{
    
}

-(void)viewDealWithAd{
    
}

#pragma mark - button click
-(void)fullBtnClicked:(UIButton*)button{
    [_fullButton setEnabled:NO];
    [self startBaseAnimation];
}
@end
