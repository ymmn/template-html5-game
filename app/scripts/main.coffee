class window.Game


  ############## PRIVATE METHODS #############
  _tick = () ->
    @stage.update()

  _toggleSound = () ->
    @mute = not @mute
    createjs.Sound.setMute @mute
    if @mute
        $("#mute").html "Unmute Sound"
    else
        $("#mute").html "Mute Sound"


  _keyHandler = (e, isPressed, keyPressedTxt) ->
    # prevent scrolling 
    e.preventDefault()
    switch e.keyCode
      when KeyEvent.LEFT then @keyPressedTxt.text = "LEFT"
      when KeyEvent.RIGHT then @keyPressedTxt.text = "RIGHT"
      when KeyEvent.DOWN then @keyPressedTxt.text = "DOWN"
      when KeyEvent.UP then @keyPressedTxt.text = "UP"
      else 
        @keyPressedTxt.text = "Keycode #{e.keyCode} down: #{isPressed}"

  _onDoneLoading = (loadingProgressTxt) ->
    # start the music
    @stage.removeChild loadingProgressTxt
    createjs.Sound.play "music", createjs.Sound.INTERRUPT_NONE, 0, 0, -1, 0.25

    # dummy rectangle
    myshape = new createjs.Shape()
    myshape.graphics.beginStroke("#F00").beginFill("#00F").drawRect(0, 0, 100, 50)
    myshape.x = 100
    myshape.y = 100
    @stage.addChild myshape

    # keys pressed txt
    @keyPressedTxt = new createjs.Text "Press something on the keyboard", "bold 24px Arial"
    @keyPressedTxt.x = 20
    @keyPressedTxt.y = 300
    @stage.addChild @keyPressedTxt

    # handle keyboard key presses
    kh = _keyHandler.bind @
    window.onkeydown = (e) ->
      kh e, false
    window.onkeyup = (e) ->
      kh e, true

  _updateLoading = (loadingProgressTxt, preload) ->
    loadingProgressTxt.text = "Loading " + (preload.progress*100|0) + "%"
    @stage.update()


  ################## PUBLIC METHODS ##################
  init: () ->

    # get a reference to the canvas we'll be working with:
    canvas = document.getElementById "gameCanvas"

    # create a stage object to work with the canvas. This is the top level node in the display list:
    @stage = new createjs.Stage canvas

    # start game timer   
    if not createjs.Ticker.hasEventListener "tick"
      createjs.Ticker.addEventListener "tick", _tick.bind @

    createjs.Ticker.setFPS 60

    # sounds to load
    manifest = [
      id: "music",
      src: "assets/music.mp3"
    ]
    
    # show loading 
    loadingProgressTxt = new createjs.Text "Loading", "bold 24px Arial", "#000"
    loadingProgressTxt.maxWidth = 1000
    loadingProgressTxt.textAlign = "center"
    loadingProgressTxt.x = canvas.width / 2
    loadingProgressTxt.y = canvas.height / 2
    @stage.addChild loadingProgressTxt

    # begin loading content
    preload = new createjs.LoadQueue()
    preload.installPlugin createjs.Sound
    preload.addEventListener "progress", _updateLoading.bind @, loadingProgressTxt, preload
    preload.addEventListener "complete", _onDoneLoading.bind @, loadingProgressTxt
    preload.loadManifest manifest

    # mute button event 
    $("#mute").click _toggleSound
    @mute = false

game = new Game()
game.init()