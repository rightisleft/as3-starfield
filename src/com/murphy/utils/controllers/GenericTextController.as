package com.murphy.utils.controllers
{

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class GenericTextController
	{
		// This code would never make it production!
		
		private var _textFormat:TextFormat = new TextFormat("Arial", 10, 0x032585);
		private var _view:DisplayObjectContainer;
		
		public function GenericTextController()
		{
		}
		
		private var _textField:TextField;
		public function setText(txt:String, textField:TextField):void {
			_textField = textField;
			_textField.defaultTextFormat = _textFormat;
			_textField.setTextFormat( _textFormat );			
			_textField.backgroundColor = 0xFFFFFF;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.background = true;
			_textField.multiline = false;
			_textField.selectable = false;
			_textField.text = txt;
		}
	}
}