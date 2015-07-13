//
//  MatchView.h
//  MatchView
//
//  Created by Raymond～ on 15/7/11.
//  Copyright (c) 2015年 Raymond～. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    /**
     *  从左侧滑动消失
     */
    SwipeDirectionLeft,
    /**
     *  从右侧滑动消失
     */
    SwipeDirectionRight
    
} SwipeDirection;

@class UIMatchView;
@protocol UIMatchViewDataSource
/**
 *  按照index返回View
 *
 *  @param matchView matchView
 *  @param index     第几个
 *
 *  @return view
 */
- (UIView * )matchView:(UIMatchView *)matchView viewForRowAtIndex:(int)index;
/**
 *  返回共有多少个
 *
 *  @return number
 */
- (int )numberOfView;
@end
@protocol UIMatchViewDelegate
/**
 *  每一个的尺寸
 *
 *  @return CGSize
 */
- (CGSize)matchViewSize;
/**
 *  卡片滑完之后的回调
 *
 *  @param matchView UIMatchView
 */
- (void)matchViewMatchDone:(UIMatchView *)matchView;
/**
 *  滑动消失时候调用
 *
 *  @param matchview      UIMatchView
 *  @param swipeDirection 消失方向
 */
- (void)matchview:(UIMatchView *)matchview swipeDirection:(SwipeDirection)swipeDirection;
@end
@interface UIMatchView : UIView
@property (nonatomic, weak) id <UIMatchViewDataSource> dataSource;
@property (nonatomic, weak) NSObject  <UIMatchViewDelegate>  * delegate;
/**
 *  获取重用
 *
 *  @return UIView
 */
- (UIView *)getReusedView;
/**
 *  重新加载
 */
- (void)reloadMatchView;
@end
