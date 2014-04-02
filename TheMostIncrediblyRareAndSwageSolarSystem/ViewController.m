//
//  ViewController.m
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"
#import "SolarSystemController.h"

@interface ViewController () {
    int _touchArea;
	CGPoint _startPos, _moveDist[2];
    float _avgX, _avgY, _avgZ;
    float _varX, _varY, _varZ;
    int _filterMode;
    BOOL isTouched;
    BOOL cmDisabled;
    
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

@property (nonatomic, strong) CMMotionManager *motman;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation ViewController

@synthesize context = _context;
@synthesize effect = _effect;

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
    if (!self.context)
    {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
    
    solarSystem = [[SolarSystemController alloc] init];
	
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Pause Rotation", @"Resume Rotation", nil]];
    segment.frame = CGRectMake(20.0, 20.0, 320.0, 44.0);
    segment.tintColor = [UIColor whiteColor];
    [self.view addSubview:segment];
    [segment addTarget:self action:@selector(segmentValueChaged:) forControlEvents:UIControlEventValueChanged];
    
    UISegmentedControl *segment2 = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Pause CoreMotion", @"Resume CoreMotion", nil]];
    segment2.frame = CGRectMake(20.0, 84.0, 380.0, 44.0);
    segment2.tintColor = [UIColor whiteColor];
    [self.view addSubview:segment2];
    [segment2 addTarget:self action:@selector(segment2ValueChaged:) forControlEvents:UIControlEventValueChanged];
    
    
    self.motman = [CMMotionManager new];
    if ((self.motman.accelerometerAvailable)&&(self.motman.gyroAvailable))
        // alternative: self.motman.deviceMotionAvailable == YES iff both accelerometer and gyros are available.
    {
        [self startMonitoringMotion];
    }
    else
        NSLog(@"Oh well, accelerometer or gyro unavailable...");
    
    _filterMode = kFILTERMODELOWPASS;
    _avgX = _avgY = _avgZ = 0.0;
    _varX = _varY = _varZ = 0.0;
    
    // Create and initialize a tap gesture
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToTapGesture:)];
    
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    [self.view addGestureRecognizer:tapRecognizer];
    
    [self initLighting];
    [self setClipping];
}

#pragma mark - GLKView and GLKViewController delegate methods

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glEnable(GL_DEPTH_TEST);
    
	glClearColor(0.0f,0.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	[solarSystem executeSolarSystem];
}

-(void)initLighting {
	GLfloat sunPos[]={0.0,0.0,0.0,1.0};
    
	GLfloat white[]={1.0,1.0,1.0,1.0};
	GLfloat yellow[]={1.0,1.0,0.0,1.0};
	
	//lights go here
	
	glLightfv(SS_SUNLIGHT,GL_POSITION,sunPos);
	glLightfv(SS_SUNLIGHT,GL_DIFFUSE,white);
	glLightfv(SS_SUNLIGHT,GL_AMBIENT,white);
    
	//materials go here
	
	glMaterialf(GL_FRONT_AND_BACK,GL_SHININESS,25);
    
	glShadeModel(GL_SMOOTH);
	glLightModelf(GL_LIGHT_MODEL_TWO_SIDE,0.0);
	
	glEnable(GL_LIGHTING);
	glEnable(SS_SUNLIGHT);
}


-(void)setClipping {
    
	float aspectRatio;
	const float zNear = .1;
	const float zFar = 1000;
	const float fieldOfView = 90;
	GLfloat	size;
	
	CGRect frame = [[UIScreen mainScreen] bounds];
    
	aspectRatio = (float)frame.size.width/(float)frame.size.height;
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
    
	size = zNear * tanf(GLKMathDegreesToRadians (fieldOfView) / 2.0);
    
	glFrustumf(-size, size, -size /aspectRatio, size /aspectRatio, zNear, zFar);
	glViewport(0, 0, frame.size.width, frame.size.height);
	
	glMatrixMode(GL_MODELVIEW);
}

#pragma mark - UI event handlers
- (IBAction) segmentValueChaged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [solarSystem pauseRotation];
            break;
        case 1:
            [solarSystem resumeRotation];
            break;
    }
}

- (IBAction) segment2ValueChaged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            cmDisabled = YES;
            break;
        case 1:
            cmDisabled = NO;
            break;
    }
}
- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer {
    if(recognizer.scale > 1){
        [solarSystem zoomIn];
        isTouched = NO;
    } else {
        [solarSystem zoomOut];
        isTouched = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isTouched = YES;
	// get touch location & iPhone display size
	CGPoint pos = [[touches anyObject] locationInView:self.view];
	
	_touchArea = 1;
	_startPos.x = pos.x - _moveDist[_touchArea].x;
	_startPos.y = pos.y - _moveDist[_touchArea].y;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	// get touch location & iPhone display size
	CGPoint pos = [[touches anyObject] locationInView:self.view];
	
	_moveDist[_touchArea].x = pos.x - _startPos.x;
	_moveDist[_touchArea].y = pos.y - _startPos.y;
    [solarSystem panSolarSystem:_moveDist[1] isTouched:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isTouched = NO;
}

#pragma mark - service methods
- (void)startMonitoringMotion
{
    self.motman.accelerometerUpdateInterval = 1.0/kMOTIONUPDATEINTERVAL;
    self.motman.gyroUpdateInterval = 1.0/kMOTIONUPDATEINTERVAL;
    self.motman.showsDeviceMovementDisplay = YES;
    [self.motman startAccelerometerUpdates];
    [self.motman startGyroUpdates];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.motman.accelerometerUpdateInterval
                                                  target:self selector:@selector(pollMotion:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopMonitoringMotion
{
    [self.motman stopAccelerometerUpdates];
    [self.motman stopGyroUpdates];
}

- (void)pollMotion:(NSTimer *)timer
{
    CMAcceleration acc = self.motman.accelerometerData.acceleration;
    float x, y, z;
    [self addAcceleration:acc];
    x = _avgX;
    y = _avgY;
    z = _avgZ;
    NSLog(@"x value%f", x);
    NSLog(@"y value%f", y);
    if(isTouched == NO && cmDisabled == NO){
        [solarSystem panSolarSystem:CGPointMake(x, y) isTouched:NO];
    }
}

#pragma mark - helpers
- (void)addAcceleration:(CMAcceleration)acc
{
    float alpha = 0.1;
    _avgX = alpha*acc.x + (1-alpha)*_avgX;
    _avgY = alpha*acc.y + (1-alpha)*_avgY;
    _avgZ = alpha*acc.z + (1-alpha)*_avgZ;
    _varX = acc.x - _avgX;
    _varY = acc.y - _avgY;
    _varZ = acc.z - _avgZ;
}

- (void)respondToTapGesture:(UITapGestureRecognizer *)recognizer {
    
    //FIXME Do picking based on ray projection and color.
    CGPoint pos = [recognizer locationInView:self.view];
    GLfloat x, y, z;
    NSMutableArray *planets = [solarSystem getPlanets];
    CGRect frame = [[UIScreen mainScreen] bounds];
    pos.x = pos.x - (float)frame.size.width/2;
    pos.y = pos.y - (float)frame.size.height/2;
    NSLog(@"Tap x, %f", pos.x);
    NSLog(@"Tap y, %f", pos.y);
    for (int i = 0; i < [planets count]; i++){
        [planets[i] getPositionX:&x Y:&y Z:&z];
        if (pos.x - 1 <= x <= pos.x + 1){
            if(pos.y - 1 <= y <= pos.y + 1){
            NSLog(@"Planet %i x, %f", i, x);
            NSLog(@"Planet %i y, %f", i, y);
            break;
            }
        }
    }
}


@end