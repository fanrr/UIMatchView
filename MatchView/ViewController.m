//
//  ViewController.m
//  MatchView
//
//  Created by Raymond～ on 15/7/11.
//  Copyright (c) 2015年 Raymond～. All rights reserved.
//

#import "ViewController.h"
#import "UIMatchView.h"

#define width [UIScreen mainScreen].bounds.size.width
#define height [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIMatchViewDelegate, UIMatchViewDataSource>
@property (nonatomic, strong) UIMatchView * matchView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.matchView = [[UIMatchView alloc] initWithFrame:self.view.bounds];
    self.matchView.dataSource = self;
    self.matchView.delegate = self;
    [self.view addSubview:self.matchView];
    [self.matchView reloadMatchView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (UIView *)matchView:(UIMatchView *)matchView viewForRowAtIndex:(int)index{
    
    
    UIView * view;
    view = [matchView getReusedView];
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        view.layer.cornerRadius = 6;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor grayColor].CGColor;
        view.layer.borderWidth = .5;
        UILabel * lb = [[UILabel alloc] initWithFrame:view.bounds];
        lb.textColor = [UIColor blackColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:40];
        lb.tag = 10;
        [view addSubview:lb];
    }
    UILabel * lb = (UILabel *)[view viewWithTag:10];
    lb.text = [NSString stringWithFormat:@"%d",index];
    return view;
}
- (int)numberOfView{
    return 10;
}
- (CGSize)matchViewSize{
    return CGSizeMake(width - 100, height - 200);
}
- (void)matchViewMatchDone:(UIMatchView *)matchView{
    __weak ViewController * weak = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weak.matchView reloadMatchView];
    });
}
@end
