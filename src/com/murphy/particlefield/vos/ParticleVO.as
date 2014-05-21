package com.murphy.particlefield.vos
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ParticleVO
	{
		
		public var radius:uint;
		public var radiusIncrement:int;
		public var radiusIncrementAmountMaximum:int = 10;
		
		public var xOffset:int;
		public var yOffset:int;
		
		public var targetDegree:Number;
		public var targetRadian:Number;
		
		public var xLoc:int;
		public var yLoc:int;
		
		public var cos:Number;
		public var sin:Number; 
		
		public function ParticleVO()
		{
			super();
		}
	}
}