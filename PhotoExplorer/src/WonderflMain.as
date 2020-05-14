package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author umhr
	 */
	[SWF(width = 465, height = 465, backgroundColor = 0x000000, frameRate = 60)]
	public class WonderflMain extends Sprite 
	{
		
		public function WonderflMain() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			addChild(new Canvas());
		}
		
	}
	
}


	
	import a24.tween.Ease24;
	import a24.tween.Tween24;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author umhr
	 */
	 class Canvas extends Sprite 
	{
		private var _count:int = 0;
		private var _stage:Sprite = new Sprite();
		private var _rotationStage:Sprite = new Sprite();
		private var dummyList:Array/*Dummy*/ = [];
		public function Canvas() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			_rotationStage.x = stage.stageWidth * 0.5;
			_rotationStage.y = stage.stageHeight * 0.5;
			addChild(_rotationStage);
			_rotationStage.addChild(_stage);
			
			var w:int = stage.stageWidth * 5;
			var h:int = stage.stageHeight * 5;
			
			var n:int = 100;
			for (var i:int = 0; i < n; i++) 
			{
				var dummy:Dummy = new Dummy(i);
				dummy.width = 320;
				dummy.height = 240;
				dummy.x = (i % 10) * 400 + 100 * Math.random()-50;
				dummy.y = Math.floor(i / 10) * 400 + 100 * Math.random()-50;
				dummy.z = 400 * Math.random() - 200;
				dummy.rotationX = 40 * Math.random() - 20;
				dummy.rotationZ = 180 * Math.random() - 90;
				_stage.addChild(dummy);
				dummyList[i] = dummy;
			}
			zSort();
			
			
			
			addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(e:Event):void 
		{
			if (_count%350 == 0) {
				move();
			}
			
			_count ++;
		}
		
		private function move():void {
			
			var shffleList:Array = shuffle(dummyList.length);
			var targetId:int = shffleList[0];// Math.floor(dummyList.length * Math.random());
			var targetDummy:Dummy = dummyList[targetId];
			var nextDummy:Dummy = dummyList[shffleList[1]];
			var tx:Number = -targetDummy.x;
			var ty:Number = -targetDummy.y;
			var tz:Number = -targetDummy.z;
			var rY:Number = 40 * Math.random() - 20;
			var rZ:Number = -targetDummy.rotationZ;
			if (Math.abs(_rotationStage.rotation - rZ) > 180) {
				rZ += 360;
			}
			var parallelList:Array/*Tween24*/ = [];
			
			parallelList[0] = Tween24.tween(_stage, 3.5, Ease24._3_CubicInOut).x( tx);
			parallelList[1] = Tween24.tween(_stage, 3.5, Ease24._3_CubicOut).y( ty);
			parallelList[2] = Tween24.tween(_rotationStage, 3.5, Ease24._5_QuintInOut).rotationZ(rZ);
			parallelList[3] = Tween24.serial(
				Tween24.tween(_rotationStage, 1.5, Ease24._3_CubicIn).z(tz+400),
				Tween24.tween(_rotationStage, 2, Ease24._3_CubicOut).z(tz)
			);
			parallelList[4] = Tween24.tween(targetDummy, 2.5, Ease24._2_QuadInOut).rotationX(0).delay(2);
			
			parallelList[5] = Tween24.serial(
				Tween24.tween(_rotationStage, 2, Ease24._2_QuadIn).rotationY(rY),
				Tween24.tween(_rotationStage, 2.5, Ease24._2_QuadOut).rotationY(0)
			);
			parallelList[6] = Tween24.tween(nextDummy, 3.5, Ease24._2_QuadInOut).rotationX(40 * Math.random() - 20);
			
			Tween24.parallel.apply(this, parallelList).play();
		}
		
		private function shuffle(num:int):Array {
			var _array:Array = new Array();
			for (var i:int = 0; i < num; i++) {	
				_array[i] = Math.random();
			}
			return _array.sort(Array.RETURNINDEXEDARRAY);
		}
		
		private function zSort():void {
			var n:int = _stage.numChildren;
			var array:Array = [];
			var reference:Array = [];
			for (var i:int = 0; i < n; i++) {
				array[i] = _stage.getChildAt(i).z;
				reference[i] = _stage.getChildAt(i);
			}
			var temp:Array = array.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
			for (i = 0; i < n; i++) {
				_stage.setChildIndex(reference[temp[i]],0)
			}
		}
	}
	

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
	class Dummy extends Sprite 
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
			dummyTextField.text = "\n" + "id:" + _id + "\n ";
			//dummyTextField.border = true;
			dummyTextField.width = dummyTextField.textWidth + 8;
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
	
