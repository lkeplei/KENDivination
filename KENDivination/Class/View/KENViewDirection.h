//
//  KENViewDirection.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-14.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewBase.h"
#import "KENModel.h"

#import <StoreKit/StoreKit.h>

@interface KENViewDirection : KENViewBase<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (assign) KENType viewDirection;

@end
