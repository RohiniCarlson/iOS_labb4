//
//  Game.m
//  PongTest
//
//  Created by it-högskolan on 2015-02-13.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "Game.h"

@interface Game ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@property (weak, nonatomic) IBOutlet UIImageView *ball;

@property (weak, nonatomic) IBOutlet UIImageView *humanPlayer;

@property (weak, nonatomic) IBOutlet UIImageView *AIPlayer;

@property (weak, nonatomic) IBOutlet UILabel *winLoseMessage;

@property (weak, nonatomic) IBOutlet UILabel *AIScoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *humanScoreLabel;

@property (nonatomic) NSTimer *timer;

@property (nonatomic) int X;
@property (nonatomic) int Y;
@property (nonatomic) int AIScore;
@property (nonatomic) int HumanScore;

@end

@implementation Game

- (void)viewDidLoad {
    [super viewDidLoad];
    self.HumanScore = 0;
    self.AIScore = 0;

    // Do any additional setup after loading the view.
    //self.exitButton.hidden = TRUE;
}

- (IBAction)startButtonClicked:(id)sender {
    /*[self.startButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];*/
    self.startButton.hidden = YES;
     self.winLoseMessage.hidden = YES;
    
    self.Y = arc4random() % 11;
    self.Y = self.Y-5; // gives 50% chance of moving up or down
    self.X = arc4random() % 11;
    self.X = self.X-5; // gives 50% of moving right or left
    if (self.Y == 0) {
        self.Y = 1; // Ensures that the ball does not just move up and down
    }
    if (self.X == 0) {
        self.X = 1; // Ensures that the ball does not just move from left to right
        
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *slide = [[event allTouches]anyObject];
    self.humanPlayer.center = [slide locationInView:self.view];
    if((self.humanPlayer.center.y > 447) || (self.humanPlayer.center.y <447)) {
        self.humanPlayer.center = CGPointMake(self.humanPlayer.center.x, 447);
    }
    if (self.humanPlayer.center.x < 0) {
        self.humanPlayer.center = CGPointMake(0, self.humanPlayer.center.y);
    }
    if(self.humanPlayer.center.x > 250) {
        self.humanPlayer.center = CGPointMake(250, self.humanPlayer.center.y);
    }
}

-(void)collision {
    if(CGRectIntersectsRect(self.ball.frame, self.humanPlayer.frame)) {
        self.Y = arc4random() %5;
        self.Y = self.Y-5;
        // play sound
    }
    if(CGRectIntersectsRect(self.ball.frame, self.AIPlayer.frame)) {
        self.Y = arc4random() %5;
        // play sound
    }
}

-(void) moveAIPlayerPaddle {
    if(self.ball.center.x < self.AIPlayer.center.x){
        self.AIPlayer.center = CGPointMake(self.AIPlayer.center.x-2, self.AIPlayer.center.y);
    }
    if(self.ball.center.x > self.AIPlayer.center.x) {
        self.AIPlayer.center = CGPointMake(self.AIPlayer.center.x+2, self.AIPlayer.center.y);
    }
    
    if (self.AIPlayer.center.x < 0) {
        self.AIPlayer.center = CGPointMake(0, self.AIPlayer.center.y);
    }
    if(self.AIPlayer.center.x > 250) {
        self.AIPlayer.center = CGPointMake(250, self.AIPlayer.center.y);
    }
}

-(void) moveBall {
    [self moveAIPlayerPaddle];
    [self collision];
    self.ball.center = CGPointMake(self.ball.center.x + self.X, self.ball.center.y + self.Y);
    if(self.ball.center.x < 15){
        self.X = 0 - self.X;
        //play sound
    }
    if(self.ball.center.x > 305)
    {
        self.X = 0 - self.X;
        // play sound
    }
   /* if (self.ball.center.y < self.view.frame.size.height) {
        self.HumanScore += 1;
        self.humanScoreLabel.text = [NSString stringWithFormat:@"%d",self.HumanScore];
    } else if (self.ball.center.y > self.view.frame.size.height)
    {
        self.AIScore += 1;
        self.AIScoreLabel.text  = [NSString stringWithFormat:@"%d",self.AIScore];
        //self.winLoseMessage.hidden = NO;
       // [self.timer invalidate];
       // self.startButton.hidden = NO;
       // self.ball.center = CGPointMake(self.view.center.x+15, self.view.center.y+15);
    }*/
    if(self.HumanScore == 5) {
        self.startButton.hidden = NO;
        [self.timer invalidate];
        self.winLoseMessage.hidden = NO;
        self.winLoseMessage.text = [NSString stringWithFormat:@"You Win!"];
        self.HumanScore = 0;
        self.AIScore = 0;
         // set balls and paddles back to starting position.
    } else if (self.AIScore == 5) {
        [self.timer invalidate];
        self.startButton.hidden = NO;
        self.winLoseMessage.hidden = NO;
        self.winLoseMessage.text = [NSString stringWithFormat:@"You Lose!"];
        self.HumanScore = 0;
        self.AIScore = 0;
        // set balls and paddles back to starting position.

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
