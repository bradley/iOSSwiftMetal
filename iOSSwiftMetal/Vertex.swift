//
//  Vertex.swift
//  iOSSwiftMetal
//
//  Created by Bradley Griffith on 11/27/14.
//  Copyright (c) 2014 Bradley Griffith. All rights reserved.
//

struct Vertex{
 
	var x,y,z: Float     // position data
	var r,g,b,a: Float   // color data
 
	func floatBuffer() -> [Float] {
		return [x,y,z,r,g,b,a]
	}
 
};