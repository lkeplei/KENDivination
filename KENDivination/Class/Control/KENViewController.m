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

@import GoogleMobileAds;

#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

@interface KENViewController ()<BaiduMobAdViewDelegate, GADInterstitialDelegate, GADBannerViewDelegate>

@property (nonatomic, strong) KENViewBase* preShowView;
@property (nonatomic, strong) BaiduMobAdView *sharedAdView;

@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, strong) GADBannerView *bannerView;

@end

@implementation KENViewController

@synthesize viewFactory = _viewFactory;

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewFactory = [[KENViewFactory alloc] init];
    
    _currentShowView = [self addView:KENViewTypeHome];
    [_currentShowView viewDidAppear:NO];
    [_currentShowView showView];
}

#pragma mark - baidu delegate
- (NSString *)publisherId {
    return  kBaiduPublisherId; //@"your_own_app_id";注意，iOS和android的app请使用不同的app ID
}

- (BOOL)enableLocation {
    //启用location会有一次alert提示
    return YES;
}

- (void)willDisplayAd:(BaiduMobAdView*)adview {
    NSLog(@"delegate: will display ad");
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason {
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

#pragma mark - admob delegate
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    DebugLog("interstitialDidReceiveAd");
    
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    DebugLog("didFailToReceiveAdWithError error = %@", error);
}

#pragma mark Display-Time Lifecycle Notifications
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    DebugLog("interstitialWillPresentScreen");
}

- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    DebugLog("interstitialDidFailToPresentScreen");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    DebugLog("interstitialWillDismissScreen");
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    DebugLog("interstitialDidDismissScreen");
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    DebugLog("interstitialWillLeaveApplication");
}

#pragma mark - full admogo
-(void)showFullAd{
    if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue]){
        _interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-3782605513789953/4711237420"];
        _interstitial.delegate = self;
        [_interstitial loadRequest:[GADRequest request]];
    }
}

-(void)cancelFullAd{
    if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue]){
        
    }
}

#pragma mark - public method
-(void)clearAllAd{
    [self removeAd];
}

-(void)removeAd{
    [_sharedAdView removeFromSuperview];
    _sharedAdView = nil;
    
    [_bannerView removeFromSuperview];
    _bannerView = nil;
}

-(void)resetAd{
    if ([[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue]){
        return;
    }
    
    [self removeAd];
    
    [_currentShowView addSubview:self.sharedAdView];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [_currentShowView bringSubviewToFront:self.sharedAdView];
}

- (void)showBaiduBanner {
    [_bannerView removeFromSuperview];
    _bannerView = nil;
    
    [_currentShowView addSubview:self.sharedAdView];
}

- (void)showAdmobBanner {
    [_sharedAdView removeFromSuperview];
    _sharedAdView = nil;
    
    [_currentShowView addSubview:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
}

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
    
    if (_sharedAdView) {
        [_currentShowView addSubview:_sharedAdView];
        [_currentShowView bringSubviewToFront:_sharedAdView];
    }
    if (_bannerView) {
        [_currentShowView addSubview:_bannerView];
        [_currentShowView bringSubviewToFront:_bannerView];
    }
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

#pragma mark - getter setter 
- (BaiduMobAdView *)sharedAdView {
    if (_sharedAdView == nil) {
        //lp颜色配置
        [BaiduMobAdSetting setLpStyle:BaiduMobAdLpStyleDefault];
#warning ATS默认开启状态, 可根据需要关闭App Transport Security Settings，设置关闭BaiduMobAdSetting的supportHttps，以请求http广告，多个产品只需要设置一次.    [BaiduMobAdSetting sharedInstance].supportHttps = NO;
        
        //使用嵌入广告的方法实例。
        _sharedAdView = [[BaiduMobAdView alloc] init];
        _sharedAdView.AdUnitTag = @"3342164";
        _sharedAdView.AdType = BaiduMobAdViewTypeBanner;
        CGFloat bannerY = kScreenHeight - 0.15 * kScreenWidth;
        _sharedAdView.frame = CGRectMake(0, bannerY, kScreenWidth, 0.15*kScreenWidth);
        
        _sharedAdView.delegate = self;
        [_sharedAdView start];
    }
    return _sharedAdView;
}

- (GADBannerView *)bannerView {
    if (_bannerView == nil) {
        if (IsPad) {
            _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
            _bannerView.width = self.view.width;
        } else {
            _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];  
        }
        _bannerView.originY = _currentShowView.height - _bannerView.height;
        _bannerView.adUnitID = @"ca-app-pub-3782605513789953/3234504222";
        _bannerView.rootViewController = self;
    }
    return _bannerView;
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
