package com.murphy.particlefield.views
{
	import com.murphy.particlefield.models.ParticleFieldModel;
	import com.murphy.particlefield.controllers.ParticleFieldDiagnosticController;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class ParticleFieldView extends Sprite
	{		
		public var bmp_canvasContainer:Bitmap;
		public var mc_diagnostics:MovieClip;
		public var tf_particleCount:TextField;
		public var tf_addParticles:TextField;
		
		protected var _parent:DisplayObjectContainer;
		
		protected var _model:ParticleFieldModel;
		
		public function ParticleFieldView(parentDisplayObject:DisplayObjectContainer, model:ParticleFieldModel)
		{
			_parent = parentDisplayObject;	
			_model = model;
			
			init();
		}
		
		protected function init():void {
			_parent.addChild( this );
			
			bmp_canvasContainer = new Bitmap();

			this.addChild(bmp_canvasContainer);
			
			tf_particleCount = new TextField();
			tf_addParticles = new TextField();
					
			mc_diagnostics = new MovieClip();
			
			this.addChild(tf_particleCount);
			this.addChild(tf_addParticles);
			this.addChild(mc_diagnostics);
			
			_parent.addChild(this);			
		}
	}
}