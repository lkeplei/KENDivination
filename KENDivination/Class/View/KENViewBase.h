//
//  KENViewBase.h
//  KENDivination
//
//  Created by 刘坤 on 13-8-6.
//  Copyright (c) 2013年 ken. All rights reserved.
//
#import "KENModelDef.h"
#import "KENModel.h"

@protocol KENViewBaseDelegate <NSObject>
-(void)KENViewBack:(NSDictionary*)resource viewType:(KENViewType)type;
@end

@interface KENViewBase : UIView

-(void)showView;
-(UIImage*)setBackGroundImage;
-(UIImage*)setViewTitleImage;
-(void)setTopLeftBtn;

-(void)viewDidAppear:(BOOL)animated;
-(void)viewDidDisappear:(BOOL)animated;
-(void)viewWillAppear:(BOOL)animated;
-(void)viewWillDisappear:(BOOL)animated;

-(void)pushView:(KENViewBase*)view animatedType:(KENType)type;
-(void)popView:(KENType)type;

@property (assign) KENViewType viewType;
@property (nonatomic, strong) UIView* contentView;

@property (nonatomic, assign) id<KENViewBaseDelegate> viewBaseDelegate;

@end
