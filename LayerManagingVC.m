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

@property (strong, nonatomic) NSDictionary *subviewsAndIndexes;
@property (weak, nonatomic) IBOutlet UIPickerView *subviewPicker;
@property (assign, nonatomic) NSInteger currentLayer;

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
    if (! self.subviewsAndIndexes)
        self.subviewsAndIndexes = [[NSDictionary alloc] initWithDictionary:[self.layerDelegate takeArrayOfSubviews]];
    else
        self.subviewsAndIndexes = [self.layerDelegate takeArrayOfSubviews];

}

- (IBAction)changeOrderOfSubviews:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            [self.layerDelegate putUpCurrentLayerAtIndex:self.currentLayer];
            break;
        case 2:
            [self.layerDelegate putDownCurrentLayerAtIndex:self.currentLayer];
            break;
            
        default:
            break;
    }
    
    [self.subviewPicker reloadAllComponents];
    [self.subviewPicker selectRow:0 inComponent:0 animated:YES];
}

#pragma mark - pickerMethods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.subviewsAndIndexes.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    row +=3;///HOWWW?????
    
    for (id key in self.subviewsAndIndexes)
    {
        if ([key integerValue] == row)
        {
            [self.layerDelegate highLightLayerAtIndex:row];
            self.currentLayer = row;
            return;
        }
        else
            [self.layerDelegate unHighlightLayerAtIndex:row];
    }
    
    /*NSArray *keys;
    keys = [self.subviewsAndIndexes allKeys];
    NSNumber *key;
    FigureDrawer *value;
    
    
    
    
    for (int i = 0; i < keys.count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [self.subviewsAndIndexes objectForKey: key];
        
        if ([key integerValue] == row)
        {
            [self.layerDelegate highLightLayerAtIndex:row];
            self.currentLayer = row;
            return;
        }
        else
            [self.layerDelegate unHighlightLayerAtIndex:row];
    }*/
    
    
    
    
    
    /*
    
    for (int i = 0; i < self.subviewsAndIndexes.count; i++)
    {
        if (self.subviewsAndIndexes.keyEnumerator == row)
        {
            [self.layerDelegate highLightLayerAtIndex:row];
            self.currentLayer = row;
            return;
        }
        else
            [self.layerDelegate unHighlightLayerAtIndex:row];
    }*/
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"Layer: %d",row];
}

@end
