//
//  ViewController.swift
//  iOSSwiftMetal
//
//  Created by Bradley Griffith on 11/27/14.
//  Copyright (c) 2014 Bradley Griffith. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class ViewController: UIViewController {
	
	var device: MTLDevice! = nil
	var metalLayer: CAMetalLayer! = nil

	var objectToDraw: Plane!
	var pipelineState: MTLRenderPipelineState! = nil
	var commandQueue: MTLCommandQueue! = nil
	var timer: CADisplayLink! = nil

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Create reference to default metal device.
		device = MTLCreateSystemDefaultDevice()
		
		self.setupMetalLayer()
		self.createRenderBuffer()
		self.createRenderPipeline()
		self.createCommandQueue()
		self.createDisplayLink()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func setupMetalLayer() {
		metalLayer = CAMetalLayer()
		metalLayer.device = device
		// Set pixel format. 8 bytes for Blue, Green, Red, and Alpha, in that order
		//   with normalized values between 0 and 1
		metalLayer.pixelFormat = .BGRA8Unorm
		metalLayer.framebufferOnly = true
		metalLayer.frame = view.layer.frame
		view.layer.addSublayer(metalLayer)
	}
	
	func createRenderBuffer() {
		objectToDraw = Plane(device: device)
	}
	
	func createRenderPipeline() {
		// Access any of the precompiled shaders included in your project through the MTLLibrary by calling device.newDefaultLibrary(). 
		//   Then look up each shader by name.
		let defaultLibrary = device.newDefaultLibrary()
		let fragmentProgram = defaultLibrary!.newFunctionWithName("basic_fragment")
		let vertexProgram = defaultLibrary!.newFunctionWithName("basic_vertex")
		
		
		//  Set up the render pipeline configuration here. 
		//    This contains the shaders you want to use, and the pixel format for the color attachment
		let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
		pipelineStateDescriptor.vertexFunction = vertexProgram
		pipelineStateDescriptor.fragmentFunction = fragmentProgram
      pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
		
		// Compile the pipeline configuration into a pipeline state that is efficient to use here on out.
		var pipelineError : NSError?
		pipelineState = device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor, error: &pipelineError)
		if pipelineState == nil {
			println("Failed to create pipeline state, error \(pipelineError)")
		}
	}
	
	func createCommandQueue() {
		// A queue of commands for GPU to execute.
		commandQueue = device.newCommandQueue()
	}
	
	func createDisplayLink() {
		// Call gameloop() on every screen refresh.
		timer = CADisplayLink(target: self, selector: Selector("gameloop"))
		timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
	}
	
	func render() {
		var drawable = metalLayer.nextDrawable()
		objectToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable, clearColor: nil)
	}
 
	func gameloop() {
		autoreleasepool {
			self.render()
		}
	}

}

