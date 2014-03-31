//
//  SolarSystemController.m
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import "SolarSystemController.h"
#import "SolarSystem.h"
#include "gluLookAt.h"
@implementation SolarSystemController

-(id)init {
    
	[self initGeometry];
	
	return self;
}

-(void)initGeometry {
    eyePosition[X_VALUE] = 0.0;
    eyePosition[Y_VALUE] = 0.0;
    eyePosition[Z_VALUE] = 6.0;
    
    planetSun = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:2.0] Squash:1.0 OrbitalPeriod:0.0 DistanceFromSun:[self auFromTheSun:0.0] TrackingPlanet:planetSun TextureFile:@"Sun.png"];
	[planetSun setPositionX:0.0 Y:0.0 Z:0.0];
    
    planetMercury = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:0.383] Squash:1.0 OrbitalPeriod:0.240 DistanceFromSun:[self auFromTheSun:0.387] TrackingPlanet:planetSun TextureFile:@"Mercury.png"];
    [planetMercury setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:0.387]];
    
    planetVenus = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:0.950] Squash:1.0 OrbitalPeriod:0.615 DistanceFromSun:[self auFromTheSun:0.723] TrackingPlanet:planetSun TextureFile:@"Venus.png"];
    [planetVenus setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:0.723]];
    
	planetEarth = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:1.0] Squash:1.0 OrbitalPeriod:1.0 DistanceFromSun:[self auFromTheSun:1.0] TrackingPlanet:planetSun TextureFile:@"Earth.png"];
	[planetEarth setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:1.0]];
    
    planetMoon = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:0.273] Squash:1.0 OrbitalPeriod:0.0748 DistanceFromSun:[self auFromTheSun:0.257] TrackingPlanet:planetEarth TextureFile:@"Moon.png"];
	[planetMoon setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:1.0]];
    
    planetMars = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:0.532] Squash:1.0 OrbitalPeriod:1.881 DistanceFromSun:[self auFromTheSun:1.524] TrackingPlanet:planetSun TextureFile:@"Mars.png"];
    [planetMars setPositionX:0.0 Y:0.0 Z:[self auFromTheSun:1.524]];
    
    
    
}
-(void)executeSolarSystem {
    
	GLfloat white[] = {1.0,1.0,1.0,1.0};
	GLfloat black[] = {0.0,0.0,0.0,0.0};
	GLfloat sunPos[3] = {0.0,0.0,0.0};
    
	glPushMatrix();
    
    static GLfloat x, y, z, mahAngle;
    z = 10.0;
	float radian;
    mahAngle += 1.0;
    radian = mahAngle * (3.14/180.0f);
    //eyePosition[Y_VALUE] = (float)sin(radian) * z;
    //eyePosition[Z_VALUE] = (float)cos(radian) * z;
    //GLfloat eyeYtemp = (float)sin(radian-1) * z;
    //GLfloat eyeZtemp = (float)cos(radian-1) * z;
    //[planetEarth getPositionX:&x Y:&y Z:&z];
    //gluLookAt(0, eyePosition[Y_VALUE], eyePosition[Z_VALUE], 0, 0, 0, 0, eyeYtemp-eyePosition[Y_VALUE],eyeZtemp-eyePosition[Z_VALUE]);
    glTranslatef(-eyePosition[X_VALUE],-eyePosition[Y_VALUE],-eyePosition[Z_VALUE]);
	glLightfv(SS_SUNLIGHT,GL_POSITION, sunPos);
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, white);
    
	glPushMatrix();
    [planetMercury updatePosition];
	[planetMercury drawPlanet];
    glPopMatrix();

    glPushMatrix();
     [planetVenus updatePosition];
     [planetVenus drawPlanet];
    glPopMatrix();
    
    glPushMatrix();
    [planetMoon updatePosition:YES];
    [planetMoon drawPlanet];
    glPopMatrix();
    
    glPushMatrix();
     [planetEarth updatePosition];
     [planetEarth drawPlanet];
    glPopMatrix();
    
    glPushMatrix();
     [planetMars updatePosition];
     [planetMars drawPlanet];
    glPopMatrix();
	
	glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, white);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, black);
    
	[planetSun drawPlanet];
	
	glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, black);
	
	glPopMatrix();

}


-(GLfloat)earthWidths:(GLfloat)earthWidths {
    return 0.5 * earthWidths;
}

-(GLfloat)auFromTheSun:(GLfloat)au {
    return au * -4.0;
}

-(void)zoomOut {
    eyePosition[Z_VALUE] += 0.10;
}
-(void)zoomIn {
    eyePosition[Z_VALUE] -= 0.10;
}

-(void)panSolarSystem:(CGPoint)moveDist{
    eyePosition[X_VALUE] = -1*moveDist.x/100;
    eyePosition[Y_VALUE] = moveDist.y/100;
    
}

@end
