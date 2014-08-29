package
{

	import com.murphy.particlefield.controllers.ParticleFieldController;
	import com.murphy.particlefield.models.ParticleFieldModel;
	import com.murphy.particlefield.views.ParticleFieldView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width='640', height="480", frameRate="50")]		
	public class StarField extends Sprite
	{
		private static const WIDTH:int = 640
		private static const HEIGHT:int = 480
		private static const COLOR:uint = 0x00FFFFFF;
		private static const STARTING_STAR_COUNT:int = 234000;
		private static const ADD_STAR_INCREMENT_COUNT:int = 123000;
		private static const SHOW_DEBUG_MODE:Boolean = true;
		
		private var _starsFieldController:ParticleFieldController;
		private var _starFieldModel:ParticleFieldModel;
		private var _starFieldView:ParticleFieldView;
				
		public function StarField()
		{			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_starFieldModel 		= new ParticleFieldModel(WIDTH, HEIGHT, COLOR, STARTING_STAR_COUNT, ADD_STAR_INCREMENT_COUNT, SHOW_DEBUG_MODE);
			_starFieldView 			= new ParticleFieldView(this, _starFieldModel);
			_starsFieldController 	= new ParticleFieldController(_starFieldView, _starFieldModel);
		}
	}
}