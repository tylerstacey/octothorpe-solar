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
    
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
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
    [self initLighting];
    [self setClipping];
}
- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer {
    if(recognizer.scale > 1){
        [solarSystem zoomOut];
    } else {
        [solarSystem zoomIn];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
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
    [solarSystem panSolarSystem:_moveDist[1]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
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
	const float fieldOfView = 90.0;
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


@end