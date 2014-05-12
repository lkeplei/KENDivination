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
//enabled：yes不管有没有文字都有效、no只有有文字显示才有效
-(void)setTopBtn:(NSString*)leftBtn rightBtn:(NSString*)rightBtn enabled:(BOOL)enabled;
-(void)eventTopBtnClicked:(BOOL)left;

-(void)viewDidAppear:(BOOL)animated;
-(void)viewDidDisappear:(BOOL)animated;
-(void)viewWillAppear:(BOOL)animated;
-(void)viewWillDisappear:(BOOL)animated;

-(void)pushView:(KENViewBase*)view animatedType:(KENType)type;
-(void)popView:(KENType)type;

@property (assign)KENViewType viewType;
@property (assign)BOOL subEventLeft;
@property (assign)BOOL subEventRight;

@property (nonatomic, assign) id<KENViewBaseDelegate> viewBaseDelegate;

@end
