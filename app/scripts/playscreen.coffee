class window.PlayScreen extends GameScreen

  constructor: () ->
    super()

    # dummy rectangle
    myshape = new createjs.Shape()
    myshape.graphics.beginStroke("#F00").beginFill("#00F").drawRect(0, 0, 100, 50)
    myshape.x = 100
    myshape.y = 100
    @container.addChild myshape

    # keys pressed txt
    @keyPressedTxt = new createjs.Text "Press something on the keyboard", "bold 24px Arial"
    @keyPressedTxt.x = 20
    @keyPressedTxt.y = 300
    @container.addChild @keyPressedTxt