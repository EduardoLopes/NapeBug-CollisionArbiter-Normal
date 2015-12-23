package;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;

import nape.dynamics.Arbiter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.ShapeDebug;
import nape.util.Debug;
import nape.callbacks.CbType;

class Main extends Sprite{

  static public var space : Space;

  var debugDraw : ShapeDebug;

  var floor_1 : Floor;
  var floor_2 : Floor;

  var player_1 : Player;
  var player_2 : Player;

  //global types
  static public var FloorType : CbType;
  static public var PlayerType : CbType;

  static public var _stage;

  public function new(){

  	super();

  	Main._stage = stage;

    space = new Space(Vec2.get(0, 980, true));

    FloorType = new CbType();
		PlayerType = new CbType();

		/*
    	This object invert the direction that it is going when touch a wall, it works
    	because it is being instantiated before the shape that it is colliding with
    */
		player_1 = new Player(120, 200);

		//instantiate floors (Set up body, polygons, position and stuff)
    floor_1 = new Floor(0, 320 - 80);
    floor_2 = new Floor(0, 320 - 160);

    /*
			This object should invert the direction it is going when touch a wall,
			but it keeps going right forever because the normals are inverted.
			To fix this, this object should be instantiated before the shape it is
			colliding with be instantiated, and not after.
		*/
		player_2 = new Player(120, 280);


		//Set body names
		player_1.body.userData.name = 'player_1';
		player_2.body.userData.name = 'player_2';
		floor_1.body.userData.name = 'floor_1';
		floor_2.body.userData.name = 'floor_2';

		//init stuff
    init_debug();
    init_frame();

  }

  function init_debug(){

  	debugDraw = new ShapeDebug(stage.stageWidth, stage.stageHeight, 0x333333);
    debugDraw.thickness = 1;

    addChild(debugDraw.display);

  }

   function init_frame(){

  	addEventListener(Event.ENTER_FRAME, step);

  }

  private function step(evt:Event):Void{

    space.step(1/stage.frameRate);

    //update players movements
    player_1.move();
    player_2.move();

    debugDraw.clear();
    debugDraw.draw(space);
    debugDraw.flush();

  }

}