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

@interface KENViewController ()

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
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
