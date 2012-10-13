import 'dart:html' as html;
import 'dart:math';
import 'dart:isolate';
import 'package:dartflash/dartflash.dart';

part 'source/ImageControl.dart';
part 'source/Game.dart';
part 'source/HanguleAlpabet.dart';


Stage stage;
Stage stageBackground;
Stage stageForeground;
RenderLoop renderLoop;
Juggler renderJuggler;
//-------------------------------------------

Bitmap _adBitmap;
Bitmap loadingBitmap;
Tween loadingBitmapTween;
TextField loadingTextField;

//-------------------------------------------
int frameTimesIndex = 0;
List frameTimes = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
List _adlists = [null,null,null,null,null,null,null];

// 한글 모음자음 위치
List _xpos = [0, 18,91,162,233,308,382,452,532,599,683,768,843,914,24,116,181,245,317,382,495,592,699,804,905];
List _ypos = [0, 620,620,620,620,620,620,620,620,620,620,620,620,620,678,678,678,678,678,693,693,699,699,710,678];

//-------------------------------------------
Timer _timer;
int _timerIndex;


void main()
{
  stageBackground = new Stage("StageBackground", html.query('#stageBackground'));
  stageForeground = new Stage("StageForeground", html.query('#stageForeground'));

  renderLoop = new RenderLoop();
  renderLoop.addStage(stageBackground);
  renderLoop.addStage(stageForeground);

  renderJuggler = renderLoop.juggler;
  
  _timerIndex = 0;
  
  //-------------------------------------------
  Future<BitmapData> loading = BitmapData.loadImage("images/Loading.png");

  loading.then((bitmapData)
  {
    loadingBitmap = new Bitmap(bitmapData);
    loadingBitmap.pivotX = 20;
    loadingBitmap.pivotY = 20;
    loadingBitmap.x = 620;
    loadingBitmap.y = 356;
    stageForeground.addChild(loadingBitmap);

    loadingBitmapTween = new Tween(loadingBitmap, 100, Transitions.linear);
    loadingBitmapTween.animate("rotation", 100.0 * 2.0 * PI);
    renderJuggler.add(loadingBitmapTween);

    loadingTextField = new TextField();
    loadingTextField.defaultTextFormat = new TextFormat("Arial", 20, 0xA0A0A0, bold:true);;
    loadingTextField.width = 240;
    loadingTextField.height = 40;
    loadingTextField.text = "... loading ...";
    loadingTextField.x = 620 - loadingTextField.textWidth / 2;
    loadingTextField.y = 370;
    loadingTextField.mouseEnabled = false;
    stageForeground.addChild(loadingTextField);
   
    loadGame();
  });
}

//
void loadGame()
{
  Resource resource = new Resource();

  resource.addImage("Background", "images/Background.png");
  resource.addImage("Tree", "images/Tree.png");
  resource.addImage("BlackboardEraserNormal", "images/BlackboardEraserNormal.png");
  resource.addImage("BlackboardEraserPress", "images/BlackboardEraserPress.png");
  resource.addImage("MagematicNormal", "images/MagematicNormal.png");// 자석
 
  int i = 1;
  for(i;i<8;i++) {
    resource.addImage("Ad$i", "images/Ad$i.png");
  }
  
  //
  for(i=1;i<25;i++) {
    resource.addImage("Han$i", "images/Han$i.png");
  }
  
  resource.load().then((res)
  {
    stageForeground.removeChild(loadingBitmap);
    stageForeground.removeChild(loadingTextField);
    renderJuggler.remove(loadingBitmapTween);
    
    ImageControl.resource = resource;
    
    //------------------------------
    Bitmap backgroundBitmap = new Bitmap(ImageControl.resource.getBitmapData("Background"));
    stageBackground.addChild(backgroundBitmap);
    stageBackground.renderMode = StageRenderMode.ONCE;
    
    //------------------------------
    Game game = new Game();
    stageForeground.addChild(game);
    game.start();
    
    //------------------------------
    stageBackground.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    
    //------------------------------
    _timer = new Timer.repeating (1000, onTimerEventHandler);
    
    //--
    int i;
    
    for(i=1;i<8;i++) {
      _adlists[i-1] = new Bitmap(ImageControl.resource.getBitmapData("Ad$i"));
      stageForeground.addChild(_adlists[i-1]);
      if(i != 1) {
          _adlists[i-1].visible = false;
      }
    }
    
    //
    for(i=1;i<25;i++) {
      Bitmap img = new Bitmap(ImageControl.resource.getBitmapData("Han$i"));
      img.x = _xpos[i];
      img.y = _ypos[i]-200;
      stageForeground.addChild(img);
      
      loadingBitmapTween = new Tween(img, 0.05*i, Transitions.linear);
      loadingBitmapTween.animate("y", _ypos[i]);
      loadingBitmapTween.onComplete = () {
        // renderJuggler.remove(loadingBitmapTween);
      };
      
      renderJuggler.add(loadingBitmapTween);
    }
    
  });
}

// 프레임 확인
void onEnterFrame(EnterFrameEvent e)
{
  num frameTimeSum = 0;
  frameTimesIndex = (frameTimesIndex + 1) % frameTimes.length;
  frameTimes[frameTimesIndex] = e.passedTime;
  frameTimes.forEach((t) => frameTimeSum += t);

  html.query('#fpsMeter').innerHTML = 'fps: ${(frameTimes.length / frameTimeSum).round()}';
}

// 광고롤링
void onTimerEventHandler(Timer t)
{
  // renderJuggler.delayCall(() => redrawView(), 1);
  
  _adlists[_timerIndex].visible = false;
  
  if(_timerIndex < 5) {
    _timerIndex++;
    _adlists[_timerIndex].visible = true;
  }else {
    _timerIndex = 0;
    _adlists[_timerIndex].visible = true;
  }
}



