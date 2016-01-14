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

@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint stop;
@property (nonatomic, strong) NSNumber* inset;

@property (nonatomic, assign) CGPoint startOfMove;
@property (nonatomic, assign) CGPoint stopOfMove;
@property (nonatomic, strong) FigureDrawer *viewToMove;
@property (nonatomic,assign) BOOL hitTheMoovingHandle;

@property (nonatomic, strong) UIView *viewToScale;
@property (nonatomic, assign) CGFloat currentScale;

@property (nonatomic, strong) NSMutableArray *currentPointsOfLine;

@property (nonatomic, strong) UILongPressGestureRecognizer *lPGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UIRotationGestureRecognizer *rotationGesture;
@property (nonatomic, assign) OperationType currentOperation;



@property (nonatomic, strong) UIImageView* handleToMove;
@property (nonatomic, strong) UIImageView* handleToDelete;
@property (nonatomic, assign) BOOL isInProgress;

@property (nonatomic, strong) LineDrawer* helperLineCanvas;

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

@property (nonatomic, strong) UIView *chosenArea;



@end

@implementation CanvasViewController

- (void)setNumOfSides:(NSInteger)numOfSides
{
    _numOfSides = numOfSides;
}

/*-(void)setCurrentOperationWithNSNumber:(NSNumber*)number
{
    [self setCurrentOperation:[number intValue]];
}*/

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

    
    self.isInProgress = NO;
    
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
                self.viewToMove = (FigureDrawer *)[sender.view hitTest:location withEvent:nil];
            
            else
                return;
            NSLog(@"viewtomove %@",self.viewToMove);
            [self.viewToMove removeFromSuperview];
            [self.view addSubview:self.viewToMove];
            if (self.viewToMove.frame.size.height > 90 && self.viewToMove.frame.size.width > 90 /*&& !self.viewToMove.WasRorated*/)
            {
                self.handleToMove = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                  self.viewToMove.bounds.size.width/2-45/2,
                                                                                  self.viewToMove.bounds.size.height/2-45/2, 45, 45)];
                self.handleToDelete = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                    self.viewToMove.bounds.size.width-45,
                                                                                    0, 45, 45)];
            }
            else
            {
                self.handleToMove = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                  self.viewToMove.frame.size.width-self.viewToMove.bounds.size.width,
                                                                                  self.viewToMove.frame.size.height-self.viewToMove.bounds.size.height,
                                                                                  self.viewToMove.frame.size.width/2-1,
                                                                                  self.viewToMove.frame.size.height)];
                self.handleToDelete = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                                    self.viewToMove.frame.size.width-self.viewToMove.bounds.size.width/2,
                                                                                    self.viewToMove.frame.size.height-self.viewToMove.bounds.size.height,
                                                                                    self.viewToMove.frame.size.width/2,
                                                                                    self.viewToMove.frame.size.height)];
            }
            self.handleToMove.image = [UIImage imageNamed:@"move4545.png"];
            self.handleToMove.tag = 101;
            self.handleToDelete.image = [UIImage imageNamed:@"Delete-icon4545.png"];
            self.handleToDelete.tag = 109;
            [self.viewToMove addSubview:self.handleToMove];
            [self.viewToMove addSubview:self.handleToDelete];
            self.isInProgress =YES;
            CGRect frame = CGRectMake(0, 0,
                                      self.viewToMove.bounds.size.width,
                                      self.viewToMove.bounds.size.height);
            
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
        if ([[sender.view hitTest:location withEvent:nil] isKindOfClass:[FigureDrawer class]])
        {
            //static BOOL isViewGoodToMove = NO;
            self.viewToScale = [sender.view hitTest:location withEvent:nil];
           /* if ([self.viewToScale isKindOfClass:[FigureDrawer class]])
                isViewGoodToMove = YES;*/
        }
        else
        {
            [self.delegate HighLightCurrentOperation];
            return;
        }
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
    CGFloat rotation = 0.0;
    
    CGPoint location = [sender locationInView:sender.view];
    self.viewToScale = [sender.view hitTest:location withEvent:nil];
    FigureDrawer * figureToScale = (FigureDrawer*)self.viewToScale;
    if (self.viewToScale  != self.view)
    {
        if (figureToScale.WasRorated == NO)
        {
            figureToScale.frameBeforeTransform = figureToScale.frame;
            figureToScale.WasRorated = YES;
        }
        
        [self.myViews removeObject:self.viewToScale];
        rotation = sender.rotation;
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
        self.viewToScale.transform = transform;
        figureToScale.rotationAngle = rotation;
    }
    else if (self.viewToScale  == self.view)
    {
        [self.delegate HighLightCurrentOperation];
    }
    [self.myViews addObject:figureToScale];
    
    [figureToScale setNeedsDisplay];
}

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
                frame = CGRectMake(self.start.x, self.start.y, self.lineWidth, self.lineWidth);
                
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
            
            BOOL isPointInsideMove = CGRectContainsPoint(self.handleToMove.frame, locationOfTouch);
            BOOL isPointInsideDelete = CGRectContainsPoint(self.handleToDelete.frame, locationOfTouch);
            NSLog(@"move %@",self.handleToMove);
            NSLog(@"touch x:%f y:%f",locationOfTouch.x, locationOfTouch.y);
            if (isPointInsideMove)
            {
                self.hitTheMoovingHandle = YES;
                self.isInProgress = NO;
            }
            else if (isPointInsideDelete)
            {
                [self.viewToMove removeFromSuperview];
                [self.myViews removeObject:self.viewToMove];
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
//                ////
//                self.stopOfMove = [touch locationInView:self.view];
//                CGRect frame = CGRectMake(self.stopOfMove.x - self.viewToMove.frame.size.width/2,
//                                          self.stopOfMove.y - self.viewToMove.frame.size.height/2,
//                                          self.viewToMove.frame.size.width, self.// Это меняется КАК????
//                                          viewToMove.frame.size.height);
//                /////
                self.stopOfMove = [touch locationInView:self.view];
                
                [self.myViews removeObject:self.viewToMove];
                self.viewToMove.center = self.stopOfMove;
                [self.myViews addObject:self.viewToMove];
                //[self.viewToMove setNeedsDisplay];
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
    if (self.currentShape == 6)
    {
        
    }
    
    if (self.currentOperation == chosingArea)
    {
        self.currentOperation = drawing;
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
    
}

- (void)highLightGivenLayerAtIndex:(NSInteger)index
{
    FigureDrawer *currentFigure = self.myViews[index];
    UIView *light = [[UIView alloc] initWithFrame:currentFigure.bounds];
    light.backgroundColor = [UIColor colorWithRed:0.94 green:0.75 blue:0.31 alpha:0.44];
    if (currentFigure.subviews.count == 0)
        [currentFigure addSubview:light];
    /*currentFigure.backgroundColor = [UIColor colorWithRed:0.94 green:0.75 blue:0.31 alpha:0.44];*/
    self.myViews[index] = currentFigure;
    [currentFigure setNeedsDisplay];
}

- (void)unHighlighGiventLayerAtIndex:(NSInteger)index
{
    FigureDrawer *currentFigure = self.myViews[index];
    [[currentFigure subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //currentFigure.backgroundColor = [UIColor clearColor];
    self.myViews[index] = currentFigure;
    [currentFigure setNeedsDisplay];
}

- (void)putUpCurrentLayerAtIndex:(NSInteger)index
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

- (void)putDownCurrentLayerAtIndex:(NSInteger)index
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

#pragma mark - delegate Methods

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
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.myViews forKey:@"arrayOfFigureDrawers"];
    [archiver finishEncoding];
    [data writeToFile:documentFile atomically:YES];
    
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

- (void)loadDataFromFile:(NSString *)docFilePath
{
    
    NSData *loadedData = [[NSData alloc] initWithContentsOfFile:docFilePath];
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

- (void)changeFigureName:(NSInteger)layer toName:(NSString *)name
{
    [[self.myViews objectAtIndex:layer] setFigureName:name];
}

#pragma mark - Navigation


/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    
    if ([segueName isEqualToString: @"fileManagment"])
    {
        self.fileViewController = (FileManagingVC *) [segue destinationViewController];
    }
    self.fileViewController.delegate = self;

}*/


@end
