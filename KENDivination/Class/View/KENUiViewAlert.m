//
//  KENUiViewAlert.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-15.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewAlert.h"
#import "KENUtils.h"
#import "KENConfig.h"
#import "KENViewController.h"

#define KButtonsBaseTag         (500)

@implementation KENUiViewAlert

-(id)initWithMessage:(UIImage*)img btnArray:(NSArray*)array{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImageView* bgView = [[UIImageView alloc] initWithImage:img];
        bgView.center = CGPointMake(kFullScreenAdaptiveX(160.f), 240);
        
        [self addSubview:bgView];
        
        [self setButtons:array];
    }
    return self;
}

-(void)setButtons:(NSArray*)array{
    if ([array count] == 1) {
        [self addButton:CGPointMake(kFullScreenAdaptiveX(160.f), 275) res:[array objectAtIndex:0] tag:KButtonsBaseTag];
    } else if ([array count] == 2) {
        [self addButton:CGPointMake(kFullScreenAdaptiveX(90.f), 275) res:[array objectAtIndex:0] tag:KButtonsBaseTag];
        [self addButton:CGPointMake(kFullScreenAdaptiveX(234.f), 275) res:[array objectAtIndex:1] tag:KButtonsBaseTag + 1];
    } else {
        
    }
}

-(void)addButton:(CGPoint)point res:(NSDictionary*)res tag:(int)tag{
    UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[res objectForKey:KDicKeyImg]
                                      imagesec:[res objectForKey:KDicKeyImgSec]
                                        target:self
                                        action:@selector(btnClicked:)];
    button.center = point;
    button.tag = tag;
    [self addSubview:button];
}

-(void)show{
    [SysDelegate.viewController.currentShowView.contentView addSubview:self];
}

#pragma mark - setting btn
-(void)btnClicked:(UIButton*)button{
    if (self.alertBlock) {
        self.alertBlock(button.tag - KButtonsBaseTag);
    }
    
    [self removeFromSuperview];
}
@end
