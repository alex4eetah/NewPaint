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
@property (weak, nonatomic) IBOutlet UIView *randomOrRealColorSettings;
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
@property (strong, nonatomic) UIColor * colorChosenWithPicker;

//sliders to set color compontnts
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;


@end

@implementation PanelColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentRed = 0;
    self.currentGreen = 0;
    self.currentBlue = 0;
    self.currentOpacity = 1;
    self.currentWidth = 5;
    [self setNeedsOfIndicator:self.widthAndOpacityViewIndicator
                      WithRed:self.currentRed
                    WithGreen:self.currentGreen
                     WithBlue:self.currentBlue
                    WithAlpha:self.currentOpacity];
    [self setNeedsOfIndicator:self.colorViewIndicator
                      WithRed:self.currentRed
                    WithGreen:self.currentGreen
                     WithBlue:self.currentBlue
                    WithAlpha:self.currentOpacity];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
}

#pragma mark - main menu settings
- (IBAction)ColorMenuItemDidChanged:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.mainMenuOutlet.alpha = 0.0;
            weakSelf.randomOrRealColorSettings.alpha = 1.0;
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
        if (!self.colorPicker.delegate)
            self.colorPicker.delegate = self;
        [self pickerView:self.colorPicker didSelectRow:0 inComponent:0];
    }
}

# pragma mark random/real color settings
- (IBAction)randomrealSettingsItemDidChanged:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
        {
            __typeof(self) __weak weakSelf = self;
            [UIView animateWithDuration:0.3 animations:^() {
                
                weakSelf.randomOrRealColorSettings.alpha = 0.0;
                weakSelf.mainMenuOutlet.alpha = 1.0;
            }];
            self.currentRed = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
            self.currentGreen = ( arc4random() % 256 / 256.0 );
            self.currentBlue = ( arc4random() % 256 / 256.0 );
            self.currentOpacity= (arc4random() % 256 / 256.0 )+0.1; // 0.1 to 1.0
            
            [self.delegate didSelectColor:[UIColor colorWithRed:self.currentRed
                                                          green:self.currentGreen
                                                           blue:self.currentBlue
                                                          alpha:self.currentOpacity]];
            
            [self insertInRecentColorsColorWithRed:self.currentRed
                                             Green:self.currentGreen
                                              Blue:self.currentBlue
                                             Alpha:self.currentOpacity];
            
            [self setNeedsOfIndicator:self.colorViewIndicator
                              WithRed:self.currentRed
                            WithGreen:self.currentGreen
                             WithBlue:self.currentBlue
                            WithAlpha:self.currentOpacity];
            
            [self setNeedsOfIndicator:self.widthAndOpacityViewIndicator
                              WithRed:self.currentRed
                            WithGreen:self.currentGreen
                             WithBlue:self.currentBlue
                            WithAlpha:self.currentOpacity];
            
            [self setValueForColorSlidersRed:self.currentRed
                                       Green:self.currentGreen
                                        Blue:self.currentBlue
                                       Alpha:self.currentOpacity];
        }
            break;
            
        case 2:
        {
            __typeof(self) __weak weakSelf = self;
            [UIView animateWithDuration:0.3 animations:^() {
                
                weakSelf.randomOrRealColorSettings.alpha = 0.0;
                weakSelf.colorMenuOutlet.alpha = 1.0;
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)setValueForColorSlidersRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha
{
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    self.alphaSlider.value = alpha;
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
    [self setNeedsOfIndicator:self.colorViewIndicator
                      WithRed:self.currentRed
                    WithGreen:self.currentGreen
                     WithBlue:self.currentBlue
                    WithAlpha:self.currentOpacity];
}


- (IBAction)didWidthGetChanged:(UISlider *)sender
{
    self.currentWidth = sender.value;
    
    [self setNeedsOfIndicator:self.widthAndOpacityViewIndicator
                      WithRed:self.currentRed
                    WithGreen:self.currentGreen
                     WithBlue:self.currentBlue
                    WithAlpha:self.currentOpacity];
}

- (IBAction)didOpacityGetChanged:(UISlider *)sender
{
    self.currentOpacity = sender.value;
    [self setNeedsOfIndicator:self.widthAndOpacityViewIndicator
                      WithRed:self.currentRed
                    WithGreen:self.currentGreen
                     WithBlue:self.currentBlue
                    WithAlpha:self.currentOpacity];
}

- (void)setNeedsOfIndicator:(UIImageView *)indicator WithRed:(CGFloat)red WithGreen:(CGFloat)green WithBlue:(CGFloat)blue WithAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContext(indicator.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    if (indicator == self.widthAndOpacityViewIndicator)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.currentWidth);
    else if (indicator == self.colorViewIndicator)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(),50);
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 25, 25);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 25, 25);
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
        [self insertInRecentColorsColorWithRed:self.currentRed Green:self.currentGreen Blue:self.currentBlue Alpha:self.currentOpacity];
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
        [self insertInRecentColorsColorWithRed:self.currentRed Green:self.currentGreen Blue:self.currentBlue Alpha:self.currentOpacity];
    }
    else if ([sender.view hitTest:location withEvent:nil].tag == -3)
    {
        [self.delegate didSelectWidth:self.currentWidth];
        if (self.colorChosenWithPicker)
            [self.delegate didSelectColor:self.colorChosenWithPicker];
        else
            [self.delegate didSelectColor:[UIColor blackColor]];
        [self.resizerDelegate resizeColorContainerHeightTo:50];
        
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.recentSettingsOutlet.alpha = 0.0;
            weakSelf.mainMenuOutlet.alpha = 1.0;
        }];
        [self.colorPicker selectRow:0 inComponent:0 animated:YES];
    }
    
}

#pragma mark - filling Recent Colors array
- (void)insertInRecentColorsColorWithRed:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha
{
    if (!self.recentColors)
    {
        self.recentColors = [[NSMutableArray alloc] init];
    }
    if (![self.recentColors containsObject:[UIColor colorWithRed:red
                                                           green:green
                                                            blue:blue
                                                           alpha:alpha]])
        
    {
        static NSInteger i = 0;
        
        if (i >= 10)
            i = 0;
        if (self.recentColors.count)
            [self.recentColors insertObject:[UIColor colorWithRed:red
                                                            green:green
                                                             blue:blue
                                                            alpha:alpha]
                                    atIndex:i];
        else
            [self.recentColors addObject:[UIColor colorWithRed:red
                                                         green:green
                                                          blue:blue
                                                         alpha:alpha]];
        i++;
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
        self.colorChosenWithPicker = self.recentColors[row];
        const CGFloat* components = CGColorGetComponents(self.colorChosenWithPicker.CGColor);
        thisRed = components[0];
        thisGreen = components[1];
        thisBlue = components[2];
        thisOpacity = CGColorGetAlpha(self.colorChosenWithPicker.CGColor);
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
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),95);
    
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), thisRed, thisGreen, thisBlue, thisOpacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 50, 50);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 50, 50);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.recentColorViewIndicator.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString;
    if (self.recentColors.count)
    {
        self.colorChosenWithPicker = self.recentColors[row];
        const CGFloat* components = CGColorGetComponents(self.colorChosenWithPicker.CGColor);
        CGFloat thisRed = components[0];
        CGFloat thisGreen = components[1];
        CGFloat thisBlue = components[2];
        CGFloat thisOpacity = CGColorGetAlpha(self.colorChosenWithPicker.CGColor);

        attString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Red:%f Green:%f Blue:%f Alpha:%f",thisRed,thisGreen,thisBlue,thisOpacity] attributes:@{NSForegroundColorAttributeName:self.recentColors[row]}];
    }
    else
    {
        attString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Red:%d Green:%d Blue:%d Alpha:%d",0,0,0,0] attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    
    
    return attString;
    
}
@end
