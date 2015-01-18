//
//  KENViewBase.m
//  KENDivination
//
//  Created by 刘坤 on 13-8-6.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "KENViewBase.h"
#import "KENViewController.h"
#import "KENConfig.h"
#import "KENUtils.h"

#define KImgTitleViewTag            (1000)

@interface KENViewBase ()

@property (assign) float rate;
@property (nonatomic, strong) NSMutableArray* viewArray;
@property (nonatomic, strong) KENViewBase* parentView;
@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation KENViewBase

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _viewType = KENViewTypeBase;
        _rate = 1;
        
        [self initView];
        
        [SysDelegate.viewController cancelFullAd];
    }
    return self;
}

-(void)initView{
    _bgImgView = [[UIImageView alloc] initWithImage:[self setBackGroundImage]];
    _bgImgView.center = self.center;

    _contentView = [[UIView alloc] initWithFrame:_bgImgView.frame];
    _bgImgView.frame = (CGRect){CGPointZero, _bgImgView.frame.size};
    [_contentView addSubview:_bgImgView];
    
    [self addSubview:_contentView];
    
    //top back
    [self setTopLeftBtn];
}

#pragma mark - view appear methods
-(void)viewDidAppear:(BOOL)animated{
    //add title
    UIView* titleView = [_contentView viewWithTag:KImgTitleViewTag];
    if (titleView == nil) {
        titleView = [[UIImageView alloc] initWithImage:[self setViewTitleImage]];
        titleView.tag = KImgTitleViewTag;
        titleView.center = CGPointMake(_contentView.frame.size.width / 2, KNotificationHeight / 2);
        [_contentView addSubview:titleView];
    }
    
    if (IsPad) {
        CATransform3D currentTransform = _contentView.layer.transform;
        _rate = self.frame.size.height / _contentView.frame.size.height;
        CATransform3D scaled = CATransform3DScale(currentTransform, _rate, _rate, _rate);
        _contentView.layer.transform = scaled;
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

-(float)getRateIPad{
    return _rate;
}

#pragma mark - for stack frame
-(void)pushView:(KENViewBase*)view animatedType:(KENType)type{
    [self pushView:self subView:view animatedType:type];
}

-(void)pushView:(KENViewBase*)parentView subView:(KENViewBase*)subView animatedType:(KENType)type{
    if (_parentView) {
        [_parentView pushView:_parentView subView:subView animatedType:type];
    } else {
        //视图缓存
        subView.parentView = self;
        if (_viewArray == nil) {
            _viewArray = [[NSMutableArray alloc] init];
        }
        [_viewArray addObject:subView];
        
        [subView viewWillAppear:NO];
        [parentView viewWillDisappear:NO];
        
        //切换视图
        [SysDelegate.viewController pushView:subView animatedType:type];
    }
}

-(void)popView:(KENType)type{
    [self popView:self animatedType:type];
}

-(void)popView:(KENViewBase*)subView animatedType:(KENType)type{
    if (_parentView) {
        [_parentView popView:subView animatedType:type];
    } else {
        if (_viewArray) {
            KENViewBase* view = self;
            if ([_viewArray count] >= 2) {
                view = [_viewArray objectAtIndex:[_viewArray count] - 2];
            }
            
            if (view != subView) {
                [view viewWillAppear:NO];
                [subView viewWillDisappear:NO];
                
                //切换视图
                [SysDelegate.viewController popView:subView preView:view animatedType:type];
                
                [_viewArray removeLastObject];
                view = nil;
            }
        }
    }
}

-(void)popToRootView:(KENType)type{
    if (_parentView) {
        [_parentView viewWillAppear:NO];
        [self viewWillDisappear:NO];
        
        //切换视图
        [SysDelegate.viewController popToRootView:self firstView:_parentView animatedType:type array:_parentView.viewArray];
        
        [_parentView.viewArray removeAllObjects];
    }
}

#pragma mark - other
-(UIImage*)setBackGroundImage{
    return [[KENModel shareModel] getAppBackgroundImg];
}

- (void)resetBackground {
    if (_bgImgView) {
        [_bgImgView setImage:[self setBackGroundImage]];
    }
}

-(UIImage*)setViewTitleImage{
    return nil;
}

-(void)setTopLeftBtn{
    UIButton* setBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:YES
                                         image:[UIImage imageNamed:@"app_btn_back.png"]
                                      imagesec:[UIImage imageNamed:@"app_btn_back_sec.png"]
                                        target:self
                                        action:@selector(backBtnClicked:)];
    setBtn.frame = (CGRect){CGPointZero, 60, 40};
    setBtn.center = CGPointMake(setBtn.center.x, KNotificationHeight / 2);
    [self.contentView addSubview:setBtn];
}

-(void)showView{
}

#pragma mark - btn clicked
-(void)backBtnClicked:(UIButton*)button{
    [self popView:KENTypeNull];
}
@end
