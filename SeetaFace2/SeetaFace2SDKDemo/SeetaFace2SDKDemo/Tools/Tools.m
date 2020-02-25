//
//  Tools.m
//  SeetaFace2SDKDemo
//
//  Created by 49you on 2019/12/23.
//  Copyright © 2019 nrh. All rights reserved.
//

#import "Tools.h"

#define LocalFeaturesKey @"LocalFeaturesKey"

@implementation Tools

+ (UIViewController *)findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

//注意考虑几种特殊情况：①A present B, B present C，参数vc为A时候的情况
/* 完整的描述请参见文件头部 */
+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    //方法1：递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    
    return currentShowingVC;
    
    /*
    //方法2：遍历方法
    while (1)
    {
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
            
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
            
        //} else if (vc.childViewControllers.count > 0) {
        //    //如果是普通控制器，找childViewControllers最后一个
        //    vc = [vc.childViewControllers lastObject];
        } else {
            break;
        }
    }
    return vc;
    //*/
}

+ (void)showToastWithMessage:(NSString *)message
{
    [self showToastWithMessage:message andTimeInterval:2.0f];
}

+ (void)showToastWithMessage:(NSString *)message andTimeInterval:(NSTimeInterval)time
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [[self findCurrentShowingViewController] presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

+ (BOOL)saveFeatures:(NSArray *)features withName:(NSString *)name
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 获取本地数据
    NSMutableArray *mArr = [NSMutableArray arrayWithArray:[userDefaults arrayForKey:LocalFeaturesKey]];
    // 保存数据
    NSDictionary *dic = @{@"name":name, @"features":features};
    [mArr addObject:dic];
    [userDefaults setObject:mArr forKey:LocalFeaturesKey];
    BOOL res = [userDefaults synchronize];
    return res;
}

+ (NSArray *)getAllFeatures
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *res = [NSArray arrayWithArray:[userDefaults arrayForKey:LocalFeaturesKey]];
    return res;
}

@end
