//
//  KENAppDelegate.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENAppDelegate.h"
#import "KENModel.h"
#import "KENConfig.h"
#import "KENCoreDataManager.h"

#import "MobClick.h"

@implementation KENAppDelegate

-(void)umengTrack{
//    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取

    if (IsPad) {
        [MobClick startWithAppkey:@"5388374756240b7bc700d1b3"];
    } else {
        [MobClick startWithAppkey:@"5388367d56240b7bd600bdbe"];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //init
    [[KENModel shareModel] initData];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _viewController = [[KENViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:_viewController];
    _viewController.navigationController.navigationBarHidden = YES;
    
    self.window.rootViewController = navigation;
    
    [self.window addSubview:navigation.view];
    [self.window makeKeyAndVisible];
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[KENCoreDataManager sharedCoreDataManager] safelyExit];
}
@end
