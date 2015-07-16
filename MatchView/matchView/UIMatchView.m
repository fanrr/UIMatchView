//
//  MatchView.m
//  MatchView
//
//  Created by Raymond～ on 15/7/11.
//  Copyright (c) 2015年 Raymond～. All rights reserved.
//

#import "UIMatchView.h"
#define SCALE_SUB 0.03
#define OFFSET_SUB 12
@interface UIMatchView ()
/* 重用数组 */
@property (nonatomic, strong) NSMutableArray * reusedArray;
/* 使用中数组 */
@property (nonatomic, strong) NSMutableArray * usedArray;
@property (nonatomic, assign) CGPoint          touchLocation;
@property (nonatomic, assign) NSInteger        index;
@property (nonatomic, assign) NSInteger        totalCount;
@property (nonatomic, assign) BOOL             canMatch;
@end
@implementation UIMatchView
- (NSMutableArray *)usedArray{
    if (!_usedArray) {
        _usedArray = [[NSMutableArray alloc] init];
    }
    return _usedArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
        self.canMatch        = NO;
    }
    return self;
}
- (NSInteger)totalCount{
    NSInteger count = [self.dataSource numberOfView];
    return count;
}
#pragma mark
#pragma mark 重新刷新
- (void)reloadMatchView{
    self.canMatch = NO;
    [self setBaseMatchView];
}
#pragma mark
#pragma mark 从重用数组中获取view
- (UIView *)getReusedView{
    if (self.reusedArray.count) {
        UIView * view = [self.reusedArray lastObject];
        [self.reusedArray removeLastObject];
        return view;
    }
    return nil;
}
#pragma mark
#pragma mark 向显示的数组中添加一个
- (void)addMatchView:(UIView *)view{
    if (view) {
        [self.usedArray addObject:view];
        NSUInteger index = 3;
        view.frame       = CGRectMake(0, 0, [self.delegate matchViewSize].width,[self.delegate matchViewSize].height);
        view.transform   = CGAffineTransformMakeScale(1-index * SCALE_SUB, 1-index * SCALE_SUB);
        view.center      = CGPointMake(self.center.x, self.center.y + index *OFFSET_SUB);
        [self insertSubview:view atIndex:0];
    }
}
#pragma mark
#pragma mark 设置显示数组内的View
- (void)setBaseMatchView{
    
    [self.usedArray removeAllObjects];
    self.index = 0;
    int number = [self.dataSource numberOfView];
    if (number > 4) {
        number = 4;
    }
    for (int i = 0; i < number; i ++) {
        UIView * view = [self.dataSource matchView:self viewForRowAtIndex:i];
        [self.usedArray addObject:view];
    }
    [self setMatchViewLocation];
}
#pragma mark
#pragma mark 层次效果
- (void)setMatchViewLocation{
    __weak UIMatchView * weak_self = self;
    [self.usedArray enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        NSUInteger index = idx;
        if (index > 3) {
            index = 3;
        }
        obj.frame = CGRectMake(- [weak_self.delegate matchViewSize].width, 0,  [weak_self.delegate matchViewSize].width,[weak_self.delegate matchViewSize].height);
        obj.transform = CGAffineTransformMakeScale(1-index * SCALE_SUB, 1-index * SCALE_SUB);
        [weak_self insertSubview:obj atIndex:0];
    }];
    [self setViewsComeIn:(int)self.usedArray.count - 1];
}
#pragma mark
#pragma mark 依次入场
- (void)setViewsComeIn:(int)index{
    __weak UIMatchView * weak_match = self;
    if (index < self.usedArray.count && index >= 0) {
        UIView * view = [self.usedArray objectAtIndex:index];
        [UIView animateWithDuration:.5 animations:^{
            view.center = CGPointMake(self.center.x, self.center.y + index *OFFSET_SUB);
        }];
        if (index != 0) {
            index --;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weak_match setViewsComeIn:index];
            });
        }else{
            self.canMatch = YES;
        }
    }
}

#pragma mark
#pragma mark 层次变化效果
- (void)setMatchViewScale:(CGFloat)s{
    if (s >= 1) {
        s = 1;
    }
    __weak UIMatchView * weak_self = self;
    [self.usedArray enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        if (idx && idx <4) {
            obj.transform = CGAffineTransformMakeScale(1- idx * SCALE_SUB + SCALE_SUB*s, 1- idx * SCALE_SUB + SCALE_SUB*s);
            obj.center = CGPointMake(weak_self.center.x, weak_self.center.y + idx * OFFSET_SUB - OFFSET_SUB * s);
        }
    }];
}

#pragma mark
#pragma mark 把滑动的View移除屏幕
- (void)rmView:(UIView *)view{
    CGFloat s = fabs((view.center.y - self.center.y) / (view.center.x - self.center.x));
    CGFloat x;
    CGFloat y;
    if (view.center.x < self.center.x) {//左
        if ([self.delegate respondsToSelector:@selector(matchview:swipeDirection:)]) {
            [self.delegate matchview:self swipeDirection:SwipeDirectionLeft];
        }
        x = - view.frame.size.width / 2.0;
        if (view.center.y > self.center.y)//下
            y = self.center.y + s * (self.center.x + view.frame.size.width / 2.0);
        else//上
            y = self.center.y - s * (self.center.x + view.frame.size.width / 2.0);
    }else{//右
        if ([self.delegate respondsToSelector:@selector(matchview:swipeDirection:)]) {
            [self.delegate matchview:self swipeDirection:SwipeDirectionRight];
        }
        x = self.center.x * 2 + view.frame.size.width / 2.0;
        if (view.center.y > self.center.y) //下
            y = self.center.y + s * (self.center.x * 2 + view.frame.size.width / 2.0);
        else//上
            y = self.center.y - s * (self.center.x * 2 + view.frame.size.width / 2.0);
    }
    self.canMatch = NO;
    [UIView animateWithDuration:.3 animations:^{
        
        view.center = CGPointMake(x, y);
    }completion:^(BOOL finished) {
        [self.usedArray removeObject:view];
        [view removeFromSuperview];
        [self.reusedArray addObject:view];
        self.canMatch = YES;
        if (self.index + self.usedArray.count + 1>= self.totalCount) {
            if (self.index != self.totalCount - 1) {
                self.index ++;
            }else{
                self.canMatch = NO;
                if ([self.delegate respondsToSelector:@selector(matchViewMatchDone:)]) {
                    [self.delegate matchViewMatchDone:self];
                }
            }
        }else{
            UIView * view = [self.dataSource matchView:self viewForRowAtIndex: ((int)self.index + (int)self.usedArray.count + 1)];
            [self addMatchView:view];
            self.index ++;
        }
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.canMatch) {
        return;
    }
    UITouch * touch = [touches anyObject];
    UIView * view = [self.usedArray firstObject];
    CGPoint point = [touch locationInView:self];
    if(CGRectContainsPoint(view.frame, point)){
        self.touchLocation = point;
    }else{
        self.touchLocation = CGPointZero;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.canMatch) {
        return;
    }
    UIView * view = [self.usedArray firstObject];
    if (!CGPointEqualToPoint(self.touchLocation, CGPointZero)) {
        CGPoint point = [[touches anyObject] locationInView:self];
        if (view) {
            view.center = CGPointMake(point.x + ( self.center.x - self.touchLocation.x), point.y + (self.center.y - self.touchLocation.y));
            CGFloat s = fabs(self.frame.size.width / 2.0 - view.center.x) / self.frame.size.width * 2.0;
            NSLog(@"%f",s);
            CGFloat ros = (self.frame.size.width / 2.0 - view.center.x) / self.frame.size.width * 2.0;
            view.transform = CGAffineTransformMakeRotation(M_PI_4 / 4 * - ros);
            [self setMatchViewScale:s];
            
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!self.canMatch) {
        return;
    }
    self.touchLocation = CGPointZero;
    UIView * view = [self.usedArray firstObject];
    
    
    if (fabs( view.center.x - self.center.x ) >= [self.delegate  matchViewSize].width / 2.0) {
        [self rmView:view];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            view.center = self.center;
            view.transform = CGAffineTransformMakeRotation(0);
            
            [self setMatchViewScale:0];
        }];
    }
}
@end
