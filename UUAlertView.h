//
//  UUAlertView.h
//  UUAlertView
//
//  Created by zhuochenming on 16/3/20.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUAlertView;

@protocol UUAlertViewDelegate <NSObject>

@optional

- (void)alertView:(UUAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)alertViewCancel:(UUAlertView *)alertView;

@end

@interface UUAlertView : UIToolbar

@property (nonatomic, assign) id<UUAlertViewDelegate>udelegate;

+ (CGFloat)heigthWithTitle:(NSString *)title font:(UIFont *)font width:(CGFloat)width;

+ (UILabel *)autoHeightLabeWithTitle:(NSString *)title;

+ (UITextView *)textViewWithPlaceHolder:(NSString *)placeHolder;

- (instancetype)initWithTitle:(NSString *)title view:(UIView *)customView delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@end
