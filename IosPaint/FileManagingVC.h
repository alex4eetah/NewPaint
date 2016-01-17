//
//  FileManagingVC.h
//  IosPaint
//
//  Created by Olexandr_Chechetkin on 12/31/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "headerWithProtocols.h"



@interface FileManagingVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, FileManagerGelegate>

@property (nonatomic, weak) id <PanelsDelegate> delegate;
@property (nonatomic, weak) id <ResizerProtocol> resizerDelegate;
@property (nonatomic, weak) id <LayerManagerGelegate> layerDelegate;

@end



