//
//  ViewController.m
//  PongTest
//
//  Created by it-högskolan on 2015-02-13.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak)    IBOutlet UIImageView *blueAnim;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.blueAnim.animationImages = [NSArray arrayWithObjects:
            [UIImage imageNamed:@"bluebackground"],
            [UIImage imageNamed:@"animbackground2"],
            [UIImage imageNamed:@"animbackground1"], nil];
    [self.blueAnim setAnimationRepeatCount:0];
    self.blueAnim.animationDuration = 2;
    [self.blueAnim startAnimating];
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
