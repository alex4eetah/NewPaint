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
@property (weak, nonatomic) IBOutlet UIView *recentSettingsOutlet;
@property (assign, nonatomic) CGFloat currentRed;
@property (assign, nonatomic) CGFloat currentGreen;
@property (assign, nonatomic) CGFloat currentBlue;
@property (assign, nonatomic) CGFloat currentOpacity;
@property (assign, nonatomic) CGFloat currentWidth;
@property (weak, nonatomic) IBOutlet UIImageView *colorViewIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *widthAndOpacityViewIndicator;

@property (weak, nonatomic) IBOutlet UIPickerView *colorPicker;
@property (strong, nonatomic) NSMutableArray *recentColors;//10 max
@property (weak, nonatomic) IBOutlet UIImageView *recentColorViewIndicator;
@property (strong, nonatomic) UIColor * thisColor;

@end

@implementation PanelColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentRed = 0;
    self.currentGreen = 0;
    self.currentBlue = 0;
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

#pragma mark - main menu settings
- (IBAction)ColorMenuItemDidChanged:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.mainMenuOutlet.alpha = 0.0;
            weakSelf.colorMenuOutlet.alpha = 1.0;
        }];
    }
    else if (sender.tag == 2)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.mainMenuOutlet.alpha = 0.0;
            weakSelf.widthAndOpacityMenuOutlet.alpha = 1.0;
        }];
    }
    else if (sender.tag == 3)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.mainMenuOutlet.alpha = 0.0;
            weakSelf.recentSettingsOutlet.alpha = 1.0;
        }];
        [self.resizerDelegate resizeColorContainerHeightTo:100];
        self.colorPicker.delegate = self;
    }
}

#pragma mark - color/width/alpha settings
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

#pragma mark - applying changes and back to main menu
- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:sender.view];
    if ([sender.view hitTest:location withEvent:nil].tag == -1)
    {
        [self.delegate didSelectColor:[UIColor colorWithRed:self.currentRed green:self.currentGreen blue:self.currentBlue alpha:self.currentOpacity]];
        
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.colorMenuOutlet.alpha = 0.0;
            weakSelf.mainMenuOutlet.alpha = 1.0;
        }];
    }
    else if ([sender.view hitTest:location withEvent:nil].tag == -2)
    {
        [self.delegate didSelectWidth:self.currentWidth];
        [self.delegate didSelectColor:[UIColor colorWithRed:self.currentRed green:self.currentGreen blue:self.currentBlue alpha:self.currentOpacity]];
       
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.widthAndOpacityMenuOutlet.alpha = 0.0;
            weakSelf.mainMenuOutlet.alpha = 1.0;
        }];
    }
    else if ([sender.view hitTest:location withEvent:nil].tag == -3)
    {
        [self.delegate didSelectWidth:self.currentWidth];
        if (self.thisColor)
            [self.delegate didSelectColor:self.thisColor];
        else
            [self.delegate didSelectColor:[UIColor blackColor]];
        [self.resizerDelegate resizeColorContainerHeightTo:40];
        
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.recentSettingsOutlet.alpha = 0.0;
            weakSelf.mainMenuOutlet.alpha = 1.0;
        }];
    }
    
    if ([sender.view hitTest:location withEvent:nil].tag != -3)
    {
        if (!self.recentColors)
        {
            self.recentColors = [[NSMutableArray alloc] init];
        }
        else if (![self.recentColors containsObject:[UIColor colorWithRed:self.currentRed
                                                                  green:self.currentGreen
                                                                   blue:self.currentBlue
                                                                  alpha:self.currentOpacity]])

        {
            static NSInteger i = 0;
            
            if (i >= 10)
                i = 0;
            if (self.recentColors.count)
                [self.recentColors insertObject:[UIColor colorWithRed:self.currentRed green:self.currentGreen blue:self.currentBlue alpha:self.currentOpacity] atIndex:i];
            else
                [self.recentColors addObject:[UIColor colorWithRed:self.currentRed green:self.currentGreen blue:self.currentBlue alpha:self.currentOpacity]];
            i++;
        }
    }
}

#pragma mark - pickerMethods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.recentColors.count)
        return self.recentColors.count;
    else
        return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    CGFloat thisRed;
    CGFloat thisGreen;
    CGFloat thisBlue;
    CGFloat thisOpacity;
    
    if (self.recentColors.count)
    {
        self.thisColor = self.recentColors[row];
        const CGFloat* components = CGColorGetComponents(self.thisColor.CGColor);
        thisRed = components[0];
        thisGreen = components[1];
        thisBlue = components[2];
        thisOpacity = CGColorGetAlpha(self.thisColor.CGColor);
    }
    else
    {
        thisRed = 0;
        thisGreen = 0;
        thisBlue = 0;
        thisOpacity = 1;
    }
    
    UIGraphicsBeginImageContext(self.recentColorViewIndicator.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),100);
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), thisRed, thisGreen, thisBlue, thisOpacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 50, 50);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 50, 50);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.recentColorViewIndicator.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"To apply push this ->";
    NSAttributedString *attString;
    if (self.recentColors.count)
    {
        attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:self.recentColors[row]}];
    }
    else
    {
        attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    [self pickerView:self.colorPicker didSelectRow:1 inComponent:1];
    
    return attString;
    
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
