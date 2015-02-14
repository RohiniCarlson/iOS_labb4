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

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (nonatomic) float screenHeight;
@property (nonatomic) float screenWidth;
@property (nonatomic) float X;
@property (nonatomic) float Y;
@property (nonatomic) int AIScore;
@property (nonatomic) int HumanScore;

@end

@implementation Game

-(void) placeObjects{
    //self.ball.center = self.view.center;
    self.ball.center = CGPointMake(self.screenWidth/2.0f, self.screenHeight/2.0f);
    self.humanPlayer.center = CGPointMake(self.screenWidth/2.0f, self.screenHeight-30.0f);
    self.AIPlayer.center = CGPointMake(self.screenWidth/2.0f, 30.0f);
}

-(void)viewDidLayoutSubviews{
    [self placeObjects];
    self.startButton.center = CGPointMake(self.screenWidth/2.0f, self.screenHeight/2.0f);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getScreenWidthHeight];
    self.HumanScore = 0;
    self.AIScore = 0;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"bounce"
                                         ofType:@"mp3"]];
    self.audioPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:url
                                  error:nil];
    //[self.audioPlayer play];
    
}

-(void) getScreenWidthHeight{
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
}

- (IBAction)startButtonClicked:(id)sender {
    self.startButton.hidden = YES;
     self.winLoseMessage.hidden = YES;
    [self initializeBallMovement];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
}

-(void)initializeBallMovement {
    
    [self placeObjects];
    self.Y = arc4random() % 11;
    self.Y = self.Y-5; // gives 50% chance of moving up or down
    self.X = arc4random() % 11;
    self.X = self.X-5; // gives 50% of moving right or left
    if (self.Y == 0) {
        self.Y = 1; // Ensures that the ball does not just move left and right
    }
    if (self.X == 0) {
        self.X = 1; // Ensures that the ball does not move straight up and down
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *slide = [[event allTouches]anyObject];
    
    CGPoint position = [slide locationInView:self.view];
    
    if(position.x > self.humanPlayer.center.x) {
       self.humanPlayer.center = CGPointMake(self.humanPlayer.center.x+4.0f, self.humanPlayer.center.y);
    } else if (position.x < self.humanPlayer.center.x){
       self.humanPlayer.center = CGPointMake(self.humanPlayer.center.x-4.0f, self.humanPlayer.center.y);
    }
    


     if (self.humanPlayer.center.x < 35.0f) {
        self.humanPlayer.center = CGPointMake(35.0f, self.humanPlayer.center.y);
     }
     if(self.humanPlayer.center.x > self.screenWidth-35.0f) {
        self.humanPlayer.center = CGPointMake(self.screenWidth-35.0f, self.humanPlayer.center.y);
     }
     
}

-(void)collision {
    if(CGRectIntersectsRect(self.ball.frame, self.humanPlayer.frame)) {
        self.Y = arc4random() %5;
        self.Y = self.Y-5;
        // play sound
        [self.audioPlayer play];
    }
    if(CGRectIntersectsRect(self.ball.frame, self.AIPlayer.frame)) {
        self.Y = arc4random() %5;
        // play sound
        [self.audioPlayer play];
    }
}

-(void) moveAIPlayerPaddle {
    if(self.ball.center.x < self.AIPlayer.center.x){
        self.AIPlayer.center = CGPointMake(self.AIPlayer.center.x-2, self.AIPlayer.center.y);
    }
    if(self.ball.center.x > self.AIPlayer.center.x) {
        self.AIPlayer.center = CGPointMake(self.AIPlayer.center.x+2, self.AIPlayer.center.y);
    }
    
    if (self.AIPlayer.center.x < 35.0f) {
        self.AIPlayer.center = CGPointMake(35.0f, self.AIPlayer.center.y);
    }
    if(self.AIPlayer.center.x > self.screenWidth-35.0f) {
        self.AIPlayer.center = CGPointMake(self.screenWidth-35.0f, self.AIPlayer.center.y);
    }
}

-(void) moveBall {
    [self moveAIPlayerPaddle];
    [self collision];
    self.ball.center = CGPointMake(self.ball.center.x + self.X, self.ball.center.y + self.Y);
    if(self.ball.center.x < 15){
        self.X = 0 - self.X;
        //play sound
        [self.audioPlayer play];
    }
    if(self.ball.center.x > self.screenWidth -15.0f)
    {
        self.X = 0 - self.X;
        // play sound
        [self.audioPlayer play];
    }
    if (self.ball.center.y < 15.0f) {
        self.HumanScore += 1;
        self.humanScoreLabel.text = [NSString stringWithFormat:@"%d",self.HumanScore];
        [self initializeBallMovement];
    } else if (self.ball.center.y > self.screenHeight-15.0f)
    {
        self.AIScore += 1;
        self.AIScoreLabel.text  = [NSString stringWithFormat:@"%d",self.AIScore];
        [self initializeBallMovement];
    }
    if(self.HumanScore == 5) {
        self.startButton.hidden = NO;
        [self.timer invalidate];
        self.winLoseMessage.hidden = NO;
        self.winLoseMessage.text = [NSString stringWithFormat:@"You Win!"];
        self.HumanScore = 0;
        self.AIScore = 0;
        self.humanScoreLabel.text = [NSString stringWithFormat:@"%d",self.HumanScore];
        self.AIScoreLabel.text = [NSString stringWithFormat:@"%d",self.AIScore];
        [self placeObjects];
    } else if (self.AIScore == 5) {
        [self.timer invalidate];
        self.startButton.hidden = NO;
        self.winLoseMessage.hidden = NO;
        self.winLoseMessage.text = [NSString stringWithFormat:@"You Lose!"];
        self.HumanScore = 0;
        self.AIScore = 0;
        self.humanScoreLabel.text = [NSString stringWithFormat:@"%d",self.HumanScore];
        self.AIScoreLabel.text = [NSString stringWithFormat:@"%d",self.AIScore];
        [self placeObjects];
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
