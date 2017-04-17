//
//  UIViewController+SXKeyboardViewControl.m
//  SXHelper
//
//  Created by Shown on 2017/4/11.
//  Copyright © 2017年 n369. All rights reserved.
//

#import "UIViewController+SXKeyboardViewControl.h"

@implementation UIViewController (SXKeyboardViewControl)
//忽略警告
#pragma clang diagnostic push

#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (void)viewWillAppear:(BOOL)animated {
    //系统的viewWillAppear默认是无操作的,所以借用以实现键盘通知控制
    
    //键盘发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma clang diagnostic pop

//获取正在编辑的view
- (UIView *)getInputView:(UIView *)mainView {
    //如果当前view是键盘正在响应的view
    if (mainView.isFirstResponder) {
        return mainView;
    }
    
    //如果不是则遍历子试图
    if (mainView.subviews.count > 0) {
        for (UIView *view in mainView.subviews) {
            //递归检测
            UIView *tempView = [self getInputView:view];
            //只有找到第一响应者才返回
            if (tempView) {
                return tempView;
            }
        }
    }
    
    //如果没有子视图,或者遍历完成返回nil
    return nil;
}

//键盘发生变化
- (void)onKeyboardNotification:(NSNotification *)notification {
    UIView *inputView = [self getInputView:self.view];
    if (!inputView) {
        return;
    }
    
    CGRect rect = CGRectNull;
    if (inputView) {
        rect = [inputView convertRect:inputView.bounds toView:self.view];
    }
    
    CGRect keyboardFrame = ((NSValue *) notification.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
    if (keyboardFrame.origin.y == self.view.frame.size.height) {
        [UIView animateWithDuration:0.8f animations:^{
            self.view.frame = CGRectMake(0, self.navigationController.navigationBarHidden?0:64, self.view.frame.size.width, self.view.frame.size.height);
        }];
        return;
    }
    
    if (rect.origin.y+rect.size.height + 30 > keyboardFrame.origin.y) {
        CGFloat changHeight = -keyboardFrame.size.height;
        if (rect.origin.y + rect.size.height - 160 < keyboardFrame.origin.y) {
            changHeight = -160;
        }
        if (rect.origin.y + rect.size.height - 120 < keyboardFrame.origin.y) {
            changHeight = -120;
        }
        if (rect.origin.y + rect.size.height - 80 < keyboardFrame.origin.y) {
            changHeight = -80;
        }
        if (rect.origin.y + rect.size.height - 40 < keyboardFrame.origin.y) {
            changHeight = -40;
        }
        
        [UIView animateWithDuration:0.8f animations:^{
            self.view.frame = CGRectMake(0, changHeight, self.view.frame.size.width, self.view.frame.size.height);
        }];
    } else {
        [UIView animateWithDuration:0.8f animations:^{
            self.view.frame = CGRectMake(0, self.navigationController.navigationBarHidden?0:64, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}


@end
