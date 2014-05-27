//
//  KENUiViewPaiDetailAlert.m
//  KENDivination
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewPaiDetailAlert.h"
#import "KENUtils.h"
#import "KENModel.h"
#import "KENConfig.h"

@interface KENUiViewPaiDetailAlert ()

@property (nonatomic, strong) UIImageView* bgView;

@end

@implementation KENUiViewPaiDetailAlert

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jie_pai_bg.png"]];
        _bgView.center = CGPointMake(160, _bgView.frame.size.height / 2 + 50);
        [_bgView setExclusiveTouch:YES];
        
        UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                             image:[UIImage imageNamed:@"button_close.png"]
                                          imagesec:[UIImage imageNamed:@"button_close_sec.png"]
                                            target:self
                                            action:@selector(closeBtnClicked:)];
        button.center = CGPointMake(160, CGRectGetMaxY(_bgView.frame) - button.frame.size.height - 40);
        [self addSubview:button];
        
        [self addSubview:_bgView];
    }
    return self;
}

-(void)setKaPaiMessage:(NSDictionary*)messageDic{
    UIImageView* kaPai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"m_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
    kaPai.center = CGPointMake(kaPai.frame.size.width / 2 + 25, kaPai.frame.size.height / 2 + 15);
    [_bgView addSubview:kaPai];
}

#pragma mark - setting btn
-(void)closeBtnClicked:(UIButton*)button{
    [self removeFromSuperview];
}
@end
