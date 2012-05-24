$      = jQuery
Spine  = ColorCanvas.Spine
Color  = ColorCanvas.Color
Picker = ColorCanvas.Picker

$.colorcanvas = {}

$.colorcanvas.replaceInputs = ->
  $('input[type=color]').each ->
    (new Input).replace(this)

$ -> $.colorcanvas.replaceInputs()

class Popup extends Spine.Controller
  width: 400

  events:
    mousedown: 'listen'

  constructor: ->
    super
    @el.delegate 'click', '.close', @close
    @el.addClass('popup')
    @el.css(position: 'absolute')

  open: (position = {left: 0, top: 0}) =>
    left = position.left or position.clientX
    top  = position.top  or position.clientY

    left += 25
    top  -= 5

    @el.css(left: left, top: top)
    $('body').append(@el)

    setTimeout =>
      $('body').mousedown(@close)

  close: =>
    $('body').unbind('mousedown', @close)
    @release()
    @trigger 'close'

  isOpen: ->
    !!@el.parent().length

  listen: (e) =>
    e.stopPropagation()

    return if e.target isnt e.currentTarget

    @dragPosition = {left: e.pageX, top: e.pageY}
    $(document).mousemove(@drag)
    $(document).mouseup(@drop)

  drag: (e) =>
    difference =
      left: e.pageX - @dragPosition.left
      top:  e.pageY - @dragPosition.top

    @dragPosition = {left: e.pageX, top: e.pageY}

    offset       = @el.offset()
    offset.left += difference.left
    offset.top  += difference.top

    @el.css(offset)

  drop: (e) =>
    $(document).unbind('mousemove', @drag)
    $(document).unbind('mouseup', @drop)

class PickerPopup extends Popup
  constructor: ->
    super
    @color or= new Color
    @picker = new Picker(color: @color)
    @picker.bind 'change', => @trigger('change', arguments...)
    @append(@picker)

class Input extends Spine.Controller
  className: 'colorCanvasInput'

  events:
    'click': 'open'

  constructor: ->
    super
    @input or= $('<input />')
    @color or= new Color(r: 255, g: 0, b: 0)
    @render()

  render: ->
    @el.css(background: @color.toString())

  replace: (input) ->
    @input = $(input)
    @color.set Color.fromString(@input.val())

    @input.hide()
    @input.after(@el)

  open: ->
    if @picker and @picker.isOpen()
      @picker.close()
      return

    @picker = new PickerPopup(color: @color)

    @picker.bind 'change', (color) =>
      @color.set color
      @trigger 'change', @color

      @input.val(@color.toString())
      @input.change()

      @render()

    @picker.open(@el.offset())

@ColorCanvas.Input = Input
@ColorCanvas.Popup = Popup
@ColorCanvas.PickerPopup = PickerPopup