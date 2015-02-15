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

@property (weak, nonatomic) IBOutlet UIButton *gameTitle;

@property (nonatomic) float screenHeight;

@property (nonatomic) float screenWidth;

@end

@implementation ViewController

-(void) viewDidLayoutSubviews{
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
    self.gameTitle.center = CGPointMake(self.screenWidth/2.0f, self.screenHeight/2.0f);
}

- (void)viewDidLoad {
    self.blueAnim.animationImages = [NSArray arrayWithObjects:
            [UIImage imageNamed:@"animbackground4"],
            [UIImage imageNamed:@"bluebackground"], nil];
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
