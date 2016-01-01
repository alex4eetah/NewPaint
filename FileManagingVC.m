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
@property (weak, nonatomic) IBOutlet UIView *savingViewOutlet;
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
    
    self.savingViewOutlet.hidden = YES;
    self.managingViewOutlet.hidden = NO;
}
- (IBAction)loadFromFile:(UIButton *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *documentFile = [documentDirectory stringByAppendingPathComponent:self.CurrentFileToLoad];
    [self.delegate loadDataFromFile:documentFile];
    [self.resizerDelegate resizeFileManagingContainerHeightTo:50];
    
    self.loadingViewOutlet.hidden = YES;
    self.managingViewOutlet.hidden = NO;
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

- (IBAction)managingFileOperations:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        self.managingViewOutlet.hidden = YES;
        self.savingViewOutlet.hidden = NO;
    }
    else if (sender.tag == 2)
    {
        [self.resizerDelegate resizeFileManagingContainerHeightTo:100];
        
        self.managingViewOutlet.hidden = YES;
        self.loadingViewOutlet.hidden = NO;
        
        [self getArrayOfPaths];
        self.filePicker.delegate = self;
    }
    else if (sender.tag == 3)
    {
        [self.delegate Undo];
    }
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
    self.currentOperationLabel.text = operation;
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
