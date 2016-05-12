package  {
	
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.display.MovieClip;;
	
	public class Boss extends MovieClip{

		private var state_:int;
		
		public function Boss(stat:int) {
			this.state_ = stat;
			gotoAndStop(stat);
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(e:Event):void{
			addEventListener(Event.ENTER_FRAME, onEnterframe);
		}

		private function onEnterframe(e:Event):void{
			gotoAndStop(state_);
		}
	
		public function remove_Boss():void{
			parent.removeChild(this);
			removeEventListener(Event.ENTER_FRAME, onEnterframe);
		}	

	}
	
}
