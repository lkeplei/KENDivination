//
//  KENViewSubjectSetting.m
//  KENDivination
//
//  Created by 刘坤 on 15/1/16.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KENViewSubjectSetting.h"
#import "KENUtils.h"
#import "KENConfig.h"
#import "KENModel.h"
#import "KENDataManager.h"

#define kLockStart          (2)

@interface KENViewSubjectSetting ()

@property (nonatomic, strong) SListView *appBgTableView;
@property (nonatomic, strong) SListView *paiBgTableView;
@property (nonatomic, strong) EBPurchase* purchase;
@property (assign) BOOL isPurchased;

@end

@implementation KENViewSubjectSetting

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeSubjectSetting;
        
        // Create an instance of EBPurchase.
        _purchase = [[EBPurchase alloc] init];
        _purchase.delegate = self;
        
        _isPurchased = NO; // default.
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"subject_setting_title.png"];
}

-(void)showView{
    //初始页面背景
    [self initAppBgSelect];
    
    //初始卡牌背景
    [self initPaiBgSelect];
    
    //分隔线
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subject_separator.png"]];
    line.center = CGPointMake(160, 222);
    [self.contentView addSubview:line];
    
    //确认修改按钮
    UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                             image:[UIImage imageNamed:@"subject_confirm.png"]
                          imagesec:[UIImage imageNamed:@"subject_confirm_sec.png"]
                            target:self
                            action:@selector(btnConfirmClicked:)];
    button.center = CGPointMake(160, 382);
    [self.contentView addSubview:button];
}

- (void)initAppBgSelect {
    UIButton* left = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                       image:[UIImage imageNamed:@"subject_arrow_left.png"]
                                    imagesec:[UIImage imageNamed:@"subject_arrow_left.png"]
                                      target:self
                                      action:@selector(btnLeftAppClicked:)];
    left.center = CGPointMake(18, 142);
    [self.contentView addSubview:left];
    
    UIButton* right = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                       image:[UIImage imageNamed:@"subject_arrow_right.png"]
                                    imagesec:[UIImage imageNamed:@"subject_arrow_right.png"]
                                      target:self
                                      action:@selector(btnRightAppClicked:)];
    right.center = CGPointMake(302, 142);
    [self.contentView addSubview:right];
    
    _appBgTableView = [[SListView alloc] initWithFrame:CGRectMake(0, 0, 268, 134)];
    _appBgTableView.center = CGPointMake(160, 142);
    _appBgTableView.delegate = self;
    _appBgTableView.dataSource = self;
    
    [_appBgTableView setSelectedIndex:[[KENDataManager getDataByKey:KUserDefaultAppBg] intValue]];
    
    [self.contentView addSubview:_appBgTableView];
}

- (void)initPaiBgSelect {
    UIButton* left = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                       image:[UIImage imageNamed:@"subject_arrow_left.png"]
                                    imagesec:[UIImage imageNamed:@"subject_arrow_left.png"]
                                      target:self
                                      action:@selector(btnLeftPaiClicked:)];
    left.center = CGPointMake(18, 303);
    [self.contentView addSubview:left];
    
    UIButton* right = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                       image:[UIImage imageNamed:@"subject_arrow_right.png"]
                                    imagesec:[UIImage imageNamed:@"subject_arrow_right.png"]
                                      target:self
                                      action:@selector(btnRightPaiClicked:)];
    right.center = CGPointMake(302, 303);
    [self.contentView addSubview:right];
    
    _paiBgTableView = [[SListView alloc] initWithFrame:CGRectMake(0, 0, 268, 104)];
    _paiBgTableView.center = CGPointMake(160, 303);
    _paiBgTableView.delegate = self;
    _paiBgTableView.dataSource = self;
    
    [_paiBgTableView setSelectedIndex:[[KENDataManager getDataByKey:KUserDefaultPaiBg] intValue]];
    
    [self.contentView addSubview:_paiBgTableView];
}

#pragma mark - setting btn
- (void)btnConfirmClicked:(UIButton *)button {
    int appSec = [_appBgTableView selectedIndex];
    int paiSec = [_paiBgTableView selectedIndex];
    if ([[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue] || (appSec <= kLockStart && paiSec <= kLockStart)){
        [[KENModel shareModel] setBgMessage:appSec paiBg:paiSec];
    } else {
        [_purchase requestProduct:SUB_PRODUCT_ID];
    }
}

- (void)btnLeftAppClicked:(UIButton *)button {
    [_appBgTableView movePre];
}

- (void)btnRightAppClicked:(UIButton *)button {
    [_appBgTableView moveNext];
}

- (void)btnLeftPaiClicked:(UIButton *)button {
    [_paiBgTableView movePre];
}

- (void)btnRightPaiClicked:(UIButton *)button {
    [_paiBgTableView moveNext];
}

#pragma mark - btn clicked
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (_purchase.validProduct != nil) {
        if (buttonIndex == 1){
            [_purchase purchaseProduct:_purchase.validProduct];
        } else if (buttonIndex == 2){
            [_purchase restorePurchase];
        }
    }
}

#pragma mark - SKPayment
-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription
{
    if (productPrice != nil)    {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:nil
                                                               message:[NSString stringWithFormat:MyLocal(@"purchase_content"),
                                                                        [productPrice floatValue]]
                                                              delegate:self cancelButtonTitle:MyLocal(@"cancel")
                                                     otherButtonTitles:MyLocal(@"purchase"), MyLocal(@"restore"), nil];
        [unavailAlert show];
    } else {
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
    }
}

-(void)successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt{
    if (!_isPurchased){
        _isPurchased = YES;
        [KENDataManager setDataByKey:[NSNumber numberWithBool:YES] forkey:KUserDefaultJieMi];
        [SysDelegate.viewController clearAllAd];
        

        [_appBgTableView removeFromSuperview];
        _appBgTableView = nil;
        //初始页面背景
        [self initAppBgSelect];
        
        [_paiBgTableView removeFromSuperview];
        _paiBgTableView = nil;
        //初始卡牌背景
        [self initPaiBgSelect];
    }
}

-(void)failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage{
    //@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance."
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:MyLocal(@"purchase_title") message:MyLocal(@"purchase_failed")
                                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}

-(void)incompleteRestore:(EBPurchase*)ebp{
    //@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored."
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:MyLocal(@"purchase_title") message:MyLocal(@"restore_incomplete")
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
}

-(void)failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage{
    //@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance."
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:MyLocal(@"purchase_title") message:MyLocal(@"restore_failed")
                                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
}

#pragma mark - list view
/**
 * @brief 共有多少列
 * @param listView 当前所在的ListView
 */
- (NSInteger)numberOfColumnsInListView:(SListView *)listView {
    return 7;
}

/**
 * @brief 这一列有多宽，根据有多宽，算出需要加载多少个
 * @param index  当前所在列
 */
- (CGFloat)widthForColumnAtIndex:(SListView *)listView index:(NSInteger)index {
    if (listView == _appBgTableView) {
        return 90;
    } else {
        return 67;
    }
}

/**
 * @brief 每列 显示什么
 * @param listView 当前所在的ListView
 * @param index  当前所在列
 * @return  当前所要展示的页
 */
- (SListViewCell *)listView:(SListView *)listView viewForColumnAtIndex:(NSInteger)index {
    static NSString * CELL = @"CELL";
    SListViewCell * cell;
    cell = [listView dequeueReusableCellWithIdentifier:CELL];
    if (!cell) {
        cell = [[SListViewCell alloc] initWithReuseIdentifier:CELL];
        if (listView == _appBgTableView) {
            [cell setSelectedBgImage:[UIImage imageNamed:@"subject_bg_select.png"]];
        } else {
            [cell setSelectedBgImage:[UIImage imageNamed:@"subject_pai_select.png"]];
        }
    }
    
    if (listView == _appBgTableView) {
        [self setAppBgCellContent:cell index:index];
    } else {
        [self setPaiBgCellContent:cell index:index];
    }
    
    return  cell;
}

- (void)setAppBgCellContent:(SListViewCell *)cell index:(NSInteger)index {
    UIImage *img = [UIImage imageNamed:@"subject_bg_1.png"];
    if (index > 0) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"subject_bg_%d.jpg", index + 1]];
    }
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1001];
    if (imgView) {
        [imgView setImage:img];
    } else {
        imgView = [[UIImageView alloc] initWithImage:img];
        imgView.tag = 1001;
        imgView.center = CGPointMake(47, _appBgTableView.frame.size.height / 2);
        [cell.contentView addSubview:imgView];
    }
    
    UIImageView *lockImgView = (UIImageView *)[cell.contentView viewWithTag:1002];
    if (lockImgView) {
        [lockImgView removeFromSuperview];
    }
    
    if (index > kLockStart) {
        lockImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subject_bg_lock.png"]];
        lockImgView.tag = 1002;
        lockImgView.center = CGPointMake(47, _appBgTableView.frame.size.height / 2);
        [cell.contentView addSubview:lockImgView];
    }
}

- (void)setPaiBgCellContent:(SListViewCell *)cell index:(NSInteger)index {
    UIImage *img = [UIImage imageNamed:@"kapai_bg_1.png"];
    if (index > 0) {
        img = [UIImage imageNamed:[NSString stringWithFormat:@"kapai_bg_%d.jpg", index + 1]];
    }
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1001];
    if (imgView) {
        [imgView setImage:img];
    } else {
        imgView = [[UIImageView alloc] initWithImage:img];
        imgView.tag = 1001;
        imgView.center = CGPointMake(32, _paiBgTableView.frame.size.height / 2);
        [cell.contentView addSubview:imgView];
    }
    
    UIImageView *lockImgView = (UIImageView *)[cell.contentView viewWithTag:1002];
    if (lockImgView) {
        [lockImgView removeFromSuperview];
    }
    
    if (index > kLockStart) {
        lockImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subject_pai_bg.png"]];
        lockImgView.tag = 1002;
        lockImgView.center = CGPointMake(32, _paiBgTableView.frame.size.height / 2);
        [cell.contentView addSubview:lockImgView];
    }
}

- (void)listView:(SListView *)listView didSelectColumnAtIndex:(NSInteger)index {
    if (index > kLockStart) {
        if (![[KENDataManager getDataByKey:KUserDefaultJieMi] boolValue]) {
            [_purchase requestProduct:SUB_PRODUCT_ID];
        }
    }
}
@end