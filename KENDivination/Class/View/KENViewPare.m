//
//  KENViewPare.m
//  KENDivination
//
//  Created by 刘坤 on 14-11-10.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewPare.h"
#import "KENUtils.h"
#import "KENConfig.h"
#import "KENModel.h"
#import "KENDataManager.h"

@implementation KENViewPare
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypePare;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"pare_title.png"];
}

-(void)showView{
    //btn
    UIButton* taluoBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                          image:[UIImage imageNamed:@"pare_taluo.png"]
                                       imagesec:[UIImage imageNamed:@"pare_taluo_sec.png"]
                                         target:self
                                         action:@selector(taluoBtnClicked:)];
    taluoBtn.center = CGPointMake(kFullScreenAdaptiveX(160.f), 169);
    [self.contentView addSubview:taluoBtn];
    
    UIButton* daziranBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                           image:[UIImage imageNamed:@"pare_daziran.png"]
                                        imagesec:[UIImage imageNamed:@"pare_daziran_sec.png"]
                                          target:self
                                          action:@selector(daziranBtnClicked:)];
    daziranBtn.center = CGPointMake(kFullScreenAdaptiveX(160.f), 212);
    [self.contentView addSubview:daziranBtn];
    
    UIButton* daakanaBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                           image:[UIImage imageNamed:@"pare_daakana.png"]
                                        imagesec:[UIImage imageNamed:@"pare_daakana_sec.png"]
                                          target:self
                                          action:@selector(daakanaBtnClicked:)];
    daakanaBtn.center = CGPointMake(kFullScreenAdaptiveX(160.f), 255);
    [self.contentView addSubview:daakanaBtn];
    
    //去除广告
    [SysDelegate.viewController removeAd];
}

#pragma mark - setting btn
-(void)taluoBtnClicked:(UIButton*)button{
    [self pushView:[SysDelegate.viewController getView:KENViewTypePareTaluo] animatedType:KENTypeNull];
}

-(void)daziranBtnClicked:(UIButton*)button{
    [self pushView:[SysDelegate.viewController getView:KENViewTypePareDaziran] animatedType:KENTypeNull];
}

- (void)daakanaBtnClicked:(UIButton *)button {
    [self pushView:[SysDelegate.viewController getView:KENViewTypePareDaakana] animatedType:KENTypeNull];
}
@end
