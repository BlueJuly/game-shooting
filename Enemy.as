package  {
	
	import flash.display.Sprite;
	import flash.events.Event; 
	import flash.display.MovieClip;
	
	public class Enemy extends MovieClip{

		private var state_:int;
		//private var bullet:Bullet;
		
		public function Enemy(stat:int) {
			this.state_ = stat;
			gotoAndStop(stat);
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		private function onAdd(e:Event):void{
			addEventListener(Event.ENTER_FRAME, onEnterframe);
		}

		private function onEnterframe(e:Event):void{
			this.y += state_*3+5;
			if(this.currentFrame == this.totalFrames){
				remove_Enemy();
			}
		}

		public function remove_Enemy():void{
			parent.removeChild(this);
			removeEventListener(Event.ENTER_FRAME, onEnterframe);
		}
		
		public function explosion():void{
			gotoAndPlay(3);
		}

	}
	
}
