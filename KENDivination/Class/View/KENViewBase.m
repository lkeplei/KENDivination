//
//  KENViewBase.m
//  KENDivination
//
//  Created by 刘坤 on 13-8-6.
//  Copyright (c) 2013年 ken. All rights reserved.
//

#import "KENViewBase.h"
#import "KENViewController.h"

@interface KENViewBase ()

@property (nonatomic, strong) NSMutableArray* viewArray;
@property (nonatomic, strong) KENViewBase* parentView;

@end

@implementation KENViewBase

@synthesize subEventLeft = _subEventLeft;
@synthesize subEventRight = _subEventRight;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _viewType = KENViewTypeBase;
        _subEventLeft = NO;
        _subEventRight = NO;
        
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[self setBackGroundImage]];
        imgView.center = self.center;
        [self addSubview:imgView];
    }
    return self;
}

#pragma mark - view appear methods
-(void)viewDidAppear:(BOOL)animated{
    [self setTopBtn:nil rightBtn:nil enabled:NO];
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
-(void)setTopBtn:(NSString*)leftBtn rightBtn:(NSString*)rightBtn enabled:(BOOL)enabled{
    if (enabled) {
        [self setSubEventLeft:YES];
        [self setSubEventRight:YES];
    } else {
        if (leftBtn) {
            [self setSubEventLeft:YES];
        } else {
            [self setSubEventLeft:NO];
        }
        
        if (rightBtn) {
            [self setSubEventRight:YES];
        } else {
            [self setSubEventRight:NO];
        }
    }
}

-(UIImage*)setBackGroundImage{
    return [UIImage imageNamed:@"app_background_image.png"];
}

-(void)showView{
}

-(void)eventTopBtnClicked:(BOOL)left{
    
}
@end
