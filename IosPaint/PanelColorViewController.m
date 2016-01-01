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
@property (weak, nonatomic) IBOutlet UIImageView *colorViewIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *widthAndOpacityViewIndicator;


@end

@implementation PanelColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentRed = 0.5;
    self.currentGreen = 0.5;
    self.currentBlue = 0.5;
    self.currentOpacity = 1;
    self.currentWidth = 5;
    [self setNeedsOfIndicator:self.widthAndOpacityViewIndicator];
    [self setNeedsOfIndicator:self.colorViewIndicator];
//    self.colorViewIndicator.backgroundColor = [UIColor colorWithRed:self.currentRed
//                                                              green:self.currentGreen
//                                                               blue:self.currentBlue
//                                                              alpha:1];
    
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
    [self setNeedsOfIndicator:self.colorViewIndicator];
}


- (IBAction)didWidthGetChanged:(UISlider *)sender
{
    self.currentWidth = sender.value;
    
    [self setNeedsOfIndicator:self.widthAndOpacityViewIndicator];
}

- (IBAction)didOpacityGetChanged:(UISlider *)sender
{
    self.currentOpacity = sender.value;
    [self setNeedsOfIndicator:self.widthAndOpacityViewIndicator];
}

- (void)setNeedsOfIndicator:(UIImageView *)indicator
{
    UIGraphicsBeginImageContext(indicator.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    if (indicator == self.widthAndOpacityViewIndicator)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.currentWidth);
    else if (indicator == self.colorViewIndicator)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(),40);
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.currentRed, self.currentGreen, self.currentBlue, self.currentOpacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 20, 20);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 20, 20);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    if (indicator == self.widthAndOpacityViewIndicator)
        self.widthAndOpacityViewIndicator.image = UIGraphicsGetImageFromCurrentImageContext();
    else if (indicator == self.colorViewIndicator)
        self.colorViewIndicator.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

//The event handling method
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:sender.view];
    if ([sender.view hitTest:location withEvent:nil].tag == -1)
    {
        [self.delegate didSelectColor:[UIColor colorWithRed:self.currentRed green:self.currentGreen blue:self.currentBlue alpha:self.currentOpacity]];
        self.colorMenuOutlet.hidden = YES;
        self.mainMenuOutlet.hidden = NO;
    }
    else if ([sender.view hitTest:location withEvent:nil].tag == -2)
    {
        [self.delegate didSelectWidth:self.currentWidth];
        [self.delegate didSelectColor:[UIColor colorWithRed:self.currentRed green:self.currentGreen blue:self.currentBlue alpha:self.currentOpacity]];
        self.widthAndOpacityMenuOutlet.hidden = YES;
        self.mainMenuOutlet.hidden = NO;
    }
    
}


/*
- (void)setCurrentColor:(UIColor *)currentColor
{
    [self.delegate didSelectColor:currentColor];
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
