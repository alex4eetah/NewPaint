//
//  LayerManagingVC.m
//  IosPaint
//
//  Created by Olexandr_Chechetkin on 1/4/16.
//  Copyright © 2016 Olexander_Chechetkin. All rights reserved.
//

#import "LayerManagingVC.h"
#import "FigureDrawer.h"

@interface LayerManagingVC()

@property (strong, nonatomic) NSArray *arrayOfSubviews;
@property (weak, nonatomic) IBOutlet UIPickerView *subviewPicker;
@property (strong, nonatomic) FigureDrawer *currentLayer;

@end

@implementation LayerManagingVC


- (IBAction)hideLayerSettings:(UIButton *)sender
{
    [self.resizerDelegate moveLayerManagingContainerLeftOnWidth:-200];
    [self getArrayOfSubviews];
    self.subviewPicker.delegate = self;
}

- (void) getArrayOfSubviews
{
    if (! self.arrayOfSubviews)
        self.arrayOfSubviews = [[NSArray alloc] initWithArray:[self.layerDelegate takeArrayOfSubviews]];
    else
        self.arrayOfSubviews = [self.layerDelegate takeArrayOfSubviews];

}

- (IBAction)changeOrderOfSubviews:(UIButton *)sender
{
    
}

#pragma mark - pickerMethods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayOfSubviews.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.layerDelegate highLightLayerAtIndex:(NSUInteger)row];
    //self.currentLayer = [self.arrayOfSubviews objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"Layer: %d",row];
}

@end
