//
//  KENViewController.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewController.h"

@interface KENViewController ()

@property (nonatomic, strong) KENViewBase* currentShowView;
@property (nonatomic, strong) KENViewBase* preShowView;

@end

@implementation KENViewController

@synthesize viewFactory = _viewFactory;

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewFactory = [[KENViewFactory alloc] init];

    _currentShowView = [self addView:KENViewTypeHome];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
