package;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

class Floor {

  public var body : Body;
  var width : Float = 240;
  var height : Float = 80;
  var x : Float;
  var y : Float;
  public var center_x : Float;
  public var center_y : Float;

  public function new(_x:Float, _y:Float){

    body = new Body(BodyType.STATIC);

    x = _x;
    y = _y;

    center_x = x + (width / 2);
    center_y = y + (height / 2);

    var left_wall = Polygon.rect(0, 0, 16, height);
    var ground = Polygon.rect(0, height - 16, width, 16);
    var right_wall = Polygon.rect(width - 16, 0, 16, height);

    body.shapes.add( new Polygon( left_wall ) );
    body.shapes.add( new Polygon( ground ) );
    body.shapes.add( new Polygon( right_wall ) );
    body.cbTypes.add(Main.FloorType);
    body.position.setxy(x, y);

    body.space = Main.space;

  }

}