//
//  KENViewPaiZhen.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-17.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewPaiZhen.h"
#import "KENUtils.h"
#import "KENModel.h"
#import "KENConfig.h"
#import "KENUiViewAlert.h"
#import "KENUiViewStartXiPai.h"
#import "KENUiViewEndXiPai.h"
#import "KENUiViewQiePai.h"
#import "KENUiViewFanPai.h"
#import "KENUiViewChouPai.h"
#import "KENUiViewPaiZhenDetail.h"

@interface KENViewPaiZhen ()

@property (nonatomic, strong) KENUiViewBase* currentUiView;
@property (nonatomic, strong) KENUiViewAlert* alertView;
@property (nonatomic, strong) UIButton* topDetailBtn;
@property (nonatomic, strong) UIButton* topPaizhenBtn;

@end

@implementation KENViewPaiZhen

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypePaiZhen;
        _fromMemory = NO;
    }
    return self;
}

-(void)showViewWithType:(KENViewType)type{
    if (_currentUiView == nil || _currentUiView.viewType != type) {
        if (_currentUiView) {
            [_currentUiView removeFromSuperview];
            _currentUiView = nil;
        }
        
        CGRect frame = CGRectMake(0, KNotificationHeight, self.contentView.frame.size.width,
                                  self.contentView.frame.size.height - KNotificationHeight);
        switch (type) {
            case KENUiViewTypeStartFanPai:
            case KENUiViewTypeStartChouPai:
            case KENUiViewTypeStartQiePai:
            case KENUiViewTypeStartXiPai:{
                _currentUiView = [[KENUiViewStartXiPai alloc] initWithFrame:frame type:type];
                [_currentUiView setDelegate:self];
            }
                break;
            case KENUiViewTypeEndXiPai:{
                _currentUiView = [[KENUiViewEndXiPai alloc] initWithFrame:frame];
                [_currentUiView setDelegate:self];
            }
                break;
            case KENUiViewTypeQiePai:{
                _currentUiView = [[KENUiViewQiePai alloc] initWithFrame:frame];
                [_currentUiView setDelegate:self];
            }
                break;
            case KENUiViewTypeChouPai:{
                _currentUiView = [[KENUiViewChouPai alloc] initWithFrame:frame];
                [_currentUiView setDelegate:self];
            }
                break;
            case KENUiViewTypeFanPai:{
                _currentUiView = [[KENUiViewFanPai alloc] initWithFrame:frame finish:NO];
                [_currentUiView setDelegate:self];
            }
                break;
            case KENUiViewTypePaiZhenDetail:{
                _currentUiView = [[KENUiViewPaiZhenDetail alloc] initWithFrame:frame];
                [_currentUiView setDelegate:self];
            }
                break;
            default:
                break;
        }
        
        [self.contentView addSubview:_currentUiView];
        if (_alertView) {
            [self.contentView bringSubviewToFront:_alertView];
        }
    }
}

-(void)jumpToFanPai{
    if (_currentUiView) {
        [_currentUiView removeFromSuperview];
        _currentUiView = nil;
    }
    
    CGRect frame = CGRectMake(0, KNotificationHeight, self.contentView.frame.size.width,
                              self.contentView.frame.size.height - KNotificationHeight);
    _currentUiView = [[KENUiViewFanPai alloc] initWithFrame:frame finish:YES];
    [_currentUiView setDelegate:self];
    
    [self.contentView addSubview:_currentUiView];
    if (_alertView) {
        [self.contentView bringSubviewToFront:_alertView];
    }
    
    [_topDetailBtn setHidden:NO];
    [_topPaizhenBtn setHidden:YES];
}

-(void)setFinishStatus:(BOOL)finishStatus{
    _finishStatus = finishStatus;
    
    [_topDetailBtn setHidden:NO];
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [[KENModel shareModel] getPaiZhenTitle];
}

-(void)showView{
    [self showViewWithType:KENUiViewTypeStartXiPai];
    
    _topDetailBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                      image:[UIImage imageNamed:@"app_btn_detail.png"]
                                   imagesec:[UIImage imageNamed:@"app_btn_detail_sec.png"]
                                     target:self
                                     action:@selector(detailBtnClicked:)];
    [_topDetailBtn setHidden:YES];
    _topDetailBtn.center = CGPointMake(288, KNotificationHeight / 2);
    [self.contentView addSubview:_topDetailBtn];
    
    _topPaizhenBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                       image:[UIImage imageNamed:@"app_btn_paizhen.png"]
                                    imagesec:[UIImage imageNamed:@"app_btn_paizhen_sec.png"]
                                      target:self
                                      action:@selector(paizhenBtnClicked:)];
    [_topPaizhenBtn setHidden:YES];
    _topPaizhenBtn.center = CGPointMake(288, KNotificationHeight / 2);
    [self.contentView addSubview:_topPaizhenBtn];
}

-(void)setTopLeftBtn{
    UIButton* setBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"app_btn_back.png"]
                                      imagesec:[UIImage imageNamed:@"app_btn_back_sec.png"]
                                        target:self
                                        action:@selector(backBtnClicked:)];
    setBtn.center = CGPointMake(setBtn.center.x + 20, KNotificationHeight / 2);
    [self.contentView addSubview:setBtn];
}

#pragma mark - btn clicked
-(void)paizhenBtnClicked:(UIButton*)button{
    [_topPaizhenBtn setHidden:YES];
    [_topDetailBtn setHidden:NO];
    
    [self jumpToFanPai];
}

-(void)detailBtnClicked:(UIButton*)button{
    [_topPaizhenBtn setHidden:NO];
    [_topDetailBtn setHidden:YES];
    
    [self showViewWithType:KENUiViewTypePaiZhenDetail];
}

-(void)backBtnClicked:(UIButton*)button{
    if (_fromMemory) {
        [[KENModel shareModel] clearData];
        [self popView:KENTypeNull];
    } else {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[UIImage imageNamed:@"button_cancel.png"] forKey:KDicKeyImg];
        [dic setObject:[UIImage imageNamed:@"button_cancel_sec.png"] forKey:KDicKeyImgSec];
        
        NSMutableDictionary* dic1 = [[NSMutableDictionary alloc] init];
        [dic1 setObject:[UIImage imageNamed:@"button_confirm.png"] forKey:KDicKeyImg];
        [dic1 setObject:[UIImage imageNamed:@"button_confirm_sec.png"] forKey:KDicKeyImgSec];
        
        UIImage* img = [UIImage imageNamed:@"exit_whether_alert.png"];
        if (_finishStatus) {
            img = [UIImage imageNamed:@"save_whether_alert.png"];
        }
        _alertView = [[KENUiViewAlert alloc] initWithMessage:img btnArray:[[NSArray alloc] initWithObjects:dic, dic1, nil]];
        [_alertView show];
        
        _alertView.alertBlock = ^(int index){
            if (index == 1) {
                if (_finishStatus) {
                    [[KENModel shareModel] saveData];
                } else {
                    [[KENModel shareModel] clearData];
                }
                [self popToRootView:KENTypeNull];
            } else if (index == 0) {
                if (_finishStatus) {
                    [self popToRootView:KENTypeNull];
                }
            }
        };
    }
}
@end
