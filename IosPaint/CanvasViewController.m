//
//  CanvasViewController.m
//  IosPaint
//
//  Created by Olexander_Chechetkin on 12/18/15.
//  Copyright © 2015 Olexander_Chechetkin. All rights reserved.
//

#import "CanvasViewController.h"
#import "FigureDrawer.h"
#import "LineDrawer.h"

@interface CanvasViewController ()

@property (nonatomic, assign) NSInteger lineWidth;
@property (nonatomic, strong) UIColor* currentColor;
@property (nonatomic, assign) NSInteger currentShape;
@property (nonatomic, assign) NSInteger numOfSides;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint stop;
//description:
//start and stop opints is poinst of start touch and stop touch needed for creating frame for figure

@property (nonatomic, strong) FigureDrawer *viewToModify;
//viewToModify is view, that temporary contains modifying figure

@property (nonatomic, assign) BOOL isInProgress;
//determines is view currently in stage of modifuing or not

@property (nonatomic, strong) UIImageView* handleToMove;
@property (nonatomic, strong) UIImageView* handleToDelete;
//those views are used for  handling figure that is modifying

@property (nonatomic,assign) BOOL hitTheMoovingHandle;
//hitTheMoovingHandle is true when user hit handleToMove

@property (nonatomic, strong) NSMutableArray *currentPointsOfLine;
//is used to store points trough witch line would be drawn

@property (nonatomic, strong) UILongPressGestureRecognizer *lPGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGesture;

@property (nonatomic, assign) OperationType currentOperation;
//e.g. what mode is currently used

@property (nonatomic, strong) LineDrawer* helperLineCanvas;
//lines, that help to make good-looking pfoto size

@property (nonatomic, strong) UIView *chosenArea;
//area from canvas to be saved to gallery

@property (nonatomic, strong) NSNumber* inset;

@end


@implementation CanvasViewController

- (void)setNumOfSides:(NSInteger)numOfSides
{
    _numOfSides = numOfSides;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.numOfSides = 0;
    self.currentShape = 0;
    self.lineWidth = 5;
    self.inset = [[NSNumber alloc] initWithDouble:self.lineWidth/2];
    self.isInProgress = NO;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - gestures
- (void)LongPressDetected:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (!self.isInProgress)
        {
            CGPoint location = [sender locationInView:sender.view];
            if ([sender.view hitTest:location withEvent:nil] != self.view &&
                [[sender.view hitTest:location withEvent:nil] isKindOfClass:[FigureDrawer class]])
                self.viewToModify = (FigureDrawer *)[sender.view hitTest:location withEvent:nil];
            
            else
                return;
            [self.viewToModify removeFromSuperview];
            [self.view addSubview:self.viewToModify];
            if (self.viewToModify.frame.size.height > 90 && self.viewToModify.frame.size.width > 90)
            {
                self.handleToMove = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                  self.viewToModify.bounds.size.width/2-45/2,
                                                                                  self.viewToModify.bounds.size.height/2-45/2, 45, 45)];
                self.handleToDelete = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                    self.viewToModify.bounds.size.width-45,
                                                                                    0, 45, 45)];
            }
            else
            {
                self.handleToMove = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                  self.viewToModify.frame.size.width-self.viewToModify.bounds.size.width,
                                                                                  self.viewToModify.frame.size.height-self.viewToModify.bounds.size.height,
                                                                                  self.viewToModify.frame.size.width,
                                                                                  self.viewToModify.frame.size.height)];
            }
            self.handleToMove.image = [UIImage imageNamed:@"move4545.png"];
            self.handleToMove.tag = 101;
            self.handleToDelete.image = [UIImage imageNamed:@"Delete-icon4545.png"];
            self.handleToDelete.tag = 109;
            [self.viewToModify addSubview:self.handleToMove];
            [self.viewToModify addSubview:self.handleToDelete];
            self.isInProgress =YES;
            CGRect frame = CGRectMake(0, 0,
                                      self.viewToModify.bounds.size.width,
                                      self.viewToModify.bounds.size.height);
            
            UIView *background = [[UIView alloc] initWithFrame:frame];
            background.backgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.94 alpha:0.2];
            [self.viewToModify addSubview:background];
        }
    }
}

- (void)PinchDetected:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [sender locationInView:sender.view];
        if ([[sender.view hitTest:location withEvent:nil] isKindOfClass:[FigureDrawer class]])
        {
            FigureDrawer *f = (FigureDrawer *)[sender.view hitTest:location withEvent:nil];
            if (f.shape != 6)//pan line
                self.viewToModify = f;
            else
                return;
        }
        else
        {
            [self.delegate HighLightCurrentOperation];
            return;
        }
        self.viewToModify.backgroundColor = [UIColor colorWithRed:0.23 green:0.67 blue:0.94 alpha:0.2];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.viewToModify.backgroundColor = [UIColor clearColor];
        self.viewToModify = nil;
    }
    
    if(self.viewToModify)
    {
        
        CGFloat scale = sender.scale;
        
        if (self.viewToModify.rotationAngle)
        {
            //reset rotation
            self.viewToModify.transform = CGAffineTransformIdentity;
            
            //scale with frame before rotation
            CGFloat xDiferance = self.viewToModify.frameBeforeRotation.size.width * scale - self.viewToModify.frameBeforeRotation.size.width;
            CGFloat yDiferance = self.viewToModify.frameBeforeRotation.size.height * scale - self.viewToModify.frameBeforeRotation.size.height;
            
            CGRect frame = CGRectMake(self.viewToModify.frame.origin.x - xDiferance/2,
                                      self.viewToModify.frame.origin.y - yDiferance/2,
                                      self.viewToModify.frame.size.width + xDiferance,
                                      self.viewToModify.frame.size.height + yDiferance);
            
            self.viewToModify.frameBeforeRotation = frame;
            self.viewToModify.frame = frame;
            [self.viewToModify setNeedsDisplay];
            sender.scale = 1.0;
            
            //apply rotation back
            CGAffineTransform rotation = CGAffineTransformMakeRotation(self.viewToModify.rotationAngle);
            self.viewToModify.transform = rotation;
        }
        else
        {
            CGFloat xDiferance = self.viewToModify.frame.size.width * scale - self.viewToModify.frame.size.width;
            CGFloat yDiferance = self.viewToModify.frame.size.height * scale - self.viewToModify.frame.size.height;
            
            CGRect frame = CGRectMake(self.viewToModify.frame.origin.x - xDiferance/2,
                                      self.viewToModify.frame.origin.y - yDiferance/2,
                                      self.viewToModify.frame.size.width + xDiferance,
                                      self.viewToModify.frame.size.height + yDiferance);
            
            self.viewToModify.frame = frame;
            
            [self.viewToModify setNeedsDisplay];
            sender.scale = 1.0;
        }
    }
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)sender
{
    CGFloat rotation = 0.0;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint location = [sender locationInView:sender.view];
        self.viewToModify = (FigureDrawer *)[sender.view hitTest:location withEvent:nil];
        if (self.viewToModify.rotationAngle)
            rotation = self.viewToModify.rotationAngle;
    }
    
    
    if (self.viewToModify  != self.view)
    {
        
        if (self.viewToModify.WasRorated == NO)
        {
            self.viewToModify.frameBeforeRotation = self.viewToModify.frame;
            self.viewToModify.WasRorated = YES;
        }
        
        [self.myViews removeObject:self.viewToModify];
        if (rotation == 0.0)
            rotation = sender.rotation;
        else
            rotation += sender.rotation;
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
        self.viewToModify.transform = transform;
        self.viewToModify.rotationAngle = rotation;
    }
    else if (self.viewToModify  == self.view)
    {
        [self.delegate HighLightCurrentOperation];
    }
    [self.myViews addObject:self.viewToModify];
    
    [self.viewToModify setNeedsDisplay];
}

#pragma mark - touch logic
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [[event allTouches] anyObject];
    CGPoint locationOfTouch = [touch locationInView:touch.view];
    self.start = [touch locationInView:self.view];
    FigureDrawer *currentView;
    CGRect frame;
    switch (self.currentOperation)
    {
        case drawing:
            
            if (self.currentShape == 6)//random line
            {
                self.currentPointsOfLine = [[NSMutableArray alloc] init];
                [self.currentPointsOfLine addObject: [NSValue valueWithCGPoint:self.start]];
                
                frame = CGRectMake(self.view.frame.origin.x,
                                          self.view.frame.origin.y,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height);
                FigureDrawer *currentView = [[FigureDrawer alloc] initWithFrame:frame
                                                                          shape:self.currentShape
                                                                         color:self.currentColor
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
                frame = CGRectMake(self.start.x, self.start.y, self.lineWidth, self.lineWidth);
                
                currentView = [[FigureDrawer alloc] initWithFrame:frame
                                                            shape:self.currentShape
                                                           color:self.currentColor
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
                [[self.viewToModify subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [self.viewToModify setNeedsDisplay];
                self.viewToModify = nil;
                self.hitTheMoovingHandle = NO;
                self.isInProgress = NO;
            }
            
            BOOL isPointInsideMove = CGRectContainsPoint(self.handleToMove.frame, locationOfTouch);
            BOOL isPointInsideDelete = CGRectContainsPoint(self.handleToDelete.frame, locationOfTouch);
            if (isPointInsideMove)
            {
                self.hitTheMoovingHandle = YES;
                self.isInProgress = NO;
            }
            else if (isPointInsideDelete)
            {
                [self.viewToModify removeFromSuperview];
                [self.myViews removeObject:self.viewToModify];
                self.isInProgress = NO;

            }
            
            if (!self.hitTheMoovingHandle && !isPointInsideMove && !isPointInsideDelete)
            {
                [self.delegate HighLightCurrentOperation];
            }
            break;
          
        case scaleing:
            
                [self.delegate HighLightCurrentOperation];
            
            break;
            
        case rotating:
            
            [self.delegate HighLightCurrentOperation];
            
            break;
            
        case chosingArea:
            
            frame = CGRectMake(self.start.x, self.start.y, 0, 0);
            
            self.chosenArea = [[UIView alloc] initWithFrame:frame];
            self.chosenArea.backgroundColor = [UIColor colorWithRed:0.07 green:0.48 blue:0.95 alpha:0.1];
            [self.view addSubview:self.chosenArea];
            
            break;
            
        default:
            break;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [[event allTouches] anyObject];
    FigureDrawer * currentView;
    self.stop = [touch locationInView:self.view];

    switch (self.currentOperation)
    {
        case drawing:
            if (self.currentShape == 6)
            {
                [self.currentPointsOfLine addObject: [NSValue valueWithCGPoint:self.stop]];
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
                    frame = CGRectMake(x, y, MAX(fabs(width), self.inset.doubleValue*2) , MAX(fabs(height), self.inset.doubleValue*2));
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
                currentView.numOfSides = self.numOfSides;
                [self.myViews removeLastObject];
                [self.myViews addObject:currentView];
                [currentView setNeedsDisplay];
                
#pragma mark helper lines
                if (self.currentShape == 5)
                {
                    if (fmodf(self.currentImage.size.height, frame.size.height) <= frame.size.height*0.05)
                    {
                        self.helperLineCanvas = [[LineDrawer alloc] initWithFrame:self.view.frame point:self.stop typeOfLine:@"horizontal"];
                        [self.view addSubview:self.helperLineCanvas];
                    }
                    if (fmodf(self.currentImage.size.width, frame.size.width) <= frame.size.width*0.05)
                    {
                        self.helperLineCanvas = [[LineDrawer alloc] initWithFrame:self.view.frame point:self.stop typeOfLine:@"vertical"];
                        [self.view addSubview:self.helperLineCanvas];
                    }
                    else if (self.helperLineCanvas)
                    {
                        for (UIView *v in self.view.subviews)
                        {
                            if ([v isKindOfClass:[LineDrawer class]])
                            {
                                [v removeFromSuperview];
                            }
                        }
                    }
                }
            }
            break;
        case movement:
            
            if (self.hitTheMoovingHandle)
            {
                CGPoint stopMovingPoint = [touch locationInView:self.view];
                self.viewToModify.center = stopMovingPoint;
                
                self.viewToModify.frameBeforeRotation = CGRectMake(self.viewToModify.frame.origin.x,
                                                                 self.viewToModify.frame.origin.y,
                                                                 self.viewToModify.bounds.size.width,
                                                                 self.viewToModify.bounds.size.height);
            }
            
            break;
            
        case chosingArea:
            {
            CGFloat width = self.stop.x - self.start.x;
            CGFloat height = self.stop.y - self.start.y;
            
            CGFloat x = width >= 0 ? self.start.x : self.start.x + width;
            CGFloat y = height >= 0 ? self.start.y : self.start.y + height;
            
            CGRect frame = CGRectMake(x, y, fabs(width), fabs(height));
            self.chosenArea.frame = frame;
            [self.chosenArea setNeedsDisplay];
            }
            break;
            
        default:
            break;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.currentOperation == chosingArea)
    {
        self.currentOperation = drawing;
    }
    if (self.currentOperation == movement)
    {
        [[self.viewToModify subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.viewToModify setNeedsDisplay];
        self.viewToModify = nil;
        self.isInProgress = NO;
        self.hitTheMoovingHandle = NO;
    }
    [self removeGarbage];
}

- (void)removeGarbage
{
    NSMutableArray *toDelete = [[NSMutableArray alloc] init];
    for (FigureDrawer *f in self.myViews)
    {
        if ([@(f.frame.size.height)  isEqual: @(self.lineWidth)] &&
            [@(f.frame.size.width)  isEqual: @(self.lineWidth)]
            )
        {
            [toDelete addObject:f];
            [f removeFromSuperview];
        }
    }
    [self.myViews removeObjectsInArray:toDelete];
    if (self.helperLineCanvas)
    {
        for (UIView *v in self.view.subviews)
        {
            if ([v isKindOfClass:[LineDrawer class]])
            {
                [v removeFromSuperview];
            }
        }
    }
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark - layer managment
- (void)highLightLayerAtIndex:(NSInteger)index
{
    FigureDrawer *currentFigure = self.myViews[index];
    if (currentFigure.shape == 6)
    {
        [currentFigure highLightPenLine];
    }
    else
    {
        UIView *light = [[UIView alloc] initWithFrame:currentFigure.bounds];
        light.backgroundColor = [UIColor colorWithRed:0.94 green:0.75 blue:0.31 alpha:0.44];
        if (currentFigure.subviews.count == 0)
            [currentFigure addSubview:light];
        self.myViews[index] = currentFigure;
        [currentFigure setNeedsDisplay];
    }
}

- (void)unHighlighLayerAtIndex:(NSInteger)index
{
    FigureDrawer *currentFigure = self.myViews[index];
    if (currentFigure.shape == 6)
    {
        [currentFigure unHighLightPenLine];
    }
    else
    {
        [[currentFigure subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.myViews[index] = currentFigure;
        [currentFigure setNeedsDisplay];
    }
}

- (void)putUpLayerAtIndex:(NSInteger)index
{
    if (index < self.myViews.count-1)
    {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        FigureDrawer * CurrentFigure = [self.myViews objectAtIndex:index];
        [self.myViews removeObjectAtIndex:index];
        [self.myViews insertObject:CurrentFigure atIndex:index+1];
        
        for (FigureDrawer *f in self.myViews)
        {
            [f setNeedsDisplay];
            [self.view addSubview:f];
        }
    }
}

- (void)putDownLayerAtIndex:(NSInteger)index
{
    if (index > 0)
    {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        FigureDrawer * CurrentFigure = [self.myViews objectAtIndex:index];
        [self.myViews removeObjectAtIndex:index];
        [self.myViews insertObject:CurrentFigure atIndex:index-1];
        
        for (FigureDrawer *f in self.myViews)
        {
            [f setNeedsDisplay];
            [self.view addSubview:f];
        }
    }
}

- (void)deleteLayerAtIndex:(NSInteger)index
{
    if (index >= 0)
    {
        if (self.myViews.count != 0)
        {
            if (index <=self.myViews.count-1)
            {
                [[self.myViews objectAtIndex:index] removeFromSuperview];
                [self.myViews removeObjectAtIndex:index];
            }
        }
    }
    
}

#pragma mark - PanelsDelegate methods
- (void)Undo
{
    [[self.myViews lastObject] removeFromSuperview];
    [self.myViews removeLastObject];
}

- (void)didSelectWidth:(NSInteger)width
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
    switch (shape)
    {
        case 0://circleShape,
            [self.delegate showCurrentShape:@"Circle"];
            break;
        case 1://rectangleShape,
            [self.delegate showCurrentShape:@"Rectangle"];
            break;
        case 2://linesShape,
            [self.delegate showCurrentShape:@"Line"];
            break;
        case 3://triangleShape,
            [self.delegate showCurrentShape:@"Triangle"];
            break;
        case 4://rightShape,
            [self.delegate showCurrentShape:@"N-angular"];
            break;
        case 5://imageShape,
            [self.delegate showCurrentShape:@"Image"];
            break;
        case 6://panLine
            [self.delegate showCurrentShape:@"any Line"];
            break;
            
        default:
            break;
    }
}

- (void)didSelectImage:(UIImage *)image
{
    self.currentImage = image;
    self.currentShape = 5;
    [self.delegate showCurrentShape:@"Image"];
}

- (void)didSelectOperation:(NSInteger)operation
{
    self.currentOperation = (int)operation;
    switch (self.currentOperation)
    {
        case drawing:
            [self.delegate showCurrentOperation:@"drawing"];
            [self.view removeGestureRecognizer:self.pinchGesture];
            self.pinchGesture = nil;
            [self.view removeGestureRecognizer:self.lPGesture];
            self.lPGesture = nil;
            break;
            
        case movement:
            [self.delegate showCurrentOperation:@"moving"];
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
            [self.delegate showCurrentOperation:@"scaling"];
            self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(PinchDetected:)];
            [self.view addGestureRecognizer:self.pinchGesture];
            
            [self.view removeGestureRecognizer:self.lPGesture];
            [self.view removeGestureRecognizer:self.rotationGesture];
            self.rotationGesture = nil;
            self.lPGesture = nil;
            break;
            
        case rotating:
            [self.delegate showCurrentOperation:@"rotation"];
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

- (void)allClear
{
    for (FigureDrawer *f in self.view.subviews)
    {
        [f removeFromSuperview];
        self.myViews = nil;
    }
}

- (void)writeFigureToFile:(NSString *)pathComponent
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *documentFile = [documentDirectory stringByAppendingPathComponent:pathComponent];
    NSMutableData *data = [[NSMutableData alloc] init];
    
    if(data)
    {
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        [archiver encodeObject:self.myViews forKey:@"arrayOfFigureDrawers"];
        [archiver finishEncoding];
        [data writeToFile:documentFile atomically:YES];
    }
    
}

- (void)saveFigureToGallery
{
    [self.chosenArea removeFromSuperview];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 1); //making image from view
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *sourceImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([sourceImage CGImage], self.chosenArea.frame);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
    });
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadDataFromFile:(NSString *)pathComponent
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *documentFile = [documentDirectory stringByAppendingPathComponent:pathComponent];
    
    NSData *loadedData = [[NSData alloc] initWithContentsOfFile:documentFile];
    if (loadedData)
    {
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
    }
}

- (void)changeFigureName:(NSInteger)layer toName:(NSString *)name
{
    [[self.myViews objectAtIndex:layer] setFigureName:name];
}

- (void)releaseResources
{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.myViews = nil;
    self.currentColor = nil;
    self.currentImage = nil;
    self.currentPointsOfLine = nil;
    self.currentShape = 0;
    self.currentOperation = 0;
}

@end
