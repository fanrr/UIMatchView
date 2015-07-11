//
//  MatchView.m
//  MatchView
//
//  Created by Raymond～ on 15/7/11.
//  Copyright (c) 2015年 Raymond～. All rights reserved.
//

#import "UIMatchView.h"
@interface UIMatchView ()
@property (nonatomic, strong) NSMutableArray * reusedArray;
@property (nonatomic, strong) NSMutableArray * usedArray;
@property (nonatomic, assign) CGPoint          touchLocation;
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
    }
    return self;
}
- (void)reloadMatchView{
    [self setMatchCell];
    [self setMatchCellLocation];
}
- (void)setMatchCell{
    [self.usedArray removeAllObjects];
    int number = [self.dataSource numberOfView];
    for (int i = 0; i < number; i ++) {
        UIView * view = [self.dataSource matchView:self viewForRowAtIndex:i];
        [self.usedArray addObject:view];
    }
}
- (void)setMatchCellLocation{
    __weak UIMatchView * weak_self = self;
    [self.usedArray enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        NSUInteger index = idx;
        if (index > 3) {
            index = 3;
        }
        obj.frame = CGRectMake(0, 0, [weak_self.delegate matchViewSize].width,[weak_self.delegate matchViewSize].height);
        obj.transform = CGAffineTransformMakeScale(1-index * 0.02, 1-index * 0.02);
        obj.center = CGPointMake(weak_self.center.x, weak_self.center.y + index *10);
        [weak_self insertSubview:obj atIndex:0];
    }];
}
- (void)setMatchCellScale:(CGFloat)s{
    if (s >= 1) {
        s = 1;
    }
    __weak UIMatchView * weak_self = self;
    [self.usedArray enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        if (idx && idx <4) {
            obj.transform = CGAffineTransformMakeScale(1- idx * 0.02 + 0.02*s, 1- idx * 0.02 + 0.02*s);
            obj.center = CGPointMake(weak_self.center.x, weak_self.center.y + idx * 10 - 10 * s);
        }
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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
    UIView * view = [self.usedArray firstObject];
    if (!CGPointEqualToPoint(self.touchLocation, CGPointZero)) {
        CGPoint point = [[touches anyObject] locationInView:self];
        if (view) {
            view.center = CGPointMake(point.x + ( self.center.x - self.touchLocation.x), point.y + (self.center.y - self.touchLocation.y));
            CGFloat s = fabs(self.frame.size.width / 2.0 - view.center.x) / self.frame.size.width * 2.0;
            [self setMatchCellScale:s];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchLocation = CGPointZero;
    UIView * view = [self.usedArray firstObject];
    
    
    if (fabs( view.center.x - self.center.x ) >= [self.delegate  matchViewSize].width / 2.0) {
        [self rmView:view];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            view.center = self.center;
            [self setMatchCellScale:0];
        }];
    }
}
- (void)rmView:(UIView *)view{
    
    CGFloat s = fabs((view.center.y - self.center.y) / (view.center.x - self.center.x));
    CGFloat x;
    CGFloat y;
    if (view.center.x < self.center.x) {//左
        x = - view.frame.size.width / 2.0;
        if (view.center.y > self.center.y) { //下
            y = self.center.y + s * (self.center.x + view.frame.size.width / 2.0);
        }else{//上
            y = self.center.y - s * (self.center.x + view.frame.size.width / 2.0);
        }
    }else{//右
        x = self.center.x * 2 + view.frame.size.width / 2.0;
        if (view.center.y > self.center.y) { //下
            y = self.center.y + s * self.center.x * 2 + view.frame.size.width / 2.0;
        }else{//上
            y = self.center.y - s * self.center.x * 2 + view.frame.size.width / 2.0;
        }
    }
    [UIView animateWithDuration:.1 animations:^{
        view.center = CGPointMake(x, y);
    }completion:^(BOOL finished) {
        [self.usedArray removeObject:view];
        if (self.usedArray.count == 0) {
            [self reloadMatchView];
        }
    }];
}
@end
