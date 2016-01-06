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

@property (strong, nonatomic) NSArray *subviews;
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
    if (! self.subviews)
        self.subviews = [[NSArray alloc] initWithArray:[self.layerDelegate takeArrayOfSubviews]];
    else
        self.subviews = [self.layerDelegate takeArrayOfSubviews];
}

- (IBAction)changeOrderOfSubviews:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            [self.layerDelegate putUpCurrentLayerAtIndex:self.currentLayer];
            [self.layerDelegate unHighlightLayerAtIndex:self.currentLayer];
            [self.layerDelegate highLightLayerAtIndex:self.currentLayer+1]; ///// WHY ??????
            [self.subviewPicker selectRow:self.currentLayer+1 inComponent:0 animated:YES];
            break;
        case 2:
            [self.layerDelegate putDownCurrentLayerAtIndex:self.currentLayer];
            [self.layerDelegate unHighlightLayerAtIndex:self.currentLayer];
            [self.layerDelegate highLightLayerAtIndex:self.currentLayer-1];
            [self.subviewPicker selectRow:self.currentLayer-1 inComponent:0 animated:YES];
            break;
            
        default:
            break;
    }
    [self getArrayOfSubviews];
    [self.subviewPicker reloadAllComponents];
    
    
    for (int i = 0; i < self.subviews.count; i++)
    {
        [self.layerDelegate unHighlightLayerAtIndex:i];
    }
}

#pragma mark - pickerMethods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.subviews.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    for (int i = 0; i < self.subviews.count; i++)
    {
        if (i == row)
        {
            [self.layerDelegate highLightLayerAtIndex:i];
            self.currentLayer = row;
        }
        else
            [self.layerDelegate unHighlightLayerAtIndex:i];
    }
    
    
    
    
    
    
    /*
    row +=3;///HOWWW?????
    
    for (id key in self.subviewsAndIndexes)
    {
        if ([key integerValue] == row)
        {
            [self.layerDelegate highLightLayerAtIndex:row];
            self.currentLayer = row;
        }
        else
            [self.layerDelegate unHighlightLayerAtIndex:row];
    }
    
    NSArray *keys;
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
    for (int i = 0; i < self.subviews.count; i++)
    {
        if (i == row)
        {
            FigureDrawer *f = [self.subviews objectAtIndex:i];
            return f.figureName;
        }
    }
    return @"no name";
}

@end
