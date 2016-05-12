package  {
	
	import flash.display.MovieClip;
	import flash.events.Event; 
	
	public class Bomb extends MovieClip {

		public function Bomb() {
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}

		private function onAdd(e:Event):void{
			
			addEventListener(Event.ENTER_FRAME,onEnterframe);	
		}
		
		private function onEnterframe(e:Event):void{
			if(this.currentFrame == this.totalFrames){
				parent.removeChild(this);
				this.removeEventListener(Event.ENTER_FRAME,onEnterframe);
			}
		}
	}
	
}
