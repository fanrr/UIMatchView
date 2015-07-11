//
//  MatchView.h
//  MatchView
//
//  Created by Raymond～ on 15/7/11.
//  Copyright (c) 2015年 Raymond～. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIMatchView;
@protocol UIMatchViewDataSource
- (UIView * )matchView:(UIMatchView *)matchView viewForRowAtIndex:(int)index;
- (int )numberOfView;
@end
@protocol UIMatchViewDelegate
- (CGSize)matchViewSize;

@end
@interface UIMatchView : UIView
@property (nonatomic, weak) id <UIMatchViewDataSource> dataSource;
@property (nonatomic, weak) id <UIMatchViewDelegate>   delegate;
- (void)reloadMatchView;
@end
