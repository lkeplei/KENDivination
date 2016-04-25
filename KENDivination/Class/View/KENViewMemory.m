//
//  KENViewMemory.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-14.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewMemory.h"
#import "KENModel.h"
#import "KENUtils.h"
#import "KENConfig.h"
#import "KENViewPaiZhen.h"
#import "KENMemoryEntity.h"
#import "KENCoreDataManager.h"

@interface KENViewMemory ()
@property (assign) BOOL editing;
@property (nonatomic, strong) NSMutableArray* resourceArray;
@property (nonatomic, strong) UIButton* topEditBtn;
@property (nonatomic, strong) UIButton* topOkBtn;
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation KENViewMemory

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeMemory;
        _editing = NO;
    }
    return self;
}

#pragma mark - init area
- (void) initTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNotificationHeight,
                                                               self.contentView.width,
                                                               self.contentView.height - KNotificationHeight)
                                              style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
	[self.contentView addSubview:_tableView];
    
    _resourceArray = [NSMutableArray arrayWithArray:[[KENCoreDataManager sharedCoreDataManager] queryFromDB:KCoreMemoryEntity sortKey:nil]];
    
    [_tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resourceArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getCellHeight:[_resourceArray objectAtIndex:_resourceArray.count - indexPath.row - 1]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"cell";
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    KENMemoryEntity* memoryEntity = [_resourceArray objectAtIndex:_resourceArray.count - indexPath.row - 1];
    
    UIView* lineView = [cell.contentView viewWithTag:1111];
    if (lineView == nil) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, [self getCellHeight:memoryEntity] - 1, cell.contentView.frame.size.width, 1)];
        lineView.tag = 1111;
        [lineView setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:lineView];
    } else {
        lineView.frame = CGRectMake(0, [self getCellHeight:memoryEntity] - 1, cell.contentView.frame.size.width, 1);
    }
    
    UILabel* content = (UILabel*)[cell.contentView viewWithTag:2222];
    if (content == nil) {
        content = [KENUtils labelWithTxt:[memoryEntity question]
                                   frame:CGRectMake(5, 0, 200, [self getCellHeight:memoryEntity])
                                    font:[UIFont fontWithName:KLabelFontArial size:14] color:[UIColor whiteColor]];
        content.tag = 2222;
        content.textAlignment = KTextAlignmentLeft;
        content.numberOfLines = 0;
        [cell.contentView addSubview:content];
    } else {
        content.frame = CGRectMake(5, 0, 200, [self getCellHeight:memoryEntity]);
    }
    
    UILabel* timeLable = (UILabel*)[cell.contentView viewWithTag:3333];
    NSDate* date = [KENUtils getDateFromString:[memoryEntity uniquetime] format:KUniqueTimeFormat];
    if (timeLable == nil) {
        NSString* str = [NSString stringWithFormat:@"%@\r\n%@",
                         [KENUtils getStringFromDate:date format:KUniqueYMDFormat],[KENUtils getStringFromDate:date format:KUniqueHMSFormat]];
        timeLable = [KENUtils labelWithTxt:str
                                     frame:CGRectMake(5 + CGRectGetMaxX(content.frame), 0, 80, [self getCellHeight:memoryEntity])
                                      font:[UIFont fontWithName:KLabelFontArial size:14] color:[UIColor whiteColor]];
        timeLable.tag = 3333;
        timeLable.numberOfLines = 0;
        [cell.contentView addSubview:timeLable];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* array = [[KENCoreDataManager sharedCoreDataManager]
                      getMemoryEntity:[[_resourceArray objectAtIndex:_resourceArray.count - indexPath.row - 1] uniquetime]];
    if (array && [array count] > 0) {
        [[KENModel shareModel] setData:[array objectAtIndex:0]];
        
        KENViewPaiZhen* paizhen = (KENViewPaiZhen*)[SysDelegate.viewController getView:KENViewTypePaiZhen];
        [self pushView:paizhen animatedType:KENTypeNull];
        [paizhen setFromMemory:YES];
        [paizhen jumpToFanPai];
    }
}

//编辑状态
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    _editing = [_tableView isEditing];;
    if (_editing) {
        [_topEditBtn setHidden:YES];
        [_topOkBtn setHidden:NO];
    } else {
        [_topEditBtn setHidden:NO];
        [_topOkBtn setHidden:YES];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray* array = [[KENCoreDataManager sharedCoreDataManager]
                          getMemoryEntity:[[_resourceArray objectAtIndex:_resourceArray.count - indexPath.row - 1] uniquetime]];
        for (KENMemoryEntity* entity in array) {
            [[KENCoreDataManager sharedCoreDataManager] deleteObject:entity];
        }
        
        [_resourceArray removeObjectAtIndex:_resourceArray.count - indexPath.row - 1];
        
        [_tableView reloadData];
    }
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"memory_title.png"];
}

-(void)showView{
    _topEditBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:YES
                                     image:[UIImage imageNamed:@"memory_btn_edit.png"]
                                  imagesec:[UIImage imageNamed:@"memory_btn_edit_sec.png"]
                                    target:self
                                    action:@selector(topRightBtnClicked:)];
    _topEditBtn.frame = (CGRect){CGPointZero, 60, 40};
    _topEditBtn.center = CGPointMake(285, KNotificationHeight / 2);
    [self.contentView addSubview:_topEditBtn];
    
    _topOkBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:YES
                                     image:[UIImage imageNamed:@"memory_btn_ok.png"]
                                  imagesec:[UIImage imageNamed:@"memory_btn_ok_sec.png"]
                                    target:self
                                    action:@selector(topRightBtnClicked:)];
    _topOkBtn.frame = (CGRect){CGPointZero, 60, 40};
    _topOkBtn.center = CGPointMake(285, KNotificationHeight / 2);
    [_topOkBtn setHidden:YES];
    [self.contentView addSubview:_topOkBtn];
    
    [self initTable];
    
    //添加广告
    [SysDelegate.viewController removeAd];
}

-(float)getCellHeight:(KENMemoryEntity*)entity{
    float height = 44;
    CGSize size = [KENUtils getFontSize:[entity question] font:[UIFont fontWithName:KLabelFontArial size:14]];
    if (size.width / 200 > 0) {
        height = 16 + size.height * (size.width / 200);
    }
    height = height > 44 ? height : 44;
    return height;
}

#pragma mark - setting btn
-(void)topRightBtnClicked:(UIButton*)button{
    _editing = !_editing;
    if (_editing) {
        [_topEditBtn setHidden:YES];
        [_topOkBtn setHidden:NO];
    } else {
        [_topEditBtn setHidden:NO];
        [_topOkBtn setHidden:YES];
    }
    [_tableView setEditing:_editing animated:YES];
}

@end
