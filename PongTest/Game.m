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
@property (nonatomic) int pause;
@property (nonatomic) float fingerX;

@end

@implementation Game

-(void) placeObjects{
    self.ball.center = CGPointMake(self.screenWidth/2.0f, self.screenHeight/2.0f);
    self.humanPlayer.center = CGPointMake(self.screenWidth/2.0f, self.screenHeight-30.0f);
    self.AIPlayer.center = CGPointMake(self.screenWidth/2.0f, 30.0f);
    
}

-(void)viewDidLayoutSubviews{
    [self placeObjects];
    self.AIScoreLabel.center = CGPointMake(50.0f, 30.0f);
    self.humanScoreLabel.center = CGPointMake(50.0f, self.screenHeight-30.0f);
    self.startButton.center = CGPointMake(self.screenWidth/2.0f, self.screenHeight/2.0f);
}

-(void) getScreenWidthHeight{
    self.screenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.screenHeight = [[UIScreen mainScreen] bounds].size.height;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self getScreenWidthHeight];
    self.HumanScore = 0;
    self.AIScore = 0;
    self.pause = 0;
    self.fingerX = -1.0f;
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"bounce"
                                         ofType:@"mp3"]];
    self.audioPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:url
                                  error:nil];
    [self.audioPlayer play];
}

- (IBAction)startButtonClicked:(id)sender {
    self.startButton.hidden = YES;
    self.winLoseMessage.hidden = YES;
    self.HumanScore = 0;
    self.AIScore = 0;
    self.humanScoreLabel.text = [NSString stringWithFormat:@"%d",self.HumanScore];
    self.AIScoreLabel.text = [NSString stringWithFormat:@"%d",self.AIScore];
    [self initializeBallMovement];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];
}

-(void)initializeBallMovement {
    [self placeObjects];
    self.pause = 50;
    self.Y = arc4random() % 7;
    self.Y = self.Y-3; // gives 50% chance of moving up or down
    self.X = arc4random() % 7;
    self.X = self.X-3; // gives 50% of moving right or left
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
    self.fingerX = position.x;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint position = [touch locationInView:self.view];
    self.fingerX = position.x;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.fingerX = -1.0f;
}

-(void) movePlayerPaddle{
    [self movePaddle:self.humanPlayer andXValue:self.fingerX andSpeed:2.5f];
}

-(void) moveAIPlayerPaddle{
    [self movePaddle:self.AIPlayer andXValue:self.ball.center.x andSpeed:1.0f];
}

-(void) movePaddle:(UIImageView*)paddle andXValue:(float)targetX andSpeed:(float)speed {
    if(targetX<0.0f){
        return;
    }
    if(targetX > paddle.center.x+6.0f) {
        paddle.center = CGPointMake(paddle.center.x+speed, paddle.center.y);
    } else if (targetX < paddle.center.x-6.0f){
        paddle.center = CGPointMake(paddle.center.x-speed, paddle.center.y);
    }
    
    if (paddle.center.x < 35.0f) {
        paddle.center = CGPointMake(35.0f, paddle.center.y);
    } else if(paddle.center.x > self.screenWidth-35.0f) {
        paddle.center = CGPointMake(self.screenWidth-35.0f, paddle.center.y);
    }
}

-(void)adjustX:(float) xOffset{
    if(abs(xOffset)>20) {
        if((xOffset<-34.0f && self.X>0.0f) || (xOffset>34.0f && self.X<0.0f)) { // ball hits very edge of paddle, speed remains the same.
            self.X = -self.X;
        } else {
           float speedAdjust = 1.0f + (abs(xOffset)-20)/15; // calculates the speed.
           if((xOffset<0.0f && self.X>0.0f) || (xOffset>0.0f && self.X<0.0f)) { // ball hits near side of paddle, speed is decreased.
              if(self.X>0.5f || self.X<-0.5f) { // check to ensure that X does not become equal to zero.
                 self.X = self.X/speedAdjust;
              }
           } else {
              self.X = self.X*speedAdjust; // ball hits far side of paddle, speed is increased.
           }
        }
    }
}

-(void)collision{
    if(self.Y>0.0f && CGRectIntersectsRect(self.ball.frame, self.humanPlayer.frame) && self.ball.center.y < self.screenHeight-30.0f) {
        // bounce and increment speed
        self.Y = -(self.Y + 0.1f);
        [self adjustX:(self.ball.center.x - self.humanPlayer.center.x)]; // Adjusts x accordingly depending on where the ball hits the paddle.
        [self.audioPlayer play];
    }
    if(self.Y<0.0f && CGRectIntersectsRect(self.ball.frame, self.AIPlayer.frame) && self.ball.center.y > 30.0f) {
        // bounce and increment speed
        self.Y = -self.Y + 0.1f;
        [self adjustX:(self.ball.center.x - self.AIPlayer.center.x )]; // Adjusts x accordingly depending on where the ball hits the paddle.
        [self.audioPlayer play];
    }
}

-(void) moveBall{
    [self moveAIPlayerPaddle];
    [self movePlayerPaddle];
    
    if(self.pause > 0) {
        self.pause = self.pause-1;
        return;
    }

    [self collision];
    self.ball.center = CGPointMake(self.ball.center.x + self.X, self.ball.center.y + self.Y);
    if(self.ball.center.x < 15){ // ball has touched left edge of screen
        self.X = 0 - self.X;
        [self.audioPlayer play];
    } else if(self.ball.center.x > self.screenWidth -15.0f){ // ball has touched right edge of screen
        self.X = 0 - self.X;
        [self.audioPlayer play];
    }
    
    if (self.ball.center.y < 15.0f){ // ball has touched top edge of screen. Human scores.
        self.HumanScore += 1;
        self.humanScoreLabel.text = [NSString stringWithFormat:@"%d",self.HumanScore];
        [self initializeBallMovement];
    } else if (self.ball.center.y > self.screenHeight-15.0f){ // ball has touched bottome edge of screen. Computer scores.
        self.AIScore += 1;
        self.AIScoreLabel.text  = [NSString stringWithFormat:@"%d",self.AIScore];
        [self initializeBallMovement];
    }
    if(self.HumanScore == 5){ // human wins, max score reached.
        self.startButton.hidden = NO;
        [self.timer invalidate]; // stop timer.
        self.winLoseMessage.hidden = NO;
        self.winLoseMessage.text = [NSString stringWithFormat:@"You Win!"];
        [self placeObjects];
    } else if (self.AIScore == 5){ // computer wins, max score reached.
        [self.timer invalidate]; // stop timer.
        self.startButton.hidden = NO;
        self.winLoseMessage.hidden = NO;
        self.winLoseMessage.text = [NSString stringWithFormat:@"You Lose!"];
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
