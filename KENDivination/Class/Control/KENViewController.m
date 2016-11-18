//
//  KENViewController.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewController.h"
#import "KENConfig.h"
#import "KENDataManager.h"
#import "KENViewPaiZhen.h"

#import "BaiduMobAdSDK/BaiduMobAdSetting.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"


#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

@interface KENViewController ()<BaiduMobAdViewDelegate>
{
    BaiduMobAdView* sharedAdView;
}

@property (nonatomic, strong) KENViewBase* preShowView;

@end

@implementation KENViewController

@synthesize viewFactory = _viewFactory;

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewFactory = [[KENViewFactory alloc] init];

    //初始全屏广告
    [self initFullMogo];
    
    _currentShowView = [self addView:KENViewTypeHome];
    [_currentShowView viewDidAppear:NO];
    [_currentShowView showView];
    
    [self addBaiduAdView];
}

- (void)addBaiduAdView {
    //lp颜色配置
    [BaiduMobAdSetting setLpStyle:BaiduMobAdLpStyleDefault];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
    
    //使用嵌入广告的方法实例。
    sharedAdView = [[BaiduMobAdView alloc] init];
    sharedAdView.AdUnitTag = @"2932555";
    sharedAdView.AdType = BaiduMobAdViewTypeBanner;
    CGFloat bannerY = kScreenHeight - 0.15*kScreenWidth;
    sharedAdView.frame = CGRectMake(0, bannerY, kScreenWidth, 0.15*kScreenWidth);
    [self.view addSubview:sharedAdView];
    
    sharedAdView.delegate = self;
    [sharedAdView start];
}

#pragma mark - baidu delegate
- (NSString *)publisherId {
    return  kBaiduPublisherId; //@"your_own_app_id";注意，iOS和android的app请使用不同的app ID
}

-(BOOL) enableLocation {
    //启用location会有一次alert提示
    return YES;
}


-(void) willDisplayAd:(BaiduMobAdView*) adview
{
    NSLog(@"delegate: will display ad");
}

-(void) failedDisplayAd:(BaiduMobFailReason) reason;
{
    NSLog(@"delegate: failedDisplayAd %d", reason);
}

- (void)didAdImpressed {
    NSLog(@"delegate: didAdImpressed");
    
}

- (void)didAdClicked {
    NSLog(@"delegate: didAdClicked");
}

- (void)didAdClose {
    NSLog(@"delegate: didAdClose");
}

#pragma mark - full admogo
-(void)initFullMogo{
    if ([[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue]){
        return;
    }
}

-(void)showFullAd{
    if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue]){
        
    }
}

-(void)cancelFullAd{
    if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue]){
        
    }
}

#pragma mark - AdMoGoDelegate delegate
-(void)clearAllAd{
    [self removeAd];
    
}

-(void)removeAd{

}

-(void)resetAd{
    if ([[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue]){
        return;
    }
    
    [self removeAd];
    

//    [_currentShowView addSubview:adView];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [_currentShowView bringSubviewToFront:adView];
}

#pragma mark - public method
- (void)resetBgMessage {
    [_viewFactory setAppBg];
}

#pragma mark - about view control
-(KENViewBase*)getView:(KENViewType)type{
    return [_viewFactory getView:type frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(KENViewBase*)addView:(KENViewType)type{
    KENViewBase* view = [self getView:type];
    [self.view addSubview:view];
    return view;
}

-(void)pushView:(KENViewBase*)subView animatedType:(KENType)type{
    _preShowView = _currentShowView;
    _currentShowView = subView;
    
    [[KENModel shareModel] changeView:_preShowView
                                  to:_currentShowView
                                type:KENTypeNull
                            delegate:self];
    [_currentShowView showView];
    
    [self.view addSubview:_currentShowView];
    
    //页面已切换
    [_currentShowView viewDidAppear:YES];
    [_preShowView viewDidDisappear:YES];
    
//    if (adView) {
//        [_currentShowView addSubview:adView];
//        [_currentShowView bringSubviewToFront:adView];
//    }
}

-(void)popView:(KENViewBase*)lastView preView:(KENViewBase*)preView animatedType:(KENType)type{
    _currentShowView = preView;
    
    [[KENModel shareModel] changeView:lastView
                                  to:preView
                                type:KENTypeNull
                            delegate:self];
    
    //页面已切换
    [preView viewDidAppear:YES];
    [lastView viewDidDisappear:YES];
    
    [_viewFactory removeView:lastView.viewType];
}

-(void)popToRootView:(KENViewBase*)subView firstView:(KENViewBase*)view animatedType:(KENType)type array:(NSArray*)array{
    _currentShowView = view;
    
    [[KENModel shareModel] changeView:subView
                                   to:view
                                 type:KENTypeNull
                             delegate:self];
    
    //页面已切换
    [view viewDidAppear:YES];
    [subView viewDidDisappear:YES];
    
    for (int i = 0; i < [array count]; i++) {
        [_viewFactory removeView:((KENViewBase*)[array objectAtIndex:i]).viewType];
    }
}
@end


#pragma mark - autorotate
@implementation UINavigationController (Autorotate)

//返回最上层的子Controller的shouldAutorotate
//子类要实现屏幕旋转需重写该方法
- (BOOL)shouldAutorotate{
    //    return self.topViewController.shouldAutorotate;
    return NO;
}

//返回最上层的子Controller的supportedInterfaceOrientations
- (NSUInteger)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}
@end
