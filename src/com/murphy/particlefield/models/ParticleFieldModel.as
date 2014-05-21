package com.murphy.particlefield.models
{
	import com.murphy.particlefield.vos.ParticleVO;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ParticleFieldModel extends EventDispatcher
	{				
		//container background properties
		public var fieldWidth:int;
		public var fieldHeight:int;
		public var fieldColor:uint;
		public var fieldDebugInUse:Boolean = false;

		//data about our collection of particles on the screen
		public var collectionIcrementAmount:int;
		public var collectionBitmapData:BitmapData;
		
		public var collectionVOs:Vector.<ParticleVO>;
		public var collectionCurrentCount:int;
		
		public function ParticleFieldModel(width:int, height:int, color:uint, count:int, increment:int, debugMode:Boolean)
		{
			fieldWidth = width;
			fieldHeight = height;
			fieldColor = color;
			fieldDebugInUse = debugMode;			
			collectionIcrementAmount = increment;
			collectionCurrentCount = count;
		}
		
		public function update():void {
			
			// Allowing Controllers to trigger an event dispatch
			// public variables are more performant than getters / setters
			// this should be triggered after a property change occurs that might update the view
			
			this.dispatchEvent(new Event(Event.CHANGE) );
		}
	}
}