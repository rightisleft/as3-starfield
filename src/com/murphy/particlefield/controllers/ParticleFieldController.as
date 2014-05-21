package com.murphy.particlefield.controllers
{
	import com.murphy.particlefield.models.ParticleFieldModel;
	import com.murphy.particlefield.views.ParticleFieldView;
	import com.murphy.particlefield.vos.ParticleVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ParticleFieldController
	{
		
		protected var _model:ParticleFieldModel;
		
		protected var _view:ParticleFieldView; 
		
		protected var _diagnoisticController:ParticleFieldDiagnosticController;
		
		private var _boundryRight:int;
		private var _boundryBottom:int;
		
		private var _canvas:BitmapData;
		private var _canvasClear:Rectangle;
		private var _canvasContainer:Bitmap;
		
		private var _startAtY:int;
		private var _startAtX:int;
		
		public function ParticleFieldController(view:ParticleFieldView, model:ParticleFieldModel)
		{	
			_model = model;			
			_view = view;	
			init();
		}	
			
		protected function init():void 
		{			
			_model.addEventListener(Event.CHANGE, onModelChange);
			
			_diagnoisticController = new ParticleFieldDiagnosticController(_view, _model);
			
			// This is the object we blit particles to
			_model.collectionBitmapData = new BitmapData(_model.fieldWidth, _model.fieldHeight, false, _model.fieldColor);
			
			//This is used to reset the bitmap data to empty prior to drawing particles for the next frame
			_canvasClear = new Rectangle(0, 0, _model.fieldWidth, _model.fieldHeight);					
			
			// _canvas keeps a local reference of the bitmapdata object to reduce the number of steps requred to access the object via dot notation
			// _view.canvasBitmapContainer is the displayObject for the bitMapData
			
			_view.bmp_canvasContainer.bitmapData = _canvas = _model.collectionBitmapData;
			
			_boundryBottom = _view.bmp_canvasContainer.y + _model.fieldHeight;
			_boundryRight = _view.bmp_canvasContainer.x + _model.fieldWidth;
			
			_startAtX = _model.fieldWidth /2;
			_startAtY = _model.fieldHeight /2;
			
			// Do Big Bang - create and draw all of our original particles
			_model.collectionVOs = new Vector.<ParticleVO>(_model.collectionCurrentCount, true);
			
			for(var index:int; index < _model.collectionVOs.length; index++)  
			{
				_model.collectionVOs[index] = _particleVO = new ParticleVO();
				this.setToCenter();
			}
						
			_model.update();
			
			_view.addEventListener(Event.ENTER_FRAME, doUpdate);
		}
		
		private function onModelChange(e:Event):void 
		{
			var delta:int = _model.collectionVOs.length - _model.collectionCurrentCount;
			
			if(delta) 
			{
				updateParticleCollection();
			}
		}
		
		public function updateParticleCollection():void 
		{
			
			// We get improved performance by using a fixed length vector, but we cant change the length
			// of the previous vector 
	
			var updatedCollection:Vector.<ParticleVO> = new Vector.<ParticleVO>(_model.collectionCurrentCount, true);
		
			var index:int;
			for(index = 0; index < _model.collectionVOs.length; index++)  
			{
				updatedCollection[index] = _model.collectionVOs[index];
			}
			
			index = _model.collectionCurrentCount;
			while(index > _model.collectionVOs.length) 
			{
				index--
				updatedCollection[index] = _particleVO = new ParticleVO();
				this.setToCenter();
			}
			
			_model.collectionVOs = null;
			_model.collectionVOs = updatedCollection;
			_model.collectionCurrentCount = _model.collectionVOs.length;
			_model.update();
		}
		
		private var _targetIndex:int;
		private var _targetDrawVO:ParticleVO;
		private var _targetDrawVectorLength:int;
		private var _targetDrawVector:Vector.<ParticleVO>;		
		
		private var _particlesVector:Vector.<ParticleVO>;
		private var _particlesVectorLength:int;
		private var _particleVO:ParticleVO;
		private var _particleIndex:int = 0;

		public function doUpdate(e:Event):void 
		{
			
			// accessing object via dot notation is expensive is loops over extremely large datasets
			_particlesVector = _model.collectionVOs;  
			_particlesVectorLength = _particlesVector.length;
			
			// loop over all particles and determine next position (setToCenter, or expand Radius)
			
			for(_particleIndex = 0; _particleIndex < _particlesVectorLength; _particleIndex++) {
				
				_particleVO = _particlesVector[_particleIndex];
				
				// Our particle is only a single pixel, we can use a simplified boundry calculation.
				// If the particle where an irregular shape, we would need to use a 
				// more complex calculation to determine when the object was completely out of bounds
				
				if(_particleVO.xLoc > _boundryRight) {
					setToCenter();
				} else if (_particleVO.xLoc <= 0) {
					setToCenter();
				} else if(_particleVO.yLoc > _boundryBottom) {
					setToCenter();
				} else if(_particleVO.yLoc <= 0) {
					setToCenter();
				}
				
				// move particles to their location on the screen by expanding the radius 
				_particleVO.radius += _particleVO.radiusIncrement;
				_particleVO.xLoc = _particleVO.radius * _particleVO.cos + _particleVO.xOffset;
				_particleVO.yLoc = _particleVO.radius * _particleVO.sin + _particleVO.yOffset;					
			}
			
			//start blitting
			_canvas.lock();
			_canvas.fillRect(_canvasClear, 0x00000000);			
			_targetDrawVector = _model.collectionVOs;
			_targetDrawVectorLength = _model.collectionCurrentCount;
			
			// draw all particles to the bitmapData
			for(_targetIndex = 0; _targetIndex < _targetDrawVectorLength; _targetIndex++)
			{				
				_targetDrawVO = _targetDrawVector[_targetIndex]
				
				_canvas.setPixel32(	_targetDrawVO.xLoc,
									_targetDrawVO.yLoc,
									0x30FFFF00);
			}
			
			_canvas.unlock();		
		}
		
		private function setToCenter():void {
			// This function only gets called for new VOs and when an object reaches a boundry
			// Profiling showed that Math.* functions are using less the 1% of the CPU
			
			_particleVO.radius = 0;
			
			// by incrementing the radius we can control the speed of particle movement on an angle
			_particleVO.radiusIncrement = Math.random() * _particleVO.radiusIncrementAmountMaximum + 1;
			
			_particleVO.xOffset = _startAtX;
			_particleVO.yOffset = _startAtY;
			
			//This is where we determine the angle that particle will move move in
			_particleVO.targetRadian = (Math.random()*360) * (Math.PI / 180)
				
			_particleVO.cos = Math.cos(_particleVO.targetRadian);
			_particleVO.sin = Math.sin(_particleVO.targetRadian);
		}
	}
}