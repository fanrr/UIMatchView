# UIMatchView
模仿探探,nice等左右滑动match的效果

![image](https://raw.githubusercontent.com/fanrr/UIMatchView/master/MatchView/Untitled.gif)


# 怎么用它？
```object-c
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
```object-c
/**
 *  返回共有多少个
 *
 *  @return number
 */
- (int )numberOfView;
```
```object-c
/**
 *  每一个的尺寸
 *
 *  @return CGSize
 */
- (CGSize)matchViewSize;
```
```object-c
/**
 *  卡片滑完之后的回调
 *
 *  @param matchView UIMatchView
 */
- (void)matchViewMatchDone:(UIMatchView *)matchView;
```
```object-c
/**
 *  滑动消失时候调用
 *
 *  @param matchview      UIMatchView
 *  @param swipeDirection 消失方向
 */
 - (void)matchview:(UIMatchView *)matchview swipeDirection:(SwipeDirection)swipeDirection;
```
方法的调用以及代理和UITableView相似
