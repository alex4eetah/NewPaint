//
//  BoardViewController.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "BoardViewController.h"
#import "PanelColorViewController.h"
#import "PanelFiguresViewController.h"
#import "CanvasViewController.h"
#import "FileManagingVC.h"
#import "LayerManagingVC.h"


@interface BoardViewController ()
@property (strong, nonatomic) PanelColorViewController * colorVC;
@property (strong, nonatomic) PanelFiguresViewController * figureVC;
@property (strong, nonatomic) CanvasViewController * canvasVC;
@property (strong, nonatomic) FileManagingVC * fileViewController;
@property (strong, nonatomic) LayerManagingVC * layerViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fileManagerPanelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorPanelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layerManagingContainerLeadingConstraint;

@end

@implementation BoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    
    if ([segueName isEqualToString: @"colorViev_embed"])
    {
        self.colorVC = (PanelColorViewController *) [segue destinationViewController];
    }
    else if ([segueName isEqualToString: @"canvas_embed"])
    {
        self.canvasVC = (CanvasViewController *) [segue destinationViewController];
    }
    else if ([segueName isEqualToString: @"figureViev_embed"])
    {
        self.figureVC = (PanelFiguresViewController *) [segue destinationViewController];
    }
    else if ([segueName isEqualToString: @"fileManagment"])
    {
        self.fileViewController = (FileManagingVC *) [segue destinationViewController];
    }
    else if ([segueName isEqualToString: @"LayerManagingVC_seague"])
    {
        self.layerViewController = (LayerManagingVC *) [segue destinationViewController];
    }
    self.fileViewController.delegate = self.canvasVC;
    self.fileViewController.resizerDelegate = self;
    self.canvasVC.delegate = self.fileViewController;
    self.colorVC.delegate = self.canvasVC;
    self.colorVC.resizerDelegate = self;
    self.figureVC.delegate = self.canvasVC;
    self.layerViewController.resizerDelegate = self;
    self.layerViewController.layerDelegate = self;
}

#pragma mark - delegate methods

- (void)resizeFileManagingContainerHeightTo:(CGFloat)height
{
    self.fileManagerPanelHeightConstraint.constant = height;
}

- (void)resizeColorContainerHeightTo:(CGFloat)height
{
    self.colorPanelHeightConstraint.constant = height;
}

- (void)moveLayerManagingContainerLeftOnWidth:(CGFloat)width
{
    [UIView animateWithDuration:6.0
                     animations:^{
                         self.layerManagingContainerLeadingConstraint.constant = width;
                     }];
}

- (NSArray *)takeArrayOfSubviews
{
    return self.canvasVC.view.subviews;
}

- (void)highLightLayerAtIndex:(NSUInteger)index
{
    [self.canvasVC highLightGivenLayerAtIndex:index];
}
/*
- (IBAction)ManagingOperationDidChanged:(UIButton *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *documentFile = [documentDirectory stringByAppendingPathComponent:@"wtf.txt"];
   
    
    
    
    
    if (sender.tag == 0)
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject:self.canvasVC forKey:@"myCanvas"];
        [archiver finishEncoding];
        [data writeToFile:documentFile atomically:YES];
    }
    else if (sender.tag == 1)
    {
        NSData *loadedData = [[NSData alloc] initWithContentsOfFile:documentFile];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:loadedData];
        self.canvasVC = [unarchiver decodeObjectForKey:@"myCanvas"];
        
    }
}
*/


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
