//
//  HDCommonTools+UI.m
//  lanzhuBook
//
//  Created by Damon on 2018/3/9.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+UI.h"

BOOL hasTabbar;    //是否含有tabbar
@implementation HDCommonTools (UI)

///获取当前的normalwindow
- (UIWindow *)getCurrentNormalWindow {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}

///获取当前显示的VC
- (UIViewController *)getCurrentVC {
    hasTabbar = NO;
    UIWindow * window = [self getCurrentNormalWindow];
    UIViewController *result = nil;
    if ([window subviews].count>0) {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            result = nextResponder;
        else
            result = window.rootViewController;
    } else {
        result = window.rootViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        hasTabbar = !((UITabBarController*)result).tabBar.isHidden;
        result = [((UITabBarController*)result) selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) visibleViewController];
    }
    return result;
}

///该VC是否有tabbar
- (BOOL)hasTabbarVC {
    [self getCurrentVC];
    return hasTabbar;
}

///获取当前显示VC的最前View
- (UIView *)getCurrentView {
    if ([self getCurrentVC].view.subviews.count > 0) {
        return [[self getCurrentVC].view.subviews lastObject];
    } else {
        return [self getCurrentVC].view;
    }
}
@end
