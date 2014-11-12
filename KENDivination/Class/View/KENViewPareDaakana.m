//
//  KENViewPareDaakana.m
//  KENDivination
//
//  Created by 刘坤 on 14-11-10.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewPareDaakana.h"
#import "KENViewParePerson.h"
#import "KENUtils.h"
#import "KENConfig.h"

@interface KENViewPareDaakana ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation KENViewPareDaakana

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypePareDaakana;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"daakana_title.png"];
}

-(void)showView{
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){15, KNotificationHeight + 10,
        self.contentView.frame.size.width - 25, self.contentView.frame.size.height - KNotificationHeight * 1.5}
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.rowHeight = 35.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_tableView];
    
    [_tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 22;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"cell";
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"person_%d.png", indexPath.row]];
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:img]];

    return cell;
}

#pragma mark - table delegate
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        UIImage *imgsec = [UIImage imageNamed:[NSString stringWithFormat:@"person_sec_%d.png", indexPath.row]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:imgsec]];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"person_%d.png", indexPath.row]];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:img]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KENViewParePerson *person = (KENViewParePerson *)[SysDelegate.viewController getView:KENViewTypeParePerson];
    [person setPersonNumber:indexPath.row];
    [self pushView:person animatedType:KENTypeNull];
}
@end
