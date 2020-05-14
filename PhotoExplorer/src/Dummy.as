package 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author umhr
	 */
	public class Dummy extends Sprite 
	{
		private var _id:int = 0;
		private var _bitmapData:BitmapData = new BitmapData(100,100);
		private var _bitmap:Bitmap;
		public function Dummy(id:int = 0) 
		{
			_id = id;
			init();
		}
		private function init():void 
		{
			setGara();
		}
		private function setGara():void 
		{
			_bitmap = new Bitmap(getBitmapData(),"auto",true);
			addChild(_bitmap);
			_bitmap.x = -_bitmap.width * 0.5;
			_bitmap.y = -_bitmap.height * 0.5;
			
			scaleX = scaleY = 1;
		}
		private function getBitmapData():BitmapData
		{
			
			var w:int = Math.max(100, width);
			var h:int = Math.max(100, height);
			
			var rgb:int = 0xFF0000;
			
			var shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.beginFill(rgb);
			shape.graphics.drawRect(0, 0, w, h);
			shape.graphics.endFill();
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawRect(16, 16, w-32, h-32);
			shape.graphics.endFill();
			
			var dummyTextField:TextField = new TextField();
			dummyTextField.defaultTextFormat = new TextFormat("_sans", 24, rgb,true);
			dummyTextField.text = "id:" + _id;
			//dummyTextField.border = true;
			dummyTextField.width = dummyTextField.textWidth + 4;
			dummyTextField.height = dummyTextField.textHeight + 4;
			//dummyTextField.autoSize = "center";
			
			var matrix:Matrix = new Matrix();
			matrix.tx = (w - dummyTextField.width) * 0.5;
			matrix.ty = (h - dummyTextField.height) * 0.5;
			
			_bitmapData.dispose();
			_bitmapData = new BitmapData(w, h);
			_bitmapData.draw(shape);
			_bitmapData.draw(dummyTextField, matrix);
			
			return _bitmapData;
		}
		
		override public function get height():Number 
		{
			return super.height;
		}
		
		override public function set height(value:Number):void 
		{
			super.height = value;
			setGara();
		}
		override public function get width():Number 
		{
			return super.width;
		}
		
		override public function set width(value:Number):void 
		{
			super.width = value;
			setGara();
		}
		
	}
	
}