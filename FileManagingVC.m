//
//  FileManagingVC.m
//  IosPaint
//
//  Created by Olexandr_Chechetkin on 12/31/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "FileManagingVC.h"





@interface FileManagingVC ()

@property (weak, nonatomic) IBOutlet UIView *managingViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *savingOptionsViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *savingToFileViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *savingToGalleryViewOutlet;
@property (weak, nonatomic) IBOutlet UITextField *nameOfFileField;
@property (weak, nonatomic) IBOutlet UIView *loadingViewOutlet;
@property (weak, nonatomic) IBOutlet UIPickerView *filePicker;
@property (strong, nonatomic) NSString *CurrentFileToLoad;
@property (strong, nonatomic)  NSArray *fileList;

@property (weak, nonatomic) IBOutlet UILabel *currentOperationLabel;

@end

@implementation FileManagingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getArrayOfPaths
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    self.fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
}



- (IBAction)showLayerSettings:(UIButton *)sender
{
    [self.resizerDelegate moveLayerManagingContainerLeftOnWidth:0];
}

#pragma mark - main menu settings

- (IBAction)managingFileOperations:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        /*self.managingViewOutlet.hidden = NO;
        self.savingOptionsViewOutlet.hidden = NO;
        self.savingOptionsViewOutlet.alpha = 0.0;*/
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.managingViewOutlet.alpha = 0.0;
            weakSelf.savingOptionsViewOutlet.alpha = 1.0;
        }];
        
    }
    else if (sender.tag == 2)
    {
        [self.resizerDelegate resizeFileManagingContainerHeightTo:100];
        
        /*self.managingViewOutlet.hidden = YES;
        self.loadingViewOutlet.hidden = NO;*/
        
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.managingViewOutlet.alpha = 0.0;
            weakSelf.loadingViewOutlet.alpha = 1.0;
        }];
        
        [self getArrayOfPaths];
        self.filePicker.delegate = self;
    }
    else if (sender.tag == 3)
    {
        [self.delegate Undo];
    }
}

#pragma mark - loading menu settings
- (IBAction)loadFromFile:(UIButton *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *documentFile = [documentDirectory stringByAppendingPathComponent:self.CurrentFileToLoad];
    [self.delegate loadDataFromFile:documentFile];
    [self.resizerDelegate resizeFileManagingContainerHeightTo:50];
    
//    self.loadingViewOutlet.hidden = YES;
//    self.managingViewOutlet.hidden = NO;
    
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.loadingViewOutlet.alpha = 0.0;
        weakSelf.managingViewOutlet.alpha = 1.0;
    }];
}

- (IBAction)deleteFileFromSystem:(UIButton *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *documentFile = [documentDirectory stringByAppendingPathComponent:self.CurrentFileToLoad];
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:documentFile error:nil];
    
    [self getArrayOfPaths];
    [self.filePicker reloadAllComponents];
}
- (IBAction)backFromLoadingpanel:(id)sender
{
    __typeof(self) __weak weakSelf = self;
    [self.resizerDelegate resizeFileManagingContainerHeightTo:50];
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.loadingViewOutlet.alpha = 0.0;
        weakSelf.managingViewOutlet.alpha = 1.0;
    }];
}

#pragma mark - saving menu settings
- (IBAction)savingOptionDidChanged:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        /* self.savingOptionsViewOutlet.hidden = YES;
         self.savingToFileViewOutlet.hidden = NO;*/
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.savingOptionsViewOutlet.alpha = 0.0;
            weakSelf.savingToFileViewOutlet.alpha = 1.0;
        }];
    }
    if (sender.tag == 2)
    {
//        self.savingOptionsViewOutlet.hidden = YES;
//        self.savingToGalleryViewOutlet.hidden = NO;
        [self.delegate performSelector:@selector(setCurrentOperationWithNSNumber:) withObject:[NSNumber numberWithInt:4]];
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.savingOptionsViewOutlet.alpha = 0.0;
            weakSelf.savingToGalleryViewOutlet.alpha = 1.0;
        }];
    }

}

- (IBAction)saveToFile:(UIButton *)sender
{
    if (![self.nameOfFileField.text  isEqual: @""])
    {
        [self.delegate writeFigureToFile:self.nameOfFileField.text];
    }
    else
    {
        self.nameOfFileField.text = @"Enter file name!";
    }
    
   /* self.savingToFileViewOutlet.hidden = YES;
    self.managingViewOutlet.hidden = NO;
    */
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.savingToFileViewOutlet.alpha = 0.0;
        weakSelf.managingViewOutlet.alpha = 1.0;
    }];
}

- (IBAction)saveToGallery:(UIButton *)sender
{
    [self.delegate saveFigureToGallery];
    /*self.savingToGalleryViewOutlet.hidden = YES;
    self.managingViewOutlet.hidden = NO;*/
    
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.savingToGalleryViewOutlet.alpha = 0.0;
        weakSelf.managingViewOutlet.alpha = 1.0;
    }];
}

#pragma mark - pickerMethods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.fileList.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.CurrentFileToLoad = [self.fileList objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.fileList objectAtIndex:row];
}

#pragma mark - delegate methods

- (void)showCurrentOperation:(NSString *)operation
{
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.type = kCATransitionMoveIn;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.currentOperationLabel.layer addAnimation:animation
                                            forKey:@"changeTextTransition"];
    /*
    CATransition *ColorAnimation = [CATransition animation];
    [ColorAnimation setDelegate:self]; //important
    [ColorAnimation setRemovedOnCompletion:YES]; //better to remove the animation
    [ColorAnimation setBeginTime:CACurrentMediaTime()]; //not really needed
    [ColorAnimation setDuration:0.4];
    [ColorAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [ColorAnimation setType:kCATransitionFade];
    
    //you can specify any key name or keep it nil. doesn't make a difference
    [self.currentOperationLabel.layer addAnimation:ColorAnimation forKey:@"changeTextColor"];*/
    
    self.currentOperationLabel.text = operation;
    //[self.currentOperationLabel setTextColor:[UIColor greenColor]];
    
    
    
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
