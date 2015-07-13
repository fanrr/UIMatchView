# UIMatchView
模仿探探,nice等左右滑动match的效果

![image](https://raw.githubusercontent.com/fanrr/UIMatchView/master/MatchView/Untitled.gif)


# 怎么用它？
```object-c
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

```
