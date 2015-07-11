//
//  ViewController.m
//  MatchView
//
//  Created by Raymond～ on 15/7/11.
//  Copyright (c) 2015年 Raymond～. All rights reserved.
//

#import "ViewController.h"
#import "UIMatchView.h"


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
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    view.layer.cornerRadius = 6;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = .5;
    return view;
}
- (int)numberOfView{
    return 5;
}
- (CGSize)matchViewSize{
    return CGSizeMake(300, 500);
}
@end
