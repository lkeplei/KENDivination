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

@interface KENViewSubjectSetting ()

@property (nonatomic, strong) SListView *appBgTableView;
@property (nonatomic, strong) SListView *paiBgTableView;

@end

@implementation KENViewSubjectSetting

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeSubjectSetting;
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
    _appBgTableView.center = CGPointMake(self.center.x, 142);
    _appBgTableView.delegate = self;
    _appBgTableView.dataSource = self;
    
    [_appBgTableView setSelectedIndex:[[KENDataManager getDataByKey:KUserDefaultAppBg] intValue] - KENSubjectTypeAppbg1];
    
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
    _paiBgTableView.center = CGPointMake(self.center.x, 303);
    _paiBgTableView.delegate = self;
    _paiBgTableView.dataSource = self;
    
    [_paiBgTableView setSelectedIndex:[[KENDataManager getDataByKey:KUserDefaultPaiBg] intValue] - KENSubjectTypePaibg1];
    
    [self.contentView addSubview:_paiBgTableView];
}

#pragma mark - setting btn
- (void)btnConfirmClicked:(UIButton *)button {
    [[KENModel shareModel] setBgMessage:[_appBgTableView selectedIndex] - KENSubjectTypeAppbg1
                                  paiBg:[_paiBgTableView selectedIndex] - KENSubjectTypePaibg1];
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
}

- (void)listView:(SListView *)listView didSelectColumnAtIndex:(NSInteger)index {
}
@end