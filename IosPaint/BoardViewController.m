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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    self.fileViewController.layerDelegate = self;
    self.canvasVC.delegate = self.fileViewController;
    self.colorVC.delegate = self.canvasVC;
    self.colorVC.resizerDelegate = self;
    self.figureVC.delegate = self.canvasVC;
    self.layerViewController.resizerDelegate = self;
    self.layerViewController.layerDelegate = self;
}

#pragma mark - ResizerProtocol methods

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

#pragma mark - LayerManagerGelegate methods

- (void)prepareLayerPanel
{
    [self.layerViewController getPreparedForShowing];
}



- (void)animateChangingOfConstraint:(NSLayoutConstraint *)constraint ToValue:(CGFloat)value
{
    constraint.constant = value;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (NSArray *)takeArrayOfSubviews
{
    return self.canvasVC.myViews;
}

- (void)highLightLayerAtIndex:(NSInteger)index
{
    [self.canvasVC highLightLayerAtIndex:index];
}

- (void)unHighlightLayerAtIndex:(NSInteger)index
{
    [self.canvasVC unHighlighLayerAtIndex:index];
}

- (void)putUpCurrentLayerAtIndex:(NSInteger)index
{
    [self.canvasVC putUpLayerAtIndex:index];
}

- (void)putDownCurrentLayerAtIndex:(NSInteger)index
{
    [self.canvasVC putDownLayerAtIndex:index];
}

- (void)changeLayerName:(NSInteger)layer toName:(NSString *)name;
{
    [self.canvasVC changeFigureName:layer toName:name];
}

- (void)deleteLayerAtIndex:(NSInteger)index
{
    [self.canvasVC deleteLayerAtIndex:index];
}

@end
