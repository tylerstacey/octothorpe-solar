//
//  Planet.m
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey, Terri-Lynn Rimmer, Mark Gauci on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import "Planet.h"

@implementation Planet


// The following init method comes directly from Pro OpenGL ES for iOS
// by Mike Smithwick
-(id)initWithStacks:(GLint)stacks Slices:(GLint)slices Radius:(GLfloat)radius Squash:(GLfloat)squash OrbitalPeriod:(GLfloat)orbitalPeriod DistanceFromSun:(GLfloat)distanceFromSun TrackingPlanet:(Planet *)planet TextureFile:(NSString *)textureFile{
    
    unsigned int colorIncrment = 0;
    unsigned int blue = 0;
    unsigned int red = 255;
    int numVertices = 0;
    
    if(textureFile != nil) {
        planetTextureInfo = [self loadTexture:textureFile];
    }
    planetRadius = radius;
    planetSquash = squash;
    
    colorIncrment = 255 / stacks;
    
    if ((self = [super init])) {
        planetStacks = stacks;
        planetSlices = slices;
        planetVertexData = nil;
        planetTexCoordsData = nil;
        
        //vertices
        
        GLfloat *vPtr = planetVertexData = (GLfloat*)malloc(sizeof(GLfloat) * 3 * ((planetSlices * 2 + 2) * (planetStacks)));
        
        //color data
        
        GLubyte *cPtr = planetColorData = (GLubyte*)malloc(sizeof(GLubyte) * 4 * ((planetSlices * 2 + 2) * (planetStacks)));
        
        //normal pointers for lighting
        
        GLfloat *nPtr = planetNormalData = (GLfloat*)malloc(sizeof(GLfloat) * 3 * ((planetSlices * 2 + 2) * (planetStacks)));
        
        GLfloat *tPtr = nil;
        
        if(textureFile != nil) {
            tPtr = planetTexCoordsData = (GLfloat *)malloc(sizeof(GLfloat) * 2 * ((planetSlices*2+2) * (planetStacks)));
        }
        
        unsigned int phiIdx;
        unsigned int thetaIdx;
        
        //latitude
        
        for(phiIdx = 0; phiIdx < planetStacks; phiIdx++) {
            //starts at -1.57 goes up to +1.57 radians
            
            //the first circle
            
            float phi0 = M_PI * ((float)(phiIdx+0) * (1.0/(float)(planetStacks)) - 0.5);
            
            //the next, or second one.
            
            float phi1 = M_PI * ((float)(phiIdx+1) * (1.0/(float)(planetStacks)) - 0.5);
            float cosPhi0 = cos(phi0);
            float sinPhi0 = sin(phi0);
            float cosPhi1 = cos(phi1);
            float sinPhi1 = sin(phi1);
            
            float cosTheta;
            float sinTheta;
            
            //longitude
            
            for(thetaIdx = 0; thetaIdx < planetSlices; thetaIdx++) {
                //Increment along the longitude circle each "slice."
                
                float theta = -2.0*M_PI * ((float)thetaIdx) * (1.0/(float)(planetSlices-1));
                cosTheta = cos(theta);
                sinTheta = sin(theta);
                
                //We're generating a vertical pair of points, such
                //as the first point of stack 0 and the first point
                //of stack 1
                //above it. This is how TRIANGLE_STRIPS work,
                //taking a set of 4 vertices and essentially drawing
                //two triangles
                //at a time. The first is v0-v1-v2 and the next is
                //v2-v1-v3. Etc.
                
                //Get x-y-z for the first vertex of stack.
                
                vPtr[0] = planetRadius * cosPhi0 * cosTheta;
                vPtr[1] = planetRadius * sinPhi0 * planetSquash;
                vPtr[2] = planetRadius * (cosPhi0 * sinTheta);
                
                //the same but for the vertex immediately above the
                //previous one
                
                vPtr[3] = planetRadius * cosPhi1 * cosTheta;
                vPtr[4] = planetRadius * sinPhi1 * planetSquash;
                vPtr[5] = planetRadius * (cosPhi1 * sinTheta);
                
                //normal pointers for lighting
                
                nPtr[0] = cosPhi0 * cosTheta;
                nPtr[2] = cosPhi0 * sinTheta;
                nPtr[1] = sinPhi0;
                
                nPtr[3] = cosPhi1 * cosTheta;
                nPtr[5] = cosPhi1 * sinTheta;
                nPtr[4] = sinPhi1;
                
                if(tPtr != nil) {
                    GLfloat texX = (float)thetaIdx * (1.0f/(float)(planetSlices-1));
                    tPtr[0] = texX;
                    tPtr[1] = (float)(phiIdx+0) * (1.0f/(float)(planetStacks));
                    tPtr[2] = texX;
                    tPtr[3] = (float)(phiIdx+1) * (1.0f/(float)(planetStacks));
                }
                
                cPtr[0] = red;
                cPtr[1] = 0;
                cPtr[2] = blue;
                cPtr[4] = red;
                cPtr[5] = 0;
                cPtr[6] = blue;
                cPtr[3] = cPtr[7] = 255;
                
                cPtr += 2 * 4;
                vPtr += 2 * 3;
                nPtr += 2 * 3;
                
                
                if(tPtr!=nil) {
                    tPtr += 2*2;
                }
            }
            
            blue += colorIncrment;
            red -= colorIncrment;
            
            // Degenerate triangle to connect stacks and maintain
            //winding order.
            
            vPtr[0] = vPtr[3] = vPtr[-3];
            vPtr[1] = vPtr[4] = vPtr[-2];
            vPtr[2] = vPtr[5] = vPtr[-1];
            
            nPtr[0] = nPtr[3] = nPtr[-3];
            nPtr[1] = nPtr[4] = nPtr[-2];
            nPtr[2] = nPtr[5] = nPtr[-1];
            
            if(tPtr!=nil)
            {
                tPtr[0] = tPtr[2] = tPtr[-2];         //6
                tPtr[1] = tPtr[3] = tPtr[-1];
            }
            
        }
        
        numVertices = (vPtr-planetVertexData)/6;
    }
    
    planetAngle = 0.0;
    planetOrbitalPeroid = orbitalPeriod;
    planetDistanceFromSun = distanceFromSun;
    trackingPlanet = planet;
    
    planetPos[0] = 0.0;
    planetPos[1] = 0.0;
    planetPos[2] = 0.0;
    
    return self;
}
// The following init method comes directly from Pro OpenGL ES for iOS
// by Mike Smithwick
-(bool)drawPlanet {
    
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    glFrontFace(GL_CW);
    
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    if(planetTextureInfo != nil) {
        glEnable(GL_TEXTURE_2D);                                     //1
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        
        if(planetTextureInfo != 0){
            glBindTexture(GL_TEXTURE_2D, planetTextureInfo.name);
        }
        glTexCoordPointer(2, GL_FLOAT, 0, planetTexCoordsData);
    }
    
    
    
    glMatrixMode(GL_MODELVIEW);
    
    glVertexPointer(3, GL_FLOAT, 0, planetVertexData);
    glNormalPointer(GL_FLOAT, 0, planetNormalData);
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, planetColorData);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, (planetSlices + 1) * 2 * (planetStacks - 1) + 2);
    
    glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    return true;
}

-(void)setPositionX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z {
    
	planetPos[0] = x;
	planetPos[1] = y;
	planetPos[2] = z;
}

-(void)getPositionX:(GLfloat *)x Y:(GLfloat *)y Z:(GLfloat *)z {
    
	*x = planetPos[0];
	*y = planetPos[1];
	*z = planetPos[2];
}

-(void)updatePosition:(BOOL)isPaused {
    if (isPaused == NO){
        GLfloat x, y, z;
        [trackingPlanet getPositionX:&x Y:&y Z:&z];
        planetAngle += 1.0/planetOrbitalPeroid;
        float radian;
        radian = planetAngle * (3.14/180.0f);
        planetPos[0] = (float)sin(radian) * planetDistanceFromSun + x;
        planetPos[2] = (float)cos(radian) * planetDistanceFromSun + z;
    }
    NSLog(@"ORBIT %f ", planetOrbitalPeroid);
    
	glTranslatef(planetPos[0],planetPos[1],planetPos[2]);
    float orb = [[NSString stringWithFormat:@"%.3f",planetOrbitalPeroid]floatValue];
    float venusOrb = [[NSString stringWithFormat:@"%.3f",0.615]floatValue];
    if(orb==venusOrb)
        glRotatef(-planetAngle, 0, 1, 0);
    else
        glRotatef(planetAngle, 0, 1, 0);
    glTranslatef(0,0,0);
}

-(GLKTextureInfo *)loadTexture:(NSString *)filename {
    
    NSError *error;
    GLKTextureInfo *info;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft,
                            [NSNumber numberWithBool:TRUE],GLKTextureLoaderGenerateMipmaps,nil];
    
    
    NSString *path = [[NSBundle mainBundle]pathForResource:filename ofType:NULL];
    
    info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    glBindTexture(GL_TEXTURE_2D, info.name);
    
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
    
    return info;
}

@end
