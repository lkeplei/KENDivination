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

@interface KENViewBase ()

@property (nonatomic, strong) NSMutableArray* viewArray;
@property (nonatomic, strong) KENViewBase* parentView;

@end

@implementation KENViewBase

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _viewType = KENViewTypeBase;
        
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[self setBackGroundImage]];
    imgView.center = self.center;

    _contentView = [[UIView alloc] initWithFrame:imgView.frame];
    imgView.frame = (CGRect){CGPointZero, imgView.frame.size};
    [_contentView addSubview:imgView];
    
    [self addSubview:_contentView];
    
    //top back
    [self setTopLeftBtn];
    
    if (IsPad) {
        CATransform3D currentTransform = _contentView.layer.transform;
        float rate = self.frame.size.height / imgView.frame.size.height;
        CATransform3D scaled = CATransform3DScale(currentTransform, rate, rate, rate);
        _contentView.layer.transform = scaled;
    }
}

#pragma mark - view appear methods
-(void)viewDidAppear:(BOOL)animated{
    //add title
    UIImageView* titleView = [[UIImageView alloc] initWithImage:[self setViewTitleImage]];
    titleView.center = CGPointMake(_contentView.frame.size.width / 2, KNotificationHeight / 2);
    [_contentView addSubview:titleView];
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
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
            
            [view viewWillAppear:NO];
            [subView viewWillDisappear:NO];

            //切换视图
            [SysDelegate.viewController popView:subView preView:view animatedType:type];
            
            [_viewArray removeLastObject];
            view = nil;
        }
    }
}

#pragma mark - other
-(UIImage*)setBackGroundImage{
    return [UIImage imageNamed:@"app_background_image.png"];
}

-(UIImage*)setViewTitleImage{
    return nil;
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

-(void)showView{
}

#pragma mark - btn clicked
-(void)backBtnClicked:(UIButton*)button{
    [self popView:KENTypeNull];
}
@end
