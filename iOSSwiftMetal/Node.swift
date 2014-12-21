//
//  Node.swift
//  iOSSwiftMetal
//
//  Created by Bradley Griffith on 11/27/14.
//  Copyright (c) 2014 Bradley Griffith. All rights reserved.
//

import Foundation
import Metal
import QuartzCore

class Node {
 
	let name: String
	var vertexCount: Int
	var vertexBuffer: MTLBuffer
	var device: MTLDevice
 
	init(name: String, vertices: Array<Vertex>, device: MTLDevice){
		var vertexData = Array<Float>()
		for vertex in vertices{
			vertexData += vertex.floatBuffer()
		}
		
		let dataSize = vertexData.count * sizeofValue(vertexData[0])
		vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: nil)
		
		self.name = name
		self.device = device
		vertexCount = vertices.count
	}
	
	func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, clearColor: MTLClearColor?){
		
		let renderPassDescriptor = MTLRenderPassDescriptor()
		renderPassDescriptor.colorAttachments[0].texture = drawable.texture
		renderPassDescriptor.colorAttachments[0].loadAction = .Clear
		renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
		renderPassDescriptor.colorAttachments[0].storeAction = .Store
			
		let commandBuffer = commandQueue.commandBuffer()
			
		let renderEncoderOpt = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
		if let renderEncoder = renderEncoderOpt {
		renderEncoder.setRenderPipelineState(pipelineState)
		renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
		renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount/3)
		renderEncoder.endEncoding()
		}
			
		commandBuffer.presentDrawable(drawable)
		commandBuffer.commit()
	}
 
}