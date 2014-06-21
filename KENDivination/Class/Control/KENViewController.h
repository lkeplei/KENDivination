//
//  KENViewController.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KENViewBase.h"
#import "KENViewFactory.h"

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

#import "AdMoGoInterstitialDelegate.h"

@interface KENViewController : UIViewController<AdMoGoDelegate, AdMoGoWebBrowserControllerUserDelegate, AdMoGoInterstitialDelegate>{
    AdMoGoView* adView;
}
@property (nonatomic, strong) AdMoGoView* adView;

-(void)resetAd;
-(void)removeAd;

-(void)showFullAd;
-(void)cancelFullAd;

-(void)clearAllAd;

-(KENViewBase*)getView:(KENViewType)type;
/**
 *  视图进栈
 *
 *  @param subView 要进来的视图
 *  @param type 进栈动画
 */
-(void)pushView:(KENViewBase*)subView animatedType:(KENType)type;

/**
 *  视图出栈
 *
 *  @param lastView 要出的视图
 *  @param preView  前一个视图
 *  @param type 出栈动画
 */
-(void)popView:(KENViewBase*)lastView preView:(KENViewBase*)preView animatedType:(KENType)type;

/**
 *  视图全出栈
 *
 *  @param subView 要出的视图
 *  @param view  最底层视图
 *  @param type 出栈动画
 *  @param array 视图数组
 */
-(void)popToRootView:(KENViewBase*)subView firstView:(KENViewBase*)view animatedType:(KENType)type array:(NSArray*)array;

@property (nonatomic, strong) KENViewFactory* viewFactory;
@property (nonatomic, strong) KENViewBase* currentShowView;

@end


@interface UINavigationController (Autorotate)

- (BOOL)shouldAutorotate   ;
- (NSUInteger)supportedInterfaceOrientations;

@end