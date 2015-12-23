package;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.dynamics.ArbiterList;
import nape.callbacks.InteractionType;
import nape.dynamics.Arbiter;
import nape.callbacks.CbEvent;
import nape.callbacks.PreFlag;

/*
  Touch enum
*/
@:enum abstract Touching(Int) from Int to Int{
  var NONE    = 0;
  var TOP     = 1;
  var RIGHT   = 2;
  var BOTTOM  = 4;
  var LEFT    = 8;
  var WALL    = 2 | 8;
  var ANY    = 1 | 2 | 4 | 8;
}

class Player {

  public var body : Body;
  var type : CbType; //local type
  //Hold the int that tells the side that the polygon is colliding
  var touching : Touching;
  var velocity : Float = 120;
  var textField : TextField;

  public function new(x:Float, y:Float){

    type = new CbType();

    body = new Body(BodyType.DYNAMIC);

    textField = new TextField();
    textField.defaultTextFormat = new TextFormat("Verdana", 10, 0xffffff);
    textField.selectable = false;
    textField.width = 240;
    textField.height = 16;

    textField.x = 0;
    textField.y = y - 40;

    textField.autoSize = TextFieldAutoSize.CENTER;

    Main._stage.addChild(textField);

    var core = Polygon.rect(0, 0, 16, 16);

    body.shapes.add( new Polygon( core ) );
    body.cbTypes.add(Main.PlayerType);
    body.cbTypes.add(type);
    body.position.setxy(x, y);
    body.allowRotation = false;

    body.space = Main.space;

    //Set up collision interections callbacks

    Main.space.listeners.add(new InteractionListener(
      CbEvent.ONGOING,
      InteractionType.COLLISION,
      type,
      Main.FloorType,
      onGoing
    ));

    Main.space.listeners.add(new InteractionListener(
      CbEvent.END,
      InteractionType.COLLISION,
      type,
      Main.FloorType,
      end
    ));

    touching = Touching.NONE;

  }

  function checkAbriter(arbiter:Arbiter):Void{

    var colArb = arbiter.collisionArbiter;

    /* Ignore what should not collide */
    if(arbiter.state == PreFlag.IGNORE || arbiter.state == PreFlag.IGNORE_ONCE) return;

    if(colArb.normal.x == -1) touching |= Touching.LEFT;
    if(colArb.normal.x == 1) touching |= Touching.RIGHT;
    if(colArb.normal.y == -1) touching |= Touching.TOP;
    if(colArb.normal.y == 1) touching |= Touching.BOTTOM;

    textField.text =  body.userData.name + ": " + "body1:" + arbiter.body1.userData.name + ", body2:" + arbiter.body2.userData.name;

    #if debug
      trace(body.userData.name + ": " + "body1:" + arbiter.body1.userData.name + ", body2:" + arbiter.body2.userData.name);
    #end
  }

  /*Collision interaction ongoing callback*/
  function onGoing(cb:InteractionCallback){

    cb.arbiters.foreach(checkAbriter);

  }

  /*Collision interaction end callback*/
  function end(cb:InteractionCallback){

    cb.arbiters.foreach(checkAbriter);

  }

  public function isTouching( direction:Touching ){

    return (touching & direction) != Touching.NONE;

  }

  public function move(){

    //goes to the right when touch the left wall
    if( isTouching(Touching.LEFT) ){
      velocity = 120;
    }

    //goes to the left when touch the right wall
    if( isTouching(Touching.RIGHT) ){
      velocity = -120;
    }

    //set velocity
    body.velocity.x = velocity;

    //clean up touching flag to none, to check it again in the next frame
    touching = Touching.NONE;

  }

}