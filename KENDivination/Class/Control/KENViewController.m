//
//  KENViewController.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewController.h"
#import "KENConfig.h"

#import "AdMoGoInterstitialManager.h"

@interface KENViewController ()

@property (nonatomic, strong) KENViewBase* preShowView;

@end

@implementation KENViewController

@synthesize adView;
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
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - full admogo
-(void)initFullMogo{
    NSString* mogoId = KADIphoneId;
    if (IsPad) {
        mogoId = KADIpadId;
    }
    [AdMoGoInterstitialManager setAppKey:mogoId];
    //初始化(必须先设置默认的AppKey才能通过此方法初始化SDK)
    [[AdMoGoInterstitialManager shareInstance] initDefaultInterstitial];
    [AdMoGoInterstitialManager setRootViewController:self];
    
    [AdMoGoInterstitialManager setDefaultDelegate:self];
    
    
//    interstitial = [[AdMoGoInterstitial alloc]
//                    noautopollinginitWithAppKey:mogoId
//                    isRefresh:YES
//                    adInterval:4
//                    adType:AdViewTypeFullScreen
//                    adMoGoViewDelegate:self];
//    interstitial.adWebBrowswerDelegate = self;
//    /*
//     启动广告轮换
//     */
//    [interstitial pollingInterstitialAd];
}

-(void)showFullAd{
//    [interstitial interstitialShow:YES];
    [[AdMoGoInterstitialManager shareInstance] interstitialShow:NO];
}

-(void)cancelFullAd{
//    [interstitial interstitialCancel];
    [[AdMoGoInterstitialManager shareInstance] interstitialCancel];
}

/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingInterstitialModalView{
    return self;
}

/*
 全屏广告开始请求
 */
- (void)adsMoGoInterstitialAdDidStart{
    NSLog(@"MOGO Full Screen Start");
}

/*
 全屏广告准备完毕
 */
- (void)adsMoGoInterstitialAdIsReady{
    NSLog(@"MOGO Full Screen IsReady");
}

/*
 全屏广告接收成功
 */
- (void)adsMoGoInterstitialAdReceivedRequest{
    NSLog(@"MOGO Full Screen Received");
}

/*
 全屏广告将要展示
 */
- (void)adsMoGoInterstitialAdWillPresent{
    NSLog(@"MOGO Full Screen Will Present");
}

/*
 全屏广告接收失败
 */
- (void)adsMoGoInterstitialAdFailedWithError:(NSError *) error{
    NSLog(@"MOGO Full Screen Failed");
}

/*
 全屏广告消失
 */
- (void)adsMoGoInterstitialAdDidDismiss{
    NSLog(@"MOGO Full Screen Dismiss");
}

#pragma mark - AdMoGoDelegate delegate
-(void)removeAd{
    if (adView) {
        [adView removeFromSuperview];
        adView = nil;
    }
}

-(void)resetAd{
    [self removeAd];
    
    NSString* mogoId = KADIphoneId;
    if (IsPad) {
        mogoId = KADIpadId;
    }
    adView = [[AdMoGoView alloc] initWithAppKey:mogoId adType:AdViewTypeNormalBanner adMoGoViewDelegate:self];
    adView.adWebBrowswerDelegate = self;
    
    //    typedef enum {
    //        AdViewTypeUnknown = 0,          //error
    //        AdViewTypeNormalBanner = 1,     //e.g. 320 * 50 ; 320 * 48  iphone banner
    //        AdViewTypeLargeBanner = 2,      //e.g. 728 * 90 ; 768 * 110 ipad only
    //        AdViewTypeMediumBanner = 3,     //e.g. 468 * 60 ; 508 * 80  ipad only
    //        AdViewTypeRectangle = 4,        //e.g. 300 * 250; 320 * 270 ipad only
    //        AdViewTypeSky = 5,              //Don't support
    //        AdViewTypeFullScreen = 6,       //iphone full screen ad
    //        AdViewTypeVideo = 7,            //Don't support
    //        AdViewTypeiPadNormalBanner = 8, //ipad use iphone banner
    //    } AdViewType;
    
    if (IsPad) {
        adView.frame = CGRectMake(0.0, 50, 320.0, 50.0);
    } else {
        adView.frame = CGRectMake(0.0, _currentShowView.frame.size.height - 50, 320.0, 50.0);
    }
    [_currentShowView addSubview:adView];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >=7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [_currentShowView bringSubviewToFront:adView];
}

/*
 返回广告rootViewController
 */
- (UIViewController *)viewControllerForPresentingModalView{
    return self;
}

/**
 * 广告开始请求回调
 */
- (void)adMoGoDidStartAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告开始请求回调");
}
/**
 * 广告接收成功回调
 */
- (void)adMoGoDidReceiveAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告接收成功回调");
}
/**
 * 广告接收失败回调
 */
- (void)adMoGoDidFailToReceiveAd:(AdMoGoView *)adMoGoView didFailWithError:(NSError *)error{
    NSLog(@"广告接收失败回调");
}
/**
 * 点击广告回调
 */
- (void)adMoGoClickAd:(AdMoGoView *)adMoGoView{
    NSLog(@"点击广告回调");
}
/**
 *You can get notified when the user delete the ad
 广告关闭回调
 */
- (void)adMoGoDeleteAd:(AdMoGoView *)adMoGoView{
    NSLog(@"广告关闭回调");
}

#pragma mark -
#pragma mark AdMoGoWebBrowserControllerUserDelegate delegate

/*
 浏览器将要展示
 */
- (void)webBrowserWillAppear{
    NSLog(@"浏览器将要展示");
}

/*
 浏览器已经展示
 */
- (void)webBrowserDidAppear{
    NSLog(@"浏览器已经展示");
}

/*
 浏览器将要关闭
 */
- (void)webBrowserWillClosed{
    NSLog(@"浏览器将要关闭");
}

/*
 浏览器已经关闭
 */
- (void)webBrowserDidClosed{
    NSLog(@"浏览器已经关闭");
}
/**
 *直接下载类广告 是否弹出Alert确认
 */
-(BOOL)shouldAlertQAView:(UIAlertView *)alertView{
    return NO;
}

- (void)webBrowserShare:(NSString *)url{
    
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
