//
//  PanelColorViewController.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "PanelColorViewController.h"

@interface PanelColorViewController ()
@property (strong, nonatomic) IBOutlet UIView *mainMenuOutlet;
@property (strong, nonatomic) IBOutlet UIView *colorMenuOutlet;
@property (strong, nonatomic) IBOutlet UIView *widthAndOpacityMenuOutlet;
@property (assign, nonatomic) CGFloat currentRed;
@property (assign, nonatomic) CGFloat currentGreen;
@property (assign, nonatomic) CGFloat currentBlue;
@property (assign, nonatomic) CGFloat currentOpacity;
@property (assign, nonatomic) CGFloat currentWidth;
@property (strong, nonatomic) IBOutlet UIView *colorViewIndicator;
@property (weak, nonatomic) IBOutlet UIView *widthAndOpacityViewIndicator;


@end

@implementation PanelColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentRed = 0.5;
    self.currentGreen = 0.5;
    self.currentBlue = 0.5;
    self.currentOpacity = 1;
    self.currentWidth = 5;
    self.colorViewIndicator.backgroundColor = [UIColor colorWithRed:self.currentRed
                                                              green:self.currentGreen
                                                               blue:self.currentBlue
                                                              alpha:1];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)didSelectItem:(UIButton *)sender
//{
//    [self.delegate didSelectColor:sender.backgroundColor];
//}

- (IBAction)ColorMenuItemDidChanged:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            self.colorMenuOutlet.hidden = NO;
            self.mainMenuOutlet.hidden = YES;
            break;
        case 2:
            self.widthAndOpacityMenuOutlet.hidden = NO;
            self.mainMenuOutlet.hidden = YES;
            break;
        case 3:
            
            break;
    }
}

- (IBAction)colorDidChanged:(UISlider *)sender
{
    switch (sender.tag)
    {
        case 1:
            self.currentRed = sender.value;
            break;
        case 2:
            self.currentGreen = sender.value;
            break;
        case 3:
            self.currentBlue = sender.value;
            break;
        default:
            break;
    }
    
    self.colorViewIndicator.backgroundColor = [UIColor colorWithRed:self.currentRed
                                          green:self.currentGreen
                                           blue:self.currentBlue
                                          alpha:1];
}


- (IBAction)didWidthGetChanged:(UISlider *)sender
{
    self.currentWidth = sender.value;
    
    CGRect r = self.widthAndOpacityViewIndicator.frame;
    
    UIGraphicsBeginImageContextWithOptions(r.size, YES, 0);
    
    CGPoint center = CGPointMake(self.widthAndOpacityViewIndicator.frame.size.width/2, self.widthAndOpacityViewIndicator.frame.size.height/2);
    
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:center
                                                         radius:sender.value/2
                                                     startAngle:0
                                                       endAngle:2*M_PI
                                                      clockwise:YES];
    
    UIColor *currentColor = [UIColor colorWithRed:self.currentRed
                                            green:self.currentGreen
                                             blue:self.currentBlue
                                            alpha:self.currentOpacity];
    
    [currentColor setFill];
    [aPath closePath];
    [aPath fill];
}

- (IBAction)didOpacityGetChanged:(UISlider *)sender
{
    self.currentOpacity = sender.value;
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:sender.view];
    if ([sender.view hitTest:location withEvent:nil].tag == -1)
    {
        [self.delegate didSelectColor:self.colorViewIndicator.backgroundColor];
        self.colorMenuOutlet.hidden = YES;
        self.mainMenuOutlet.hidden = NO;
    }
    else if ([sender.view hitTest:location withEvent:nil].tag == -2)
    {
        [self.delegate didSelectWidth:self.currentWidth AndOpacity:self.currentOpacity];
        self.widthAndOpacityMenuOutlet.hidden = YES;
        self.mainMenuOutlet.hidden = NO;
    }
    
}



- (void)setCurrentColor:(UIColor *)currentColor
{
    [self.delegate didSelectColor:currentColor];
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
