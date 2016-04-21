//
//  UUAlertView.m
//  UUAlertView
//
//  Created by zhuochenming on 16/3/20.
//  Copyright © 2016年 zhuochenming. All rights reserved.
//

#import "UUAlertView.h"

@interface UUAlertView ()

@property (nonatomic, strong) UIView *bacgroundView;

@end

@implementation UUAlertView

+ (CGFloat)heigthWithTitle:(NSString *)title font:(UIFont *)font width:(CGFloat)width {
    CGFloat height = [title boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.height;
    return height;
}

+ (UILabel *)autoHeightLabeWithTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor lightGrayColor];
    
    CGRect rect = CGRectMake(20, 5, 0, 0);
    CGFloat lableHeight = [self heigthWithTitle:title font:[UIFont systemFontOfSize:15] width:[UIScreen mainScreen].bounds.size.width - 100];
    rect.size.height = lableHeight + 10;
    titleLabel.frame = rect;
    
    return titleLabel;
}

+ (UITextView *)textViewWithPlaceHolder:(NSString *)placeHolder {
    UITextView *textView = [[UITextView alloc] init];
    textView.textColor = [UIColor lightGrayColor];
    textView.font = [UIFont systemFontOfSize:15];
    [textView becomeFirstResponder];
    textView.text = placeHolder;
    textView.backgroundColor = [UIColor clearColor];
    textView.frame = CGRectMake(20, 15, 0, 60);
    return textView;
}

- (instancetype)initWithTitle:(NSString *)title view:(UIView *)customView delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION {
    self = [super init];
    if (self) {

        NSMutableArray *argsArray = [[NSMutableArray alloc] init];
        if (cancelButtonTitle) {
            [argsArray insertObject:cancelButtonTitle atIndex:0];
        }
        va_list params; //定义一个指向个数可变的参数列表指针;
        va_start(params,otherButtonTitles);//va_start 得到第一个可变参数地址,
        id arg;
        if (otherButtonTitles) {
            //将第一个参数添加到array
            id prev = otherButtonTitles;
            [argsArray addObject:prev];
            //va_arg 指向下一个参数地址
            //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
            while((arg = va_arg(params,id))) {
                if (arg) {
                    [argsArray addObject:arg];
                }
            }
            //置空
            va_end(params);
        }
        
        //设置背影半透明
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 60;
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;

        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 3;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor colorWithRed:(255.0 / 255) green:(127.0 / 255) blue:(70.0 / 255) alpha:1];
        
        CGRect rect = CGRectMake(0, 0, width, 0);
        CGFloat lableHeight = [title boundingRectWithSize:CGSizeMake(width - 40, 0) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : titleLabel.font} context:nil].size.height;
        rect.size.height = lableHeight + 10;
        titleLabel.frame = rect;
        
        titleLabel.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
        titleLabel.layer.borderWidth = 0.5;
        
        [self addSubview:titleLabel];
        
        CGRect customRect = customView.frame;
        CGFloat customy = customRect.origin.y;
        customRect.origin.y = CGRectGetMaxY(titleLabel.frame) + customy;
        customRect.size.width = width - customRect.origin.x * 2;
        customView.frame = customRect;
        [self addSubview:customView];
        
        CGFloat height = CGRectGetMaxY(customView.frame) + customy;
        if (argsArray.count <= 2) {
            for (int i = 0; i < [argsArray count]; i++) {
                NSString *title = argsArray[i];
                UIButton *button = [self bottomButtonWithTitle:title index:i];
                button.frame = CGRectMake((width + 1.0) / argsArray.count * i - 0.5, CGRectGetMaxY(customView.frame) + 5.0 + customy, (width + 2) / argsArray.count, 44);
                [self addSubview:button];
            }
            height += 44;
        } else {
            for (int i = 0; i < [argsArray count]; i++){
                NSString *title = argsArray[i];
                UIButton *button = [self bottomButtonWithTitle:title index:i];
                button.frame = CGRectMake(0, CGRectGetMaxY(customView.frame) + customy + 44 * i, width, 44);
                [self addSubview:button];
             }
            height += 44 * argsArray.count;
        }
        
        self.frame = CGRectMake(30, ([UIScreen mainScreen].bounds.size.height - height) / 2.0, width, height);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (UIButton *)bottomButtonWithTitle:(NSString *)title index:(NSInteger)index {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    button.layer.borderWidth = 0.5;
    button.tag = 10000 + index;
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor colorWithRed:(57.0 / 255) green:(170.0 / 255) blue:(196.0 / 255) alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:(132.0 / 255) green:(132.0 / 255) blue:(132.0 / 255) alpha:1] forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    if (index == 0) {
        [button addTarget:self action:@selector(cancalClick:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}


#pragma mark - 点击按钮
- (void)buttonClick:(UIButton *)sender {
    if (_udelegate && [_udelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
        [_udelegate alertView:self clickedButtonAtIndex:sender.tag - 10000];
    }
    [self dismiss];
}

#pragma mark - 点击取消按钮
- (void)cancalClick:(UIButton *)sender {
    if (_udelegate && [_udelegate respondsToSelector:@selector(alertViewCancel:)]) {
        [_udelegate alertViewCancel:self];
    }

    if (_udelegate && [_udelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]){
        [_udelegate alertView:self clickedButtonAtIndex:sender.tag - 10000];
    }
    [self dismiss];
}

#pragma mark - 显示alertView
- (void)show {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window endEditing:YES];
        
        self.bacgroundView = [[UIView alloc] initWithFrame:window.frame];
        self.bacgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bacViewTap)];
        [self.bacgroundView addGestureRecognizer:tap];

        [self.bacgroundView addSubview:self];
        [window addSubview:_bacgroundView];

        [self performPresentationAnimation];
}

- (void)bacViewTap {
    [self.bacgroundView endEditing:YES];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.bacgroundView removeFromSuperview];
}

- (void)performPresentationAnimation {
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.3;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = @[@0.8, @1.05, @0.98, @1.0];
    [self.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

#pragma mark - 键盘事件
- (void)keyBoardWillShow:(NSNotification *)notefication {
    CGRect rect = [notefication.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[notefication.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        CGRect viewRect = self.frame;
        viewRect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(viewRect) - rect.size.height - 20;
        self.frame = viewRect;
    }];
}

- (void)keyBoardWillHide:(NSNotification *)notefication {
    [UIView animateWithDuration:[notefication.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.center = self.bacgroundView.center;
    }];
}

@end
