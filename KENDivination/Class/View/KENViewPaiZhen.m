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

@interface KENViewPaiZhen ()

@property (nonatomic, strong) KENUiViewBase* currentUiView;
@property (nonatomic, strong) KENUiViewAlert* alertView;

@end

@implementation KENViewPaiZhen

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypePaiZhen;
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
            default:
                break;
        }
        
        [self.contentView addSubview:_currentUiView];
        if (_alertView) {
            [self.contentView bringSubviewToFront:_alertView];
        }
    }
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [[KENModel shareModel] getPaiZhenTitle];
}

-(void)showView{
    [self showViewWithType:KENUiViewTypeStartXiPai];
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
-(void)backBtnClicked:(UIButton*)button{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UIImage imageNamed:@"button_cancel.png"] forKey:KDicKeyImg];
    [dic setObject:[UIImage imageNamed:@"button_cancel_sec.png"] forKey:KDicKeyImgSec];

    NSMutableDictionary* dic1 = [[NSMutableDictionary alloc] init];
    [dic1 setObject:[UIImage imageNamed:@"button_confirm.png"] forKey:KDicKeyImg];
    [dic1 setObject:[UIImage imageNamed:@"button_confirm_sec.png"] forKey:KDicKeyImgSec];

    _alertView = [[KENUiViewAlert alloc] initWithMessage:[UIImage imageNamed:@"exit_whether_alert.png"]
                                                       btnArray:[[NSArray alloc] initWithObjects:dic, dic1, nil]];
    [_alertView show];

    _alertView.alertBlock = ^(int index){
        if (index == 1) {
            [self popToRootView:KENTypeNull];
        }
    };
}
@end
