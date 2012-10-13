// import 'packages/dartflash/dartflash.dart';

class Game extends Sprite
{
  SimpleButton _blackboardEraserButton;
  SimpleButton _eraserButton;
  SimpleButton _magematicButton;
  Bitmap _tree1;
  Bitmap _tree2;
  
  SimpleButton _exitButton;

  Sprite _gameLayer;
  //---------------------------------------------------------------------------------------------------
  int _num;
  //-------------------------------------------
  Timer _gameTimer;
  
  
  Game()
  {
    Bitmap blackboardEraserButtonNormal = new Bitmap(ImageControl.resource.getBitmapData("BlackboardEraserNormal"));
    Bitmap blackboardEraserButtonPressed = new Bitmap(ImageControl.resource.getBitmapData("BlackboardEraserPress"));

    _blackboardEraserButton = new SimpleButton(blackboardEraserButtonNormal, blackboardEraserButtonNormal, blackboardEraserButtonPressed, blackboardEraserButtonPressed);
    _blackboardEraserButton.addEventListener(MouseEvent.CLICK, _onBlackboardEraserButtonClick);
    _blackboardEraserButton.x = 850;
    _blackboardEraserButton.y = 100;
    addChild(_blackboardEraserButton);
    
    Bitmap _tree1 = new Bitmap(ImageControl.resource.getBitmapData("Tree"));
    _tree1.x = 0;
    _tree1.y = 530;
    addChild(_tree1);
    
    Bitmap _tree2 = new Bitmap(ImageControl.resource.getBitmapData("Tree"));
    _tree2.x = 850;
    _tree2.y = 530;
    addChild(_tree2);
    
    Bitmap magematicButtonNormal = new Bitmap(ImageControl.resource.getBitmapData("MagematicNormal"));
    //  Bitmap blackboardEraserButtonPressed = new Bitmap(ImageControl.resource.getBitmapData("BlackboardEraserPress"));

    _magematicButton = new SimpleButton(magematicButtonNormal, magematicButtonNormal, magematicButtonNormal, magematicButtonNormal);
    _magematicButton.addEventListener(MouseEvent.MOUSE_DOWN, _onMagenaticButtonDown, false);
    
    
    _magematicButton.x = 860;
    _magematicButton.y = 230;
    addChild(_magematicButton);
    
    //-------------------------------
    _gameLayer = new Sprite();
   // addChild(_gameLayer);
  }

  //---------------------------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------------------------

  void start()
  {
      _num = 1;
      _gameTimer = new Timer.repeating (1000, onGameTimerEventHandler);
      
      // renderJuggler.delayCall(() => _displayAdvertizement(), 1);
  }

  //---------------------------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------------------------

  void _onTimeShort(Event e)
  {
    //_logger.info("onTimeShort");
  }

  //---------------------------------------------------------------------------------------------------

  void _onTimeOver(Event e)
  {
  }

  //---------------------------------------------------------------------------------------------------

  void _onBlackboardEraserButtonClick(MouseEvent me)
  {
  }
  
  void _onMagenaticButtonDown(MouseEvent e)
  {
        if(e.type == MouseEvent.MOUSE_DOWN) {
          _magematicButton.addEventListener(MouseEvent.MOUSE_MOVE, _onMagenaticButtonMove, false);
          _magematicButton.addEventListener(MouseEvent.MOUSE_UP, _onMagenaticButtonUP, false);
        }
  }
  
  void _onMagenaticButtonMove(MouseEvent e)
  {
       if(e.type == MouseEvent.MOUSE_MOVE) {
          _magematicButton.x = e.stageX - 80;
          _magematicButton.y = e.stageY - 60;
       }
  }
  
  void _onMagenaticButtonUP(MouseEvent e)
  {
      _magematicButton.removeEventListener(MouseEvent.MOUSE_MOVE, _onMagenaticButtonMove, false);
      _magematicButton.removeEventListener(MouseEvent.MOUSE_UP, _onMagenaticButtonMove, false);
  }
  

  void _onExitButtonClick(MouseEvent me)
  {
  }

  //---------------------------------------------------------------------------------------------------
  void _displayAdvertizement()
  {
      print(">>");
  }
  
  
  bool _exitCalled = false;

  void _exitGame(bool gameEnded)
  {

  }
  
  //
  void onGameTimerEventHandler(Timer t)
  {

  }

}