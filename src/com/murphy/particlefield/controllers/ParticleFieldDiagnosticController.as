package com.murphy.particlefield.controllers
{
	import com.murphy.particlefield.models.ParticleFieldModel;
	import com.murphy.particlefield.views.ParticleFieldView;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import com.murphy.utils.controllers.GenericTextController;
	
	public class ParticleFieldDiagnosticController extends EventDispatcher
	{
		
		private static const INTERVAL:int = 1000;

		private var _label:TextField;
		private var _labelFromat:TextFormat;
		
		private var _timer:Timer;
		private var _memory:String;
		
		private var _view:ParticleFieldView;
		private var _model:ParticleFieldModel;
		
		private var _textController:GenericTextController = new GenericTextController();

		public function ParticleFieldDiagnosticController(view:ParticleFieldView, model:ParticleFieldModel)
		{
			_view = view;
			_model = model;
			
			init();
		}
		
		protected function init():void {
									
			_model.addEventListener(Event.CHANGE, onModelChange);
			
			_timeOnStart = getTimer();
			_timer = new Timer(750, 0);
			_timer.start();
			
			doDiagnosticSetup();

			doUpdateTextBoxes();

			doEnable();
		}
		
		private function doDiagnosticSetup():void {
			
			if(_label == null) {
				_label = new TextField();
				_view.mc_diagnostics.addChild( _label );
			}
			
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.multiline = true;
			_labelFromat = new TextFormat("Arial", 10, 0x032585);
			
			_view.mc_diagnostics.graphics.clear();
			_view.mc_diagnostics.graphics.beginFill(0xFFFFFF);
			_view.mc_diagnostics.graphics.drawRect(0, 0, 100, 40);
			_view.mc_diagnostics.graphics.endFill();
			_view.mc_diagnostics.x = _view.mc_diagnostics.y = 10;	
		}
		
		private function onAddParticleClick(e:Event):void {
			_model.collectionCurrentCount += _model.collectionIcrementAmount;
			_model.update();
		}
		
		private function onEnterFrame(e:Event):void {
			_frameCountNow++
		}
		
		private function onModelChange(e:Event = null):void 
		{
			doUpdateTextBoxes();
		}
		
		private function doUpdateTextBoxes():void {
			_view.tf_particleCount.visible = _view.tf_addParticles.visible = _model.fieldDebugInUse;
			
			if(!_model.fieldDebugInUse || !_model.collectionVOs) 
			{
				this.doDisable();
				return;
			}
			
			this.doEnable();			
			
			_textController.setText("Add " + _model.collectionIcrementAmount + " Particles", _view.tf_addParticles as TextField);
			_textController.setText("Star Count: " + _model.collectionVOs.length, _view.tf_particleCount);				
			
			_view.tf_particleCount.x = _view.bmp_canvasContainer.bitmapData.width - 10 - _view.tf_particleCount.textWidth;
			_view.tf_particleCount.y = 10;
			
			_view.tf_addParticles.x = _view.tf_particleCount.x;
			_view.tf_addParticles.y = _view.tf_particleCount.y + _view.tf_addParticles.textHeight + 10;
		}
		
		private var _frameCountThen:Number = 0 
		private var _frameCountNow:Number = 0
		private var _framesInASecond:Number = 0;
		
		private var _timeThen:Number = 0;
		private var _timeNow:Number;
		private var _timeSinceLastFrame:Number = 0;
		private var _timeOnStart:Number;
		private var _timeElapsedAsWhole:Number;
		private var _timeElapsedAsWholeInSeconds:Number;
				
		private function onTick(e:TimerEvent):void {
			_timeNow = getTimer();
			
			_timeSinceLastFrame = _timeNow - _timeThen;
			
			// Only update if we have enough information for an entire interval
			// We cant assume its capable of rendering more frames at the same rate
			
			if(_timeSinceLastFrame > INTERVAL) {
				
				_timeElapsedAsWhole = _timeNow - _timeOnStart;			
			
				_timeThen = _timeNow;
				
				_timeElapsedAsWholeInSeconds = Math.floor(_timeElapsedAsWhole / INTERVAL)
				
				// Grab framecount executed since last tick
				// This could have occured over 1100 ms instead of 1000ms interval
				// Resolve how many of those executed in an actual interval 
				
				_framesInASecond = (_frameCountNow - _frameCountThen) * INTERVAL / _timeSinceLastFrame;
				
				_frameCountThen = _frameCountNow;
				
				_memory = Number( System.totalMemory / 1024 / 1024 ).toFixed( 2 ) + ' Mb';
				
				_label.text = "Seconds: " + _timeElapsedAsWholeInSeconds 
					+ "\nFPS: " + Math.floor(_framesInASecond)
					+ "\nMemory: " + _memory;
				
				_label.setTextFormat( _labelFromat );		
			}
		}
		
		protected function doDisable():void {
			
			if( _timer.hasEventListener(TimerEvent.TIMER) )
			{
				_timer.removeEventListener(TimerEvent.TIMER, onTick);	
			}
			
			if( _view.mc_diagnostics.hasEventListener(Event.ENTER_FRAME) ) 
			{
				_view.mc_diagnostics.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			}

			if(	_view.tf_addParticles.hasEventListener(MouseEvent.CLICK) ) 
			{
				_view.tf_addParticles.removeEventListener(MouseEvent.CLICK, onAddParticleClick);
			}
			
			_view.mc_diagnostics.visible = false;
		}
		
		protected function doEnable():void {
			
			if( _timer.hasEventListener(TimerEvent.TIMER) == false )	
			{
				_timer.addEventListener(TimerEvent.TIMER, onTick);	
			}
			
			if( _view.mc_diagnostics.hasEventListener(Event.ENTER_FRAME) == false) 
			{
				_view.mc_diagnostics.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true)
			}
			
			if(	_view.tf_addParticles.hasEventListener(MouseEvent.CLICK) == false )
			{
				_view.tf_addParticles.addEventListener(MouseEvent.CLICK, onAddParticleClick, false, 0, true);	
			}

			_view.mc_diagnostics.visible = true;
		}
	}
}