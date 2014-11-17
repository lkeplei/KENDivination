//
//  KENViewParePerson.m
//  KENDivination
//
//  Created by 刘坤 on 14-11-11.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewParePerson.h"
#import "KENConfig.h"
#import "KENUtils.h"

@interface KENViewParePerson ()

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSString *personDesc;

@end

@implementation KENViewParePerson
@synthesize personNumber = _personNumber;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeParePerson;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"daakana_title.png"];
}

- (void)showView {
    //添加广告
    [SysDelegate.viewController resetAd];
}

- (void)setPersonNumber:(int)personNumber {
    _personNumber = personNumber;
    
    NSString *string = KPersonDesc(_personNumber);
    _personDesc = MyLocal(string);
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0, KNotificationHeight + 10,
        self.contentView.frame.size.width, self.contentView.frame.size.height - KNotificationHeight * 1.5} style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_tableView];
    
    [_tableView reloadData];
}

- (float)getPersonDescHeight {
    CGSize titleSize = [_personDesc sizeWithFont:[UIFont fontWithName:KLabelFontArial size:16]
                               constrainedToSize:CGSizeMake(_tableView.frame.size.width - 20, MAXFLOAT)
                                   lineBreakMode:UILineBreakModeWordWrap];
    return titleSize.height + 20;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40.f;
    } else if (indexPath.row == 1) {
        return 200.f;
    } else {
        return [self getPersonDescHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"cell";
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    for (UIView *subView in [cell.contentView subviews]) {
        [subView removeFromSuperview];
    }
    
    if (indexPath.row == 0) {
        cell.frame = (CGRect){CGPointZero, cell.frame.size.width, 40.f};
    } else if (indexPath.row == 1) {
        cell.frame = (CGRect){CGPointZero, cell.frame.size.width, 200.f};
    } else {
        cell.frame = (CGRect){CGPointZero, cell.frame.size.width, [self getPersonDescHeight]};
    }
    
    if (indexPath.row == 0) {
        [self setTitle:cell];
    } else if (indexPath.row == 1) {
        [self setPersonImage:cell];
    } else {
        [self setDesc:cell];
    }
    
    return cell;
}

- (void)setTitle:(UITableViewCell *)cell {
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:_personNumber];
    UILabel *title = [KENUtils labelWithTxt:[messageDic objectForKey:KDicKeyPaiPerson]
                                      frame:(CGRect){CGPointZero, cell.frame.size}
                                       font:[UIFont fontWithName:KLabelFontArial size:19]
                                      color:[UIColor colorWithRed:244 / 255.f green:209 / 255.f blue:68 / 255.f alpha:1]];
    [cell.contentView addSubview:title];
}

- (void)setPersonImage:(UITableViewCell *)cell {
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:_personNumber];
    UIImageView* kaPai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"m_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
    kaPai.center = CGPointMake(cell.center.x, cell.frame.size.height / 2);
    [cell.contentView addSubview:kaPai];
}

- (void)setDesc:(UITableViewCell *)cell {
    UILabel *value = [KENUtils labelWithTxt:_personDesc
                                      frame:CGRectMake(10, 0, cell.frame.size.width - 20, cell.frame.size.height)
                                       font:[UIFont fontWithName:KLabelFontArial size:16]
                                      color:[UIColor whiteColor]];
    value.textAlignment = NSTextAlignmentLeft;
    value.numberOfLines = 0;
    [cell.contentView addSubview:value];
}
@end
