# UIMatchView
模仿探探,nice等左右滑动match的效果

![image](https://raw.githubusercontent.com/fanrr/UIMatchView/master/MatchView/Untitled.gif)


# 怎么用它？
```objc
/**
 *  按照index返回View
 *
 *  @param matchView matchView
 *  @param index     第几个
 *
 *  @return view
 */
- (UIView * )matchView:(UIMatchView *)matchView viewForRowAtIndex:(int)index;
```
```objc
/**
 *  返回共有多少个
 *
 *  @return number
 */
- (int )numberOfView;
```
```objc
/**
 *  每一个的尺寸
 *
 *  @return CGSize
 */
- (CGSize)matchViewSize;
```
```objc
/**
 *  卡片滑完之后的回调
 *
 *  @param matchView UIMatchView
 */
- (void)matchViewMatchDone:(UIMatchView *)matchView;
```
```objc
/**
 *  滑动消失时候调用
 *
 *  @param matchview      UIMatchView
 *  @param swipeDirection 消失方向
 */
 - (void)matchview:(UIMatchView *)matchview swipeDirection:(SwipeDirection)swipeDirection;
```
方法的调用以及代理和UITableView相似
