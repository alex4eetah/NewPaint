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
@property (weak, nonatomic) IBOutlet UIView *loadingViewOutlet;

@property (weak, nonatomic) IBOutlet UITextField *nameOfFileField;
@property (weak, nonatomic) IBOutlet UIPickerView *filePicker;
@property (strong, nonatomic) NSString *CurrentFileToLoad;
@property (strong, nonatomic)  NSMutableArray *fileList;

@property (weak, nonatomic) IBOutlet UILabel *currentOperationLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentShapeLabel;

@property (weak, nonatomic) IBOutlet UIButton *loadFileButton;
@property (weak, nonatomic) IBOutlet UIButton *DeleteFileButton;

@property (nonatomic, strong, readonly) NSString *systemSavingPath;

@end

@implementation FileManagingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentShapeLabel.text = @"Circle";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveData)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveData)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restoreData)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(restoreData)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    _systemSavingPath = @"systemSavingFile.drwng";
    
}

#pragma mark - prepare for showing
- (void)getArrayOfPaths
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    self.fileList = [[manager contentsOfDirectoryAtPath:documentsDirectory error:nil] mutableCopy];
    
    if ([self.fileList containsObject:self.systemSavingPath])// for not to show system saving file
        [self.fileList removeObject:self.systemSavingPath];
    
    if (self.fileList.count == 0)
    {
        self.loadFileButton.enabled = NO;
        self.DeleteFileButton.enabled = NO;
        self.filePicker.userInteractionEnabled = NO;
    }
    else
    {
        self.loadFileButton.enabled = YES;
        self.DeleteFileButton.enabled = YES;
        self.filePicker.userInteractionEnabled = YES;
    }
}

- (IBAction)showLayerSettings:(UIButton *)sender
{
    [self.resizerDelegate moveLayerManagingContainerLeftOnWidth:0];
    [self.layerDelegate prepareLayerPanel];
}

#pragma mark - main menu settings
- (IBAction)managingFileOperations:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.managingViewOutlet.alpha = 0.0;
            weakSelf.savingOptionsViewOutlet.alpha = 1.0;
        }];
        
    }
    else if (sender.tag == 2)
    {
        [self.resizerDelegate resizeFileManagingContainerHeightTo:100];
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.managingViewOutlet.alpha = 0.0;
            weakSelf.loadingViewOutlet.alpha = 1.0;
        }];
        [self getArrayOfPaths];
        self.CurrentFileToLoad = [self.fileList firstObject];
        self.filePicker.delegate = self;
    }
    else if (sender.tag == 3)
    {
        [self.delegate Undo];
    }
}

#pragma mark - persistance
- (void)saveData
{
    [self.delegate writeFigureToFile:self.systemSavingPath];
    [self.delegate releaseResources];
}

- (void)restoreData
{
    [self.delegate loadDataFromFile:self.systemSavingPath];
}

#pragma mark - loading menu settings
- (IBAction)loadFromFile:(UIButton *)sender
{
    
    [self.delegate loadDataFromFile:self.CurrentFileToLoad];
    [self.resizerDelegate resizeFileManagingContainerHeightTo:50];
    
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
    self.CurrentFileToLoad = [self.fileList firstObject];
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
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.savingOptionsViewOutlet.alpha = 0.0;
            weakSelf.savingToFileViewOutlet.alpha = 1.0;
        }];
    }
    if (sender.tag == 2)
    {
        [self.delegate setCurrentOperation:4];
        __typeof(self) __weak weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^() {
            
            weakSelf.savingOptionsViewOutlet.alpha = 0.0;
            weakSelf.savingToGalleryViewOutlet.alpha = 1.0;
        }];
    }

}

- (IBAction)saveToFile:(UIButton *)sender
{
    if (![self.nameOfFileField.text  isEqual: @""] && ![self.nameOfFileField.text  isEqual: @"systemSavingFile.drwng"])
    {
        [self.delegate writeFigureToFile:self.nameOfFileField.text];
    }
    else
    {
        self.nameOfFileField.text = @"Enter file name!";
    }
    
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.savingToFileViewOutlet.alpha = 0.0;
        weakSelf.managingViewOutlet.alpha = 1.0;
    }];
}

- (IBAction)saveToGallery:(UIButton *)sender
{
    [self.delegate saveFigureToGallery];
    
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.savingToGalleryViewOutlet.alpha = 0.0;
        weakSelf.managingViewOutlet.alpha = 1.0;
    }];
}

- (IBAction)backFromOptionsSavingPanel:(id)sender
{
    __typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^() {
        
        weakSelf.savingOptionsViewOutlet.alpha = 0.0;
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

#pragma mark - FileManagerGelegate methods
- (void)showCurrentOperation:(NSString *)operation
{
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.type = kCATransitionMoveIn;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.currentOperationLabel.layer addAnimation:animation
                                            forKey:@"changeTextTransition"];
    self.currentOperationLabel.text = operation;
}

- (void)HighLightCurrentOperation
{
    [self.currentOperationLabel setBackgroundColor:[UIColor redColor]];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    __typeof(self) __weak weakSelf = self;
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [weakSelf.currentOperationLabel setBackgroundColor:[UIColor clearColor]];
                   });
}

- (void)showCurrentShape:(NSString *)shape
{
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.type = kCATransitionMoveIn;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.currentShapeLabel.layer addAnimation:animation
                                            forKey:@"changeTextTransition"];
    self.currentShapeLabel.text = shape;
}

@end
