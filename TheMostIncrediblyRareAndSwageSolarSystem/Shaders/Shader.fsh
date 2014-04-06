//
//  Shader.fsh
//  TheMostIncrediblyRareAndSwageSolarSystem
//
//  Created by Tyler Stacey, Terri-Lynn Rimmer, Mark Gauci on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
