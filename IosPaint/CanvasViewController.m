//
//  CanvasViewController.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "CanvasViewController.h"
#import "FigureDrawer.h"

typedef enum operationsType
{
    drawing,
    movement,
    scaleing,
    rotating
} OperationType;

@interface CanvasViewController ()

@property (nonatomic, strong) NSMutableArray *myViews;

@property (nonatomic, assign) NSInteger lineWidth;
@property (nonatomic, strong) UIColor* currentColor;
@property (nonatomic, assign) NSInteger currentShape;
@property (nonatomic, assign) NSInteger numOfSides;

@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint stop;
@property (nonatomic, strong) NSNumber* inset;

@property (nonatomic, assign) CGPoint startOfMove;
@property (nonatomic, assign) CGPoint stopOfMove;
@property (nonatomic, strong) UIView *viewToMove;
@property (nonatomic,assign) BOOL hitTheMoovingHandle;

@property (nonatomic, strong) UIView *viewToScale;
@property (nonatomic, assign) CGFloat currentScale;

@property (nonatomic, strong) NSMutableArray *currentPointsOfLine;

@property (nonatomic, strong) UILongPressGestureRecognizer *lPGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGesture;

@property (nonatomic, assign) OperationType currentOperation;
@property (strong, nonatomic) IBOutlet UILabel *currentOperationOutlet;

@property (nonatomic, strong) UIView* handleToMove;
@property (nonatomic, strong) UIView* handleToDelete;
@property (nonatomic, assign) BOOL isInProgress;

@property (weak, nonatomic) IBOutlet UIView *managingViewOutlet;
@property (weak, nonatomic) IBOutlet UIView *savingViewOutlet;
@property (weak, nonatomic) IBOutlet UITextField *nameOfFileField;
@property (weak, nonatomic) IBOutlet UIView *loadingViewOutlet;
@property (weak, nonatomic) IBOutlet UIButton *firstLoadingButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *secondLoadingButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *thirdLoadingButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *fourthLoadingButtonOutlet;


@property (nonatomic, strong) UIImage *currentImage;

@property (nonatomic, assign) BOOL didPreviousEventWasTap;
@end

@implementation CanvasViewController
/*
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.myViews forKey:@"arrayOfFigureDrawers"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.myViews = [aDecoder decodeObjectForKey:@"arrayOfFigureDrawers"];
        [self viewDidLoad];
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numOfSides = 0;
    self.currentShape = 0;
  //  self.isMoveStarted = NO;
   /* self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    self.isSkaleStarted = NO;
    self.isMoveFinished = NO;
    
    [self.view addGestureRecognizer:self.lpgr];*/
    
    self.lineWidth = 5;
    self.inset = [[NSNumber alloc] initWithDouble:self.lineWidth/2];
    self.currentOperationOutlet.text = @"drawing";
    
    self.isInProgress = NO;
    
}

- (IBAction)writeToFile:(UIButton *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
     NSString *documentFile = [documentDirectory stringByAppendingPathComponent:@" "];
    if (![self.nameOfFileField.text  isEqual: @""])
    {
        documentFile = [documentDirectory stringByAppendingPathComponent:self.nameOfFileField.text];
    }
    else
    {
        self.nameOfFileField.text = @"Enter file name!";
    }
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.myViews forKey:@"arrayOfFigureDrawers"];
    [archiver finishEncoding];
    [data writeToFile:documentFile atomically:YES];
    
    self.savingViewOutlet.hidden = YES;
    self.managingViewOutlet.hidden = NO;

}
- (IBAction)LoadDataFromFile:(UIButton *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *documentFile = [documentDirectory stringByAppendingPathComponent:sender.titleLabel.text];
    
    NSData *loadedData = [[NSData alloc] initWithContentsOfFile:documentFile];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:loadedData];
    self.myViews = [unarchiver decodeObjectForKey:@"arrayOfFigureDrawers"];
    for (UIView *v in self.view.subviews)
    {
        if ([v isKindOfClass:[FigureDrawer class]])
        {
            [v removeFromSuperview];
        }
    }
    for (FigureDrawer *f in self.myViews)
    {
        [f setNeedsDisplay];
        [self.view addSubview:f];
    }
    
    self.loadingViewOutlet.hidden = YES;
    self.managingViewOutlet.hidden = NO;
}

- (IBAction)ManageOperationDidChanged:(UIButton *)sender
{
    if (sender.tag == 1)
    {
        self.managingViewOutlet.hidden = YES;
        self.savingViewOutlet.hidden = NO;
    }
    else if (sender.tag == 2)
    {
        self.managingViewOutlet.hidden = YES;
        self.loadingViewOutlet.hidden = NO;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
        for (int i = 0; i < fileList.count; i++)
        {
            if (i == 0)
            {
                self.firstLoadingButtonOutlet.enabled = YES;
                [self.firstLoadingButtonOutlet setTitle:fileList[0] forState:UIControlStateNormal];
            }
            else if (i == 1)
            {
                self.secondLoadingButtonOutlet.enabled = YES;
                [self.secondLoadingButtonOutlet setTitle:fileList[1] forState:UIControlStateNormal];
            }
            else if (i == 2)
            {
                self.thirdLoadingButtonOutlet.enabled = YES;
                [self.thirdLoadingButtonOutlet setTitle:fileList[2] forState:UIControlStateNormal];
            }
            else if (i == 3)
            {
                self.fourthLoadingButtonOutlet.enabled = YES;
                [self.fourthLoadingButtonOutlet setTitle:fileList[3] forState:UIControlStateNormal];
            }
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)LongPressDetected:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (!self.isInProgress)
        {
            CGPoint location = [sender locationInView:sender.view];
            if ([sender.view hitTest:location withEvent:nil] != self.view &&
                [[sender.view hitTest:location withEvent:nil] isKindOfClass:[FigureDrawer class]])
                self.viewToMove = [sender.view hitTest:location withEvent:nil];
            else
                return;
            [self.viewToMove removeFromSuperview];
            [self.view addSubview:self.viewToMove];
            
            self.handleToMove = [[UIView alloc] initWithFrame:CGRectMake(
                                                                         self.viewToMove.frame.size.width/2-45/2,
                                                                         self.viewToMove.frame.size.height/2-45/2, 45, 45)];
            self.handleToMove.backgroundColor = [UIColor greenColor];
            /*self.handleToMove = [[FigureDrawer alloc] initWithFrame:CGRectMake(
                                                                               self.viewToMove.frame.size.width/2-45/2,
                                                                               self.viewToMove.frame.size.height/2-45/2, 45, 45)
                                                              shape:1
                                                             collor:[UIColor greenColor]
                                                       dekartSystem:4
                                                          withInset:[NSNumber numberWithInt:2]
                                                          lineWidth:2
                                                       pointsOfLine:nil
                                                              image:nil];*/
            self.handleToDelete = [[UIView alloc] initWithFrame:CGRectMake(
                                                                           self.viewToMove.frame.size.width-45,
                                                                           0, 45, 45)];
            self.handleToDelete.backgroundColor = [UIColor redColor];
            /*self.handleToDelete = [[FigureDrawer alloc] initWithFrame:CGRectMake(
                                                                                 self.viewToMove.frame.size.width-45,
                                                                                 0, 45, 45)
                                                                shape:1
                                                               collor:[UIColor redColor]
                                                         dekartSystem:4
                                                            withInset:[NSNumber numberWithInt:2]
                                                            lineWidth:2
                                                         pointsOfLine:nil
                                                                image:nil];*/
            [self.viewToMove addSubview:self.handleToMove];
            [self.viewToMove addSubview:self.handleToDelete];
            self.isInProgress =YES;
            CGRect frame = CGRectMake(0, 0,
                                      self.viewToMove.frame.size.width,
                                      self.viewToMove.frame.size.height);
            
            UIView *background = [[UIView alloc] initWithFrame:frame];
            background.backgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.94 alpha:0.2];
            [self.viewToMove addSubview:background];
        }
    }
}
- (void)PinchDetected:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [sender locationInView:sender.view];
        if ([sender.view hitTest:location withEvent:nil] != self.view)
            self.viewToScale = [sender.view hitTest:location withEvent:nil];
        else
            return;
        self.viewToScale.backgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.94 alpha:0.2];
        [self.myViews removeObject:self.viewToScale];
        [self.myViews addObject:self.viewToScale];
        [self.viewToScale setNeedsDisplay];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.viewToScale.backgroundColor = [UIColor clearColor];
        [self.viewToScale setNeedsDisplay];
        self.viewToScale = nil;
    }
    
    if(self.viewToScale)
    {
        [self.myViews removeObject:self.viewToScale];
        CGFloat scale = sender.scale;
        //self.viewToScale.transform = CGAffineTransformScale(self.viewToScale.transform, scale, scale);
        CGFloat xDiferance = self.viewToScale.frame.size.width - self.viewToScale.frame.size.width*scale;
        CGFloat yDiferance = self.viewToScale.frame.size.height - self.viewToScale.frame.size.height*scale;
        
        CGRect frame = CGRectMake(self.viewToScale.frame.origin.x+xDiferance/2,
                                  self.viewToScale.frame.origin.y+yDiferance/2,
                                  self.viewToScale.frame.size.width*scale,
                                  self.viewToScale.frame.size.height*scale);
        
        self.viewToScale.frame = frame;
        
        
        [self.myViews addObject:self.viewToScale];
        [self.viewToScale setNeedsDisplay];
        
        
        sender.scale = 1.0;
    }
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)sender
{
    CGFloat netRotation = 0.0;
    CGFloat rotation;
    
    CGPoint location = [sender locationInView:sender.view];
    self.viewToScale = [sender.view hitTest:location withEvent:nil];
    
    if (self.viewToScale  != self.view)
    {
        [self.myViews removeObject:self.viewToScale];
        rotation = sender.rotation;
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotation+netRotation);
        self.viewToScale.transform = transform;
    }
    
    else if (sender.state == UIGestureRecognizerStateEnded)
        netRotation += rotation;
    [self.myViews addObject:self.viewToScale];
    [self.viewToScale setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [[event allTouches] anyObject];
    CGPoint locationOfTouch = [touch locationInView:touch.view];
    self.start = [touch locationInView:self.view];
    FigureDrawer *currentView;
    
    switch (self.currentOperation)
    {
        case drawing:
            
            if (self.currentShape == 6)//random line
            {
                self.currentPointsOfLine = [[NSMutableArray alloc] init];
                [self.currentPointsOfLine addObject: [NSValue valueWithCGPoint:self.start]];
                
                CGRect frame = CGRectMake(self.view.frame.origin.x,
                                          self.view.frame.origin.y,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height);
                FigureDrawer *currentView = [[FigureDrawer alloc] initWithFrame:frame
                                                                          shape:self.currentShape
                                                                         collor:self.currentColor
                                                                   dekartSystem:1
                                                                      withInset:self.inset
                                                                      lineWidth:self.lineWidth
                                                                   pointsOfLine:self.currentPointsOfLine
                                                                          image:nil];
                [self.view addSubview:currentView];
                currentView.backgroundColor = [UIColor clearColor];
                if (!self.myViews)
                    self.myViews = [[NSMutableArray alloc] init];
                [self.myViews addObject:currentView];
            }
            else
            {
                self.start = [touch locationInView:self.view];
                CGRect frame = CGRectMake(self.start.x, self.start.y, self.lineWidth, self.lineWidth);
                
                currentView = [[FigureDrawer alloc] initWithFrame:frame
                                                            shape:self.currentShape
                                                           collor:self.currentColor
                                                     dekartSystem:1
                                                        withInset:self.inset
                                                        lineWidth:self.lineWidth
                                                     pointsOfLine:nil
                                                            image:self.currentImage];
                currentView.backgroundColor = [UIColor clearColor];
                [self.view addSubview:currentView];
                if (!self.myViews)
                    self.myViews = [[NSMutableArray alloc] init];
                [self.myViews addObject:currentView];
            }
            break;
            
        case movement:
            
            if (self.hitTheMoovingHandle)
            {
                [[self.viewToMove subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.viewToMove setNeedsDisplay];
                self.viewToMove = nil;
                self.hitTheMoovingHandle = NO;
                self.isInProgress = NO;
            }
            //if you tap to the centre of figure
            if ([touch.view.superview isEqual:self.viewToMove] &&
                (locationOfTouch.x>touch.view.frame.size.width/2-20) &&
                (locationOfTouch.x<touch.view.frame.size.width/2+20) &&
                (locationOfTouch.y>(touch.view.frame.size.height/2-20)) &&
                (locationOfTouch.y<(touch.view.frame.size.height/2+20)))
            {
                //self.viewToMove = touch.view;
                self.hitTheMoovingHandle = YES;
                self.isInProgress = NO;
            }
            else if ([touch.view.superview isEqual:self.viewToMove] &&
                     (locationOfTouch.x>touch.view.frame.size.width-45) &&
                     (locationOfTouch.x<touch.view.frame.size.width) &&
                     (locationOfTouch.y>(touch.view.frame.origin.y)) &&
                     (locationOfTouch.y<(touch.view.frame.origin.y+45)))
            {
                //delete
                [self.viewToMove removeFromSuperview];
                [self.myViews removeObject:self.viewToMove];
                self.isInProgress = NO;
            }
            break;
          
        case scaleing:
            
            break;
            
        case rotating:
            
            break;
            
        default:
            break;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [[event allTouches] anyObject];
    FigureDrawer * currentView;
//    static NSInteger count = 0;
    switch (self.currentOperation)
    {
        case drawing:
            
            self.stop = [touch locationInView:self.view];
            
            if (self.currentShape == 6)
            {
//                count++;
                [self.currentPointsOfLine addObject: [NSValue valueWithCGPoint:self.stop]];
                
//                CGContextRef ctx = UIGraphicsGetCurrentContext();
//                CGContextBeginPath(ctx);
//                CGContextSetLineWidth(ctx, self.lineWidth);
//                CGContextSetStrokeColorWithColor(ctx, [[UIColor yellowColor] CGColor]);
//
//                if (count == 1)
//                {
//                    NSValue *v = [self.currentPointsOfLine firstObject];
//                    CGPoint firstPint = [v CGPointValue];
//                    CGContextMoveToPoint(ctx, firstPint.x, firstPint.y);
//                }
//                else
//                {
//                    NSValue *v = [self.currentPointsOfLine lastObject];
//                    CGPoint lastPoint = [v CGPointValue];
//                    CGContextAddLineToPoint(ctx, lastPoint.x, lastPoint.y);
//                }
//                CGContextStrokePath(ctx);
                currentView = [self.myViews lastObject];
                [self.myViews removeObject:currentView];
                currentView.pointsOfLine  = self.currentPointsOfLine;
                [self.myViews addObject:currentView];
                [currentView setNeedsDisplay];
            }
            else
            {
                CGFloat width = self.stop.x - self.start.x;
                CGFloat height = self.stop.y - self.start.y;
                
                CGFloat x = width >= 0 ? self.start.x : self.start.x + width;
                CGFloat y = height >= 0 ? self.start.y : self.start.y + height;
                
                CGRect frame;
                
                if (self.currentShape == 4)
                {
                    frame = CGRectMake(x, y, (fabs(height)+fabs(width))/2, (fabs(height)+fabs(width))/2);
                }
                else
                {
                    frame = CGRectMake(x, y, MAX(fabs(width), self.inset.doubleValue) , MAX(fabs(height), self.inset.doubleValue));
                }
                
                
                NSInteger dekNum;
                if (width > 0 && height < 0)
                    dekNum = 1;
                else if (width < 0 && height < 0)
                    dekNum = 2;
                else if (width < 0 && height > 0)
                    dekNum = 3;
                else
                    dekNum = 4;
                
                currentView = self.myViews.lastObject;
                currentView.frame = frame;
                currentView.dekNum = dekNum;
                currentView.numOfSides = 3;
                [self.myViews removeLastObject];
                [self.myViews addObject:currentView];
                [currentView setNeedsDisplay];
            }
            /*
            
            
            
            
            
            
            
            
            if (self.currentShape == 6)
            {
                if (self.didPreviousEventWasTap)
                {
                    
                    
                   
                    
                    currentView = self.myViews.lastObject;
                    currentView.frame = frame;
                    currentView.dekNum = dekNum;
                    currentView.numOfSides = 3;
                    [self.myViews removeLastObject];
                    [self.myViews addObject:currentView];
                    [currentView setNeedsDisplay];
                    
                    self.didPreviousEventWasTap = NO;
                    if (dekNum == 4)
                        self.start = CGPointMake(self.stop.x-5, self.stop.y-5);
                    else if (dekNum == 3)
                        self.start = CGPointMake(self.stop.x+5, self.stop.y-5);
                    else if (dekNum == 2)
                        self.start = CGPointMake(self.stop.x+5, self.stop.y+5);
                    else if (dekNum == 1)
                        self.start = CGPointMake(self.stop.x-5, self.stop.y+5);
                }
                else
                {
                    if (self.stop.x > self.start.x && self.stop.y < self.start.y)
                        dekNum = 1;
                    else if (self.stop.x < self.start.x && self.stop.y < self.start.y)
                        dekNum = 2;
                    else if (self.stop.x < self.start.x && self.stop.y > self.start.y)
                        dekNum = 3;
                    else if (self.stop.x > self.start.x && self.stop.y > self.start.y)
                        dekNum = 4;
                    
                    currentView = [[FigureDrawer alloc] initWithFrame:frame
                                                                shape:self.currentShape
                                                               collor:self.currentColor
                                                         dekartSystem:dekNum
                                                            withInset:0
                                                            lineWidth:self.lineWidth];
                    currentView.backgroundColor = [UIColor clearColor];
                    currentView.dekNum = dekNum;
                    [self.view addSubview:currentView];
                    [self.myViews addObject:currentView];
                    
                    if (dekNum == 4)
                        self.start = CGPointMake(self.stop.x-5, self.stop.y-5);
                    else if (dekNum == 3)
                        self.start = CGPointMake(self.stop.x+5, self.stop.y-5);
                    else if (dekNum == 2)
                        self.start = CGPointMake(self.stop.x+5, self.stop.y+5);
                    else if (dekNum == 1)
                        self.start = CGPointMake(self.stop.x-5, self.stop.y+5);
                        
                }
            }
            else
            {
                if (self.currentShape == 4)
                    frame = CGRectMake(x, y, (fabs(height)+fabs(width))/2, (fabs(height)+fabs(width))/2);
                
                
                

                
                currentView = self.myViews.lastObject;
                currentView.frame = frame;
                currentView.dekNum = dekNum;
                currentView.numOfSides = 3;
                [self.myViews removeLastObject];
                [self.myViews addObject:currentView];
                [currentView setNeedsDisplay];
            }*/
            break;
            
        case movement:
            
            if (self.hitTheMoovingHandle)
            {
                self.stopOfMove = [touch locationInView:self.view];
                CGRect frame = CGRectMake(self.stopOfMove.x - self.viewToMove.frame.size.width/2,
                                          self.stopOfMove.y - self.viewToMove.frame.size.height/2,
                                          self.viewToMove.frame.size.width, self.viewToMove.frame.size.height);
                
                [self.myViews removeObject:self.viewToMove];
                self.viewToMove.frame = frame;
                [self.myViews addObject:self.viewToMove];
                [self.viewToMove setNeedsDisplay];
            }
            
            break;
            
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.currentShape == 6)
    {
        
    }
    
    if (self.hitTheMoovingHandle)
    {
        [[self.viewToMove subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.viewToMove setNeedsDisplay];
        self.viewToMove = nil;
        self.hitTheMoovingHandle = NO;
    }
    [self removeGarbage];
}

- (void)removeGarbage
{
    NSMutableArray *toDelete = [[NSMutableArray alloc] init];
    for (FigureDrawer *f in self.myViews)
    {
        if (f.frame.size.height == 0 && f.frame.size.width == 0)
        {
            [toDelete addObject:f];
            [f removeFromSuperview];
        }
    }
    [self.myViews removeObjectsInArray:toDelete];
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}


- (IBAction)Undo:(UIButton *)sender
{
    [[self.myViews lastObject] removeFromSuperview];
    [self.myViews removeLastObject];
}

#pragma mark - delegate Methods

- (void)didSelectWidth:(NSInteger)width AndOpacity:(CGFloat)opacity
{
    self.lineWidth = width;
    self.inset = [[NSNumber alloc]initWithDouble:width/2];
}

- (void)didSelectColor:(UIColor *)color
{
    self.currentColor = color;
}

- (void)didSelectShape:(NSInteger)shape
{
    self.currentShape = shape;
}

- (void)didSelectImage:(UIImage *)image
{
    self.currentImage = image;
    self.currentShape = 5;
}

- (void)didSelectOperation:(NSInteger)operation
{
    self.currentOperation = (int)operation;
    switch (self.currentOperation)
    {
        case drawing:
            self.currentOperationOutlet.text = @"drawing";
            [self.view removeGestureRecognizer:self.pinchGesture];
            self.pinchGesture = nil;
            [self.view removeGestureRecognizer:self.lPGesture];
            self.lPGesture = nil;
            break;
            
        case movement:
            self.currentOperationOutlet.text = @"moving";
            self.lPGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(LongPressDetected:)];
            self.lPGesture.numberOfTouchesRequired = 1;
            [self.view addGestureRecognizer:self.lPGesture];
            
            [self.view removeGestureRecognizer:self.pinchGesture];
            [self.view removeGestureRecognizer:self.rotationGesture];
            self.rotationGesture = nil;
            self.pinchGesture = nil;
            break;
            
        case scaleing:
            self.currentOperationOutlet.text = @"scaling";
            self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(PinchDetected:)];
            [self.view addGestureRecognizer:self.pinchGesture];
            
            [self.view removeGestureRecognizer:self.lPGesture];
            [self.view removeGestureRecognizer:self.rotationGesture];
            self.rotationGesture = nil;
            self.lPGesture = nil;
            break;
            
        case rotating:
            self.currentOperationOutlet.text = @"rotation";
            self.rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)];
            [self.view addGestureRecognizer:self.rotationGesture];
            
            [self.view removeGestureRecognizer:self.lPGesture];
            [self.view removeGestureRecognizer:self.pinchGesture];
            self.lPGesture = nil;
            self.pinchGesture = nil;
            break;
            
        default:
            break;
    }
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
