﻿package  {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
    import flash.ui.Mouse;
    import fl.motion.easing.Back;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	public class Logic2 extends Sprite{
		
		public var main_stage;
		public var my_fighter;
		private var map_speed;
		private var left_pressed:Boolean;
		private var right_pressed:Boolean;
		private var up_pressed:Boolean;
		private var down_pressed:Boolean;
		private var fire_pressed:Boolean;
		private var bullet_Array:Array;
		private var bullet:Bullet;
		private var bullet_control:Timer;
		private var current_time;
		private var time_array:Array;
		private var bullet_State:int=1;
		private var enemy:Enemy;
		private var enemy_control:Timer;
		private var enemy_Array:Array;
		private var Life:int;
		private var boss_time:Timer;
		private var game_time:Timer;
		private var boss:Boss;
		private var is_up:Boolean;
		private var is_stop:Boolean;
		private var boss_life:int;
		private var boss_speedy:int;
		private var game_state:int;
		public var txt_score:TextField;
		private var txt_format:TextFormat;
		
		var ss:int;
		var k:int=0;

		public function Logic2(stage_:MovieClip) {
			
			main_stage = stage_;
			
			Life = 10;
			boss_speedy = 5;
			boss_life = 50;
			game_state = 0;
	
			my_fighter = new Fighter();
			my_fighter.x = main_stage.stage.stageWidth/2;
			my_fighter.y = main_stage.stage.stageHeight-30;
			main_stage.stage.addChild(my_fighter);
			
			main_stage.stage.addEventListener(Event.ENTER_FRAME,onEnterframe);	

			
			
			map_speed = 5;	
			main_stage.bp2.y=-1800;
			main_stage.bp2.x=0;
			bullet_Array = new Array();
			bullet_control = new Timer(100/3);
			time_array = new Array();
			enemy_Array = new Array();
			
			
			
			boss = new Boss(2);
			
			txt_format = new TextFormat();
			txt_format.size = 30;
			txt_format.color = 0x003399;
			txt_score = new TextField();
			txt_score.defaultTextFormat = txt_format;
			txt_score.x = 130;
			txt_score.y = 10;
			main_stage.stage.addChild(txt_score);
			
			enemy_control = new Timer(500, 50);
			enemy_control.addEventListener(TimerEvent.TIMER,addEnemy);
			enemy_control.start();
			
			boss_time = new Timer(1000,1);
			boss_time.addEventListener(TimerEvent.TIMER, boss_come);
			boss_time.start();
			
			game_time = new Timer(1000);
			game_time.start();
			
			
		}
		
		private function onEnterframe(e:Event):void{
			if(main_stage.main_state == 4){
			txt_score.text = main_stage.score.toString();
			switch(game_state){
				// in game
				case 0:
					bg_move();
			 		fighter_move();
			 		removebullet();
					removeenemy();
					collision();
					if(boss_life >0){
						boss_logic();
					}
					boss_death();
					Mouse.hide();
				
					main_stage.gameover.visible = false;
					main_stage.restart_B.visible = false;
					main_stage.back_B.visible = false;
					main_stage.win.visible = false;
					
					main_stage.stage.addEventListener(MouseEvent.CLICK, onClick);
				
					main_stage.life_Bar.x = 700-(10-Life)*6;
					main_stage.life_Bar.y = 38;
					main_stage.life_Bar.height = 16;
					main_stage.life_Bar.width = Life*12;
					break;
				// gameover
				case 1:
					Mouse.show();
					main_stage.gameover.visible = true;
					main_stage.restart_B.visible = true;
					main_stage.back_B.visible = true;
					main_stage.gameover.x = main_stage.stage.stageWidth/2;
					main_stage.gameover.y = main_stage.stage.stageHeight/2-100;
					main_stage.restart_B. x = 250;
					main_stage.restart_B. y = 460;
					main_stage.back_B.x = 550;
					main_stage.back_B.y = 460;
					break;
				// end game
				case 2:
					Mouse.show();
					main_stage.back_B.visible = true;
					main_stage.gameover.visible=false;
					main_stage.restart_B.visible=false;
					main_stage.win.visible = true;
					
					main_stage.back_B.x = main_stage.stage.stageWidth/2;;
					main_stage.back_B.y = 460;
					main_stage.win.x = main_stage.stage.stageWidth/2;
					main_stage.win.y = main_stage.stage.stageHeight/2-50;
					
					boss_death();
					break;
			}
		}}
		
		private function bg_move(){

		
			main_stage.bp2.y+=map_speed;
			if(main_stage.bp2.y>=main_stage.stage.stageHeight-1200){
				main_stage.bp2.y=-1800;
				}

		}
		
		private function onClick(e:MouseEvent):void{
			if(boss_life > 0){
				bullet_control.start();
			current_time = bullet_control.currentCount;
			time_array.push(current_time);
			if(time_array.length >= 2){
				if(time_array[time_array.length-1]>time_array[time_array.length-2]+2){
					fire_pressed = true;
				}
			}
			if(time_array.length == 1){ 
				fire_pressed = true;
			}
			}
		}
		

		
		private function fighter_move():void{
			if(left_pressed){
				my_fighter.x -= 10;
				my_fighter.gotoAndStop(2);
				if(my_fighter.x <= 30){
					my_fighter.x = 30;
				}
			}
			else if(right_pressed){
				my_fighter.x += 10;
				my_fighter.gotoAndStop(3);
				if(my_fighter.x >= main_stage.stage.stageWidth-30){
					my_fighter.x =  main_stage.stage.stageWidth-30;
				}
			}
			else if(up_pressed){
				my_fighter.y -= 10;
				if(my_fighter.y <= 30){
					my_fighter.y = 30;
				}
			}
			else if(down_pressed){
				my_fighter.y += 10;
				if(my_fighter.y >= main_stage.stage.stageHeight-30){
					my_fighter.y =  main_stage.stage.stageHeight-30;
				}
			}
			else{
				my_fighter.gotoAndStop(1);
			}
			
			if(fire_pressed){
				switch(bullet_State){
					case 1:
						bullet = new Bullet(1,10,270);
						main_stage.stage.addChild(bullet);
						bullet.x = my_fighter.x-45;
						bullet.y = my_fighter.y+130;
						bullet_Array.push(bullet);
						var shootmusic= new shootMusic();
						shootmusic.play();
						fire_pressed = false;
						break;
					
						
				}
				
			}
		}
		
		private function removebullet(){
			for(var i:int=0; i<bullet_Array.length; i++){
				var current_bullet:Bullet = bullet_Array[i];
				if(current_bullet.y <= 10){
					bullet_Array.splice(i,1);
					current_bullet.remove_bullet();
				}
			}
		}
		
		private function removeenemy():void{
			for(var i:int=0; i<enemy_Array.length; i++){
				var current_enemy:Enemy = enemy_Array[i];
				if(current_enemy.y > main_stage.stage.stageHeight){
					enemy_Array.splice(i,1);
					current_enemy.remove_Enemy();
				}
			}
		}
		
		private function addEnemy(e:TimerEvent){
			if(game_state == 0){
				var a:int = Math.random()*730+30;
				enemy = new Enemy(2);
				enemy.x = a;
				enemy.y = -15;
				main_stage.stage.addChild(enemy);
				enemy_Array.push(enemy);
				for(var i:int=0;i<3;i++){
					bullet = new Bullet(2,15,60+i*30);
					main_stage.stage.addChild(bullet);
					bullet.x = enemy.x;
					bullet.y = enemy.y+43;
					bullet_Array.push(bullet);
				}
				
			}
		}
		
		private function collision():void{
			if(game_state == 0){
				if(my_fighter.hitTestObject(boss)){
				game_over();
			}
			for(var i:int=0; i<bullet_Array.length; i++){
				var current_bullet:Bullet = bullet_Array[i];
				//
				if(boss!=null && boss_life>0){
					if(current_bullet.hitTestObject(boss)&&current_bullet.is_mine==1){
						boss_life --;
						bullet_Array.splice(i,1);
						current_bullet.remove_bullet();
					}
				}
				
				//
				for(var j:int=0; j<enemy_Array.length; j++){
					var current_enemy:Enemy = enemy_Array[j];
					if(current_bullet.hitTestObject(current_enemy)&&current_bullet.is_mine==1){
						
						enemy_Array.splice(j,1);
						current_enemy.explosion();
						var boommusic1= new boomMusic();
						boommusic1.play();
						bullet_Array.splice(i,1);
						current_bullet.remove_bullet();
						main_stage.score += 10;
					}
					
					if(my_fighter.hitTestObject(current_enemy)){
						if(Life > 0){
							Life --;
							enemy_Array.splice(j,1);
							current_enemy.explosion();
							var boommusic= new boomMusic();
						    boommusic.play();
						}
						if(Life == 0){
							game_over();
						}
					}
				}
				//
				if(current_bullet.hitTestObject(my_fighter)&&current_bullet.is_mine!=1){
					if(Life > 0){
						Life --;
						bullet_Array.splice(i,1);
						current_bullet.remove_bullet();
					}
					if(Life == 0){
						game_over();
					}
				}
			}
			}
			
		}
		
		private function boss_come(e:TimerEvent):void{
			boss.x = main_stage.stage.stageWidth/2;
			boss.y = -boss.height/2;
			main_stage.stage.addChild(boss);
		}
		
		private function boss_logic():void{
			//
			if(game_time.currentCount > 30 &&game_time.currentCount<35){
				boss.y += 2;
				if(boss.y > boss.height/2){
					boss.y =  boss.height/2;
				}
			}
			//
			if(game_time.currentCount >= 35){
				k++;
				if(k%12==1 && k < 40){
					for(var i:int=0;i<7;i++){
						bullet = new Bullet(2,15,30+i*20);
						main_stage.stage.addChild(bullet);
						bullet.x = boss.x;
						bullet.y = boss.y + 20;
						bullet_Array.push(bullet);
					}
				}
					//
				if(k%12 == 10 && k < 50){
					var my_x:int = my_fighter.x -boss.x;
					var my_y:int = my_fighter.y-(boss.y + 20);
					if(my_y>0 && my_x>0){
						bullet = new Bullet(3,15,(Math.atan(my_y/my_x)*180/Math.PI));
					}
					if(my_y>0 && my_x<0){
						bullet = new Bullet(3,15,180+(Math.atan(my_y/my_x)*180/Math.PI));
					}
					if(my_y<0 && my_x<0){
						bullet = new Bullet(3,15,(Math.atan(my_y/my_x)*180/Math.PI)-180);
					}
					if(my_y<0 && my_x>0){
						bullet = new Bullet(3,15,(Math.atan(my_y/my_x))*180/Math.PI);
					}
					main_stage.stage.addChild(bullet);
					bullet.x = boss.x;
					bullet.y = boss.y + 20;
					bullet_Array.push(bullet);
				}
				if(k>80 && boss_life >0){
					if(is_up){
						boss.y -= boss_speedy;
						boss_speedy += 2;
						if(boss.y <= boss.height/2){
						boss_speedy = 5;
						boss.y = boss.height/2;
						}
					}
					else if(!is_up){
						boss.y += boss_speedy;
						boss_speedy +=2;
					}
					
					if(boss.y >= main_stage.stage.stageHeight-boss.height/2){
						boss_speedy = 5;
						is_up = true;
					}
				if(k> 125){
					k = 0;
					is_up = false;
				}
					

				}
			}
		}
		
		private function boss_death(){
			if(boss_life == 0){
				ss++;
				if(ss == 1){
					main_stage.score += 100;
				}
				if(ss%12 == 1 && ss< 49){
					for(var i:int=0;i<3;i++){
						var bomb:Bomb = new Bomb();
						bomb.x = boss.x +(i-1)*90;
						bomb.y = boss.y +20;
						main_stage.stage.addChild(bomb);
					}
				}
				if(ss == 70){
					game_state = 2;
					my_fighter.remove_Fighter();
					boss.remove_Boss();
					game_time.stop();
					
				}
			}
		}
		
		private function game_over():void{
				game_state = 1;
				remove_all();
				game_time.stop();
				
		}
		
		private function remove_all():void{
			for(var j:int=0; j<enemy_Array.length; j++){
					var current_enemy:Enemy = enemy_Array[j];
					current_enemy.remove_Enemy();
				}
				for(var i:int=0; i<bullet_Array.length; i++){
					var current_bullet:Bullet = bullet_Array[i];
					current_bullet.remove_bullet();
				}
				my_fighter.remove_Fighter();
				boss.remove_Boss();
		}
		
	}
	
}

