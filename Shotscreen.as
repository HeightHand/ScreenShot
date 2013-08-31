package 
{

	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	//import flash.display.Bitmap;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.desktop.NativeApplication;

	public class Shotscreen extends Sprite
	{
		private var scrshot:ScreenShot;
		private var date:Date;
		private var time:String;
		private var curfolder:String = "";
		
		public function Shotscreen()
		{
			//stage.scaleMode = "noScale";
			scrshot = new ScreenShot();
			mc.visible = false;
			savefilepath.wordWrap = true;
			bt.addEventListener(MouseEvent.CLICK, clk);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
			scrshot.addEventListener(ScreenShot.SHOT_COMPLETE,onComplete);
			//scrshot.shot();
			//this.stage.nativeWindow.alwaysInFront = true;
			btn1.addEventListener(MouseEvent.CLICK,mouseclick);
			btn2.addEventListener(MouseEvent.CLICK,mouseclick);
			btn3.addEventListener(MouseEvent.CLICK,mouseclick);
		}
		private function onKDown(e:KeyboardEvent):void
		{
			if (e.altKey && e.ctrlKey && e.keyCode == 65) {
				scrshot.shot();
			}
		}

		private function mouseclick(e:MouseEvent):void
		{
			if (e.target.currentFrame == 1) {
				e.target.gotoAndStop(2);
				switch (e.target.name) {
					case "btn1" :
						curfolder = "/test/";
						break;
					case "btn2" :
						curfolder = "/explain/";
						break;
					case "btn3" :
						curfolder = "/knowledge/";
						break;
					default :
						break;
				}
			} else {
				e.target.gotoAndStop(1);
				curfolder = "";
			}
			for (var i:int=1; i<4; i++) {
				if (e.target.name != "btn" + i) {
					(getChildByName(("btn" + i)) as MovieClip).gotoAndStop(1);
				}
			}
		}

		private function clk(e:MouseEvent)
		{
			scrshot.shot();
		}
		
		private function onComplete(e:Event)
		{
			mc.visible = true;
			date = new Date();
			//time = date.fullYear.toString() + (date.month+1).toString() + date.date.toString() + date.hours.toString() + date.minutes.toString() + date.seconds.toString();
			time = String("HH"+date.time);
			var file:File = new File(savefilepath.text + curfolder);
			if (file.exists) {
				file = file.resolvePath(file.nativePath + "/" + time + ".jpg");
				var filestream:FileStream = new FileStream();
				filestream.openAsync(file, FileMode.WRITE);
				filestream.writeBytes(scrshot.byte);
				filestream.close();
				mc.visible = false;
			} else {
				savefilepath.appendText("\n没有该路径！");
			}
		}

	}

}