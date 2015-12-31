//
//  PanelFiguresViewController.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "PanelFiguresViewController.h"

@interface PanelFiguresViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *figurePanelOutlet;
@property (strong, nonatomic) IBOutlet UIView *mainPanelOutlet;
@property (strong, nonatomic) IBOutlet UIView *OperationPanelOutlet;
@property (strong, nonatomic) IBOutlet UISegmentedControl *operationSegmentControll;
@property (strong, nonatomic) IBOutlet UIView *drawingPanelOutlet;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

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

- (IBAction)didChangeFigure:(UISegmentedControl *)sender
{
    [self.delegate didSelectShape:sender.selectedSegmentIndex];
    self.figurePanelOutlet.hidden = YES;
    self.mainPanelOutlet.hidden = NO;
}
- (IBAction)penBeenChosen:(UIButton *)sender
{
    [self.delegate didSelectShape:6];
    self.drawingPanelOutlet.hidden = YES;
    self.mainPanelOutlet.hidden = NO;
}

- (IBAction)mainSetOperationDidChanged:(UIButton *)sender
{

    switch (sender.tag)
    {
        case 0:
            self.mainPanelOutlet.hidden = YES;
            self.OperationPanelOutlet.hidden = NO;
            break;
        case 1:
            self.mainPanelOutlet.hidden = YES;
            self.drawingPanelOutlet.hidden = NO;
            break;
        case 2:
            //            self.drawingPanelOutlet.hidden = YES;
            //            self.figurePanelOutlet.hidden = NO;
            self.imagePickerController = [[UIImagePickerController alloc]init];
            self.imagePickerController.delegate = self;
            self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentModalViewController:self.imagePickerController animated:YES];
            
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    [self.delegate didSelectImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
    [picker dismissModalViewControllerAnimated:YES];
    //UIImage *newImage = image;
    
    
}

- (IBAction)OperationDidChanged:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 4)
    {
        self.mainPanelOutlet.hidden = NO;
        self.OperationPanelOutlet.hidden = YES;
    }
    else
    {
        [self.delegate didSelectOperation:sender.selectedSegmentIndex];
        self.mainPanelOutlet.hidden = NO;
        self.OperationPanelOutlet.hidden = YES;
    }
}
- (IBAction)DrawModeDidSelected:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            self.drawingPanelOutlet.hidden = YES;
            self.mainPanelOutlet.hidden = NO;
            break;
            
        case 2:
            self.drawingPanelOutlet.hidden = YES;
            self.figurePanelOutlet.hidden = NO;
            break;
            
        case 4:
            self.drawingPanelOutlet.hidden = YES;
            self.mainPanelOutlet.hidden = NO;
            break;
        
    }
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
