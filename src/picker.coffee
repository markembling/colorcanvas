Spine    = ColorCanvas.Spine
Color    = ColorCanvas.Color
Gradient = ColorCanvas.Gradient
Spectrum = ColorCanvas.Spectrum
Alpha    = ColorCanvas.Alpha
Display  = ColorCanvas.Display

class ColorCanvas.Picker extends Spine.Controller
  className: 'colorCanvas'

  events:
    'click [data-type=cancel]': 'cancel'

  constructor: ->
    super
    @color or= new Color(r: 255, g: 0, b: 0)
    unless @color instanceof Color
      @color = new Color(@color)
    @original = @color.clone()
    @render()

  render: ->
    @el.empty()

    @gradient = new Gradient(color: @color)
    @spectrum = new Spectrum(color: @color)
    @alpha    = new Alpha(color: @color)
    @display  = new Display(color: @color, original: @original)

    @gradient.bind 'change', (color) =>
      @color.set(color.toRGB())
      @display.setColor(@color)
      @alpha.setColor(@color)

      @change()

    @spectrum.bind 'change', (pure_color) =>
      # pure_color contains the max-hued version, no grayscaleness
      # Only change Hue of 'main' color (@color)
      hsv   = @color.toHSV()
      hsv.h = pure_color.toHSV().h
      color = new Color(hsv)
      @color.set(color.toRGB())

      @gradient.setColor(@color, pure_color) # pass the pure version too
      @display.setColor(@color)
      @alpha.setColor(@color)

      @change()

    @alpha.bind 'change', (color) =>
      @color.set(a: color.a)
      @display.setColor(@color)
      @change()

    @display.bind 'change', (color) =>
      @color.set(color.toRGBA())

      @gradient.setColor(@color)
      @spectrum.setColor(@color)
      @alpha.setColor(@color)
      @change()

    @append(@gradient, @spectrum, @alpha, @display)

  # Private

  cancel: (e) ->
    e.preventDefault()
    @change(@original)

  change: (color = @color) ->
    @trigger 'change', color

  release: ->
    super

    @gradient.release()
    @spectrum.release()
    @display.release()