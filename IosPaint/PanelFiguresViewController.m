//
//  PanelFiguresViewController.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "PanelFiguresViewController.h"

@interface PanelFiguresViewController ()

@property (strong, nonatomic) IBOutlet UIView *figurePanelOutlet;
@property (strong, nonatomic) IBOutlet UIView *mainPanelOutlet;
@property (strong, nonatomic) IBOutlet UIView *OperationPanelOutlet;
@property (weak, nonatomic) IBOutlet UIView *massegePanelOutlet;
@property (strong, nonatomic) IBOutlet UISegmentedControl *operationSegmentControll;
@property (strong, nonatomic) IBOutlet UIView *drawingPanelOutlet;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UITextField *NangularNumOfSidesTextField;
@property (weak, nonatomic) IBOutlet UIView *NangularNumOfSidesPanelOutlet;
@property (weak, nonatomic) IBOutlet UIButton *sourceViewButtonForImagePicker;

@end

@implementation PanelFiguresViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


# pragma mark - main menu options
- (IBAction)mainSetOperationDidChanged:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.mainPanelOutlet.alpha = 0.0;
            weakSelf.OperationPanelOutlet.alpha = 1.0;
        }];
    }
    else if (sender.tag == 2)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.mainPanelOutlet.alpha = 0.0;
            weakSelf.drawingPanelOutlet.alpha = 1.0;
        }];
    }
    else if (sender.tag == 3)
    {
        self.imagePickerController = [[UIImagePickerController alloc]init];
        self.imagePickerController.delegate  = self;
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePickerController.modalPresentationStyle = UIModalPresentationPopover;
        self.imagePickerController.popoverPresentationController.sourceView = self.sourceViewButtonForImagePicker;
        self.imagePickerController.popoverPresentationController.sourceRect = self.sourceViewButtonForImagePicker.bounds;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}


#pragma mark - Operation panel options
- (IBAction)OperationDidChanged:(UISegmentedControl *)sender
{
    [self.delegate didSelectOperation:sender.selectedSegmentIndex];
    if (sender.selectedSegmentIndex == 1)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.OperationPanelOutlet.alpha = 0.0;
            weakSelf.massegePanelOutlet.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:3.0 animations:^() {
                
                weakSelf.massegePanelOutlet.alpha = 0.0;
                weakSelf.mainPanelOutlet.alpha = 1.0;
            }];
        }];
    }
    else
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.OperationPanelOutlet.alpha = 0.0;
            weakSelf.mainPanelOutlet.alpha = 1.0;
        }];
    }
    
    
    
}

- (IBAction)backFromOperationPanel:(id)sender
{
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.OperationPanelOutlet.alpha = 0.0;
        weakSelf.mainPanelOutlet.alpha = 1.0;
    }];
}
- (IBAction)allClear:(id)sender
{
    [self.delegate allClear];
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.OperationPanelOutlet.alpha = 0.0;
        weakSelf.mainPanelOutlet.alpha = 1.0;
    }];
}


- (IBAction)DrawModeDidSelected:(UIButton *)sender 
{
    if (sender.tag == 1)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.drawingPanelOutlet.alpha = 0.0;
            weakSelf.mainPanelOutlet.alpha = 1.0;
        }];
    }
    else if (sender.tag == 2)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.drawingPanelOutlet.alpha = 0.0;
            weakSelf.figurePanelOutlet.alpha = 1.0;
        }];
    }
    else if (sender.tag == 3)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.drawingPanelOutlet.alpha = 0.0;
            weakSelf.mainPanelOutlet.alpha = 1.0;
        }];
    }
    else if (sender.tag == 4)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.drawingPanelOutlet.alpha = 0.0;
            weakSelf.mainPanelOutlet.alpha = 1.0;
        }];
    }
}

- (IBAction)didChangeFigure:(UIButton *)sender
{
    if (sender.tag == 4)//n-angular
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.figurePanelOutlet.alpha = 0.0;
            weakSelf.NangularNumOfSidesPanelOutlet.alpha = 1.0;
        }];

    }
    else
    {
        [self.delegate didSelectShape:sender.tag];
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.figurePanelOutlet.alpha = 0.0;
            weakSelf.mainPanelOutlet.alpha = 1.0;
        }];
    }
}
- (IBAction)nangularDidChoseNumOfsides:(id)sender
{
   if ([self TextIsNumeric:self.NangularNumOfSidesTextField.text])
   {
       [self.delegate didSelectShape:4];
       NSInteger num = [self.NangularNumOfSidesTextField.text integerValue];
       [self.delegate setNumOfSides:num];
       __typeof(self) __weak weakSelf = self;
       [UIView animateWithDuration:0.3 animations:^() {
           
           weakSelf.NangularNumOfSidesPanelOutlet.alpha = 0.0;
           weakSelf.mainPanelOutlet.alpha = 1.0;
       }];
       self.NangularNumOfSidesTextField.text = @"";
   }
   else
   {
       [self.NangularNumOfSidesTextField setBackgroundColor:[UIColor redColor]];
       
       double delayInSeconds = 0.5;
       dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds*NSEC_PER_SEC);
       __typeof(self) __weak weakSelf = self;
       dispatch_after(popTime, dispatch_get_main_queue(), ^{
           [weakSelf.NangularNumOfSidesTextField setBackgroundColor:[UIColor clearColor]];
           weakSelf.NangularNumOfSidesTextField.text = @"";
       });
   }
}

- (IBAction)penBeenChosen:(UIButton *)sender
{
    [self.delegate didSelectShape:6];
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.drawingPanelOutlet.alpha = 0.0;
        weakSelf.mainPanelOutlet.alpha = 1.0;
    }];
}

- (BOOL) TextIsNumeric:(NSString *)text
{
    BOOL result = false;
    NSString *pattern = @"^\\d+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    result = [test evaluateWithObject:text];
    return result;
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.delegate didSelectImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
