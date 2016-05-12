package  {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class Bullet extends MovieClip{
		
		private var speed_x:int;
		private var speed_y:int;
		public var is_mine:int;
		private var speed:int;
		private var directions:int;
		//private static const STATE_1 = 0;
//		private static const STATE_2 = 1;

		public function Bullet(is_mines:int, speed_:int, dir:int) {
			this.is_mine = is_mines;
			speed = speed_;
			directions = dir;
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
			//gotoAndStop(is_mines);
		}
		
		private function onAdd(e:Event):void{
			addEventListener(Event.ENTER_FRAME, onEnterframe);
			//if(is_mine == 0){
//				gotoAndStop(is_mine);
//			}else{
//				gotoAndStop(2);
//			}
			gotoAndStop(is_mine);
		}
		
		private function onEnterframe(e:Event):void{
			//switch(state_){
//				case 0:
//					this.y -= speed_y;
//				    break;
//				case 1:
//					this.x -= speed_x;
//					this.y -= speed_y-5;
//					break;
//				case 2:
//					this.x += speed_x;
//					this.y -= speed_y-5;
//					break;
//				case 3:
//					this.y += speed_y;
//					break;
//				case 4:
//					this.x -= speed_x;
//					this.y += speed_y-5;
//					break;
//				case 5:
//					this.x += speed_x;
//					this.y += speed_y-5;
//					break;
//			}
			this.x += speed*Math.cos(Math.PI/180*directions);
			this.y += speed*Math.sin(Math.PI/180*directions);
		}
		
		public function remove_bullet():void{
			parent.removeChild(this);
			removeEventListener(Event.ENTER_FRAME, onEnterframe);
		}

	}
	
}
