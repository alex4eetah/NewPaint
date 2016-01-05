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

    [self animateChangingOfConstraint:self.fileManagerPanelHeightConstraint
                              ToValue:height];
}

- (void)resizeColorContainerHeightTo:(CGFloat)height
{
    [self animateChangingOfConstraint:self.colorPanelHeightConstraint
                              ToValue:height];
}

- (void)moveLayerManagingContainerLeftOnWidth:(CGFloat)width
{
    [self animateChangingOfConstraint:self.layerManagingContainerLeadingConstraint
                              ToValue:width];
}

- (void)animateChangingOfConstraint:(NSLayoutConstraint *)constraint ToValue:(CGFloat)value
{
    constraint.constant = value;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (NSDictionary *)takeArrayOfSubviews
{
    NSMutableDictionary * subviewsAndIndexes = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0; i < self.canvasVC.view.subviews.count; i++)
    {
        FigureDrawer* f = [self.canvasVC.view.subviews objectAtIndex:i];
        if ([f isKindOfClass:[FigureDrawer class]])
            [subviewsAndIndexes setObject:f forKey:[NSNumber numberWithInt:i]];
    }
    
    
  /*  NSMutableArray * arrayOfSubviews = [[NSMutableArray alloc] init];
    for (FigureDrawer* f in self.canvasVC.view.subviews)
    {
        if ([f isKindOfClass:[FigureDrawer class]])
            [arrayOfSubviews addObject:f];
    }*/
    
    return subviewsAndIndexes;
}

- (void)highLightLayerAtIndex:(NSInteger)index
{
    [self.canvasVC highLightGivenLayerAtIndex:index];
}

- (void)unHighlightLayerAtIndex:(NSInteger)index
{
    [self.canvasVC unHighlighGiventLayerAtIndex:index];
}

- (void)putUpCurrentLayerAtIndex:(NSInteger)index
{
    NSMutableArray * subviews = [[NSMutableArray alloc] initWithArray:self.canvasVC.view.subviews];
    if (index < subviews.count-1)
    {
        [[self.canvasVC.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        FigureDrawer * CurrentFigure = [subviews objectAtIndex:index];
        
        [subviews removeObjectAtIndex:index];
        [subviews insertObject:CurrentFigure atIndex:index+1];

        for (int i = 0; i < subviews.count; i++)
        {
            id subview = [subviews objectAtIndex:i];
            [self.canvasVC.view addSubview:subview];
        }
    }
    
}
- (void)putDownCurrentLayerAtIndex:(NSInteger)index
{
    NSMutableArray * subviews = [[NSMutableArray alloc] initWithArray:self.canvasVC.view.subviews];
    if (index > 3)
    {
        [[self.canvasVC.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        FigureDrawer * CurrentFigure = [subviews objectAtIndex:index];
        
        [subviews removeObjectAtIndex:index];
        [subviews insertObject:CurrentFigure atIndex:index-1];

        for (int i = 0; i < subviews.count; i++)
        {
            id subview = [subviews objectAtIndex:i];
            [self.canvasVC.view addSubview:subview];
        }
    }
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
