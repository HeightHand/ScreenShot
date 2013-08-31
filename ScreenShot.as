﻿package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.desktop.NativeProcess;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;

	public class ScreenShot extends EventDispatcher
	{
		static public const SHOT_COMPLETE:String = "shot_complete";
		private var _shotComplete:Event;
		private var _file:File;
		private var _nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var _process:NativeProcess;
		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;
		private var byteArray:ByteArray = new ByteArray();

		public function ScreenShot():void
		{
			_file = File.applicationDirectory.resolvePath("ExtendApplication/SnapShot.exe");
			_nativeProcessStartupInfo = new NativeProcessStartupInfo();
			_nativeProcessStartupInfo.executable = _file;
			_process = new NativeProcess();
			_shotComplete = new Event(SHOT_COMPLETE);
		}
		public function shot():void
		{
			_process.start(_nativeProcessStartupInfo);
			_process.addEventListener(NativeProcessExitEvent.EXIT,onExit);
		}

		private function onExit(e:NativeProcessExitEvent):void
		{
			if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT)) {
				_bitmapData = Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
				_bitmap = new Bitmap(_bitmapData);
				byteArray.clear();
				_bitmapData.encode(new Rectangle(0,0,_bitmapData.width,_bitmapData.height), new flash.display.JPEGEncoderOptions(100), byteArray);
				dispatchEvent(_shotComplete);
			}

		}
		public function get bitmapData():BitmapData
		{
			return _bitmapData as BitmapData;
		}
		public function get byte():ByteArray
		{
			return byteArray;
		}
	}
}