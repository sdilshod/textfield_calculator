class TextFieldCalculator
  config:
    ui:
      openLinkSelector: '[role=open-calculator]'

  constructor: ()->
    @bindings()

  bindings: =>
    $(@config.ui.openLinkSelector).on 'click', (e) =>
      e.preventDefault()
      new TextFieldCalculatorView($(e.currentTarget).offset())

class TextFieldCalculatorView
  config:
    ui:
      inputfieldSelector: '[role=calculator-input-field]'
      calculatorContainerSelector: '[role=calculator-container]'
      sourceTextfieldSelector: '[role=calculator-source-field]'
      calculatorOkButtonSelector: '[role=calculator-ok-button]'
      calculatorInputHistory: '[role=calculator-input-history]'
      calculatorCloseButton: '[role=calculator-close-button]'

  constructor: (containerOffSets) ->
    @$body = $('body')
    @$containerOffSets = containerOffSets
    @render()
    @initVariables()
    @bindings()

  render: () =>
    @$body.append @form()
    $(@config.ui.calculatorContainerSelector).css
      top: @$containerOffSets.top + 20,
      left: @$containerOffSets.left
    @$inputField = $(@config.ui.inputfieldSelector)
    @$inputField.focus()

  initVariables: =>
    @$arifmeticOperationCodes = [13, 43, 45, 42, 47]
    @$arifmeticKeyPressed = false
    @$countOfPressedArifmeticKeys = 0
    @$currentOperation = ''
    @$result = 0
    @$history = ''
    @$historyInput = $(@config.ui.calculatorInputHistory)
    @$closeButton = $(@config.ui.calculatorCloseButton)
    @$enterKeyPressed = false


  bindings: () =>
    @$inputField.on 'keypress', (e) => @calculate(e)
    $(@config.ui.calculatorOkButtonSelector).on 'click', (e) => @close()
    @$closeButton.on 'click', (e) => @close(false)

  calculate: (event) =>
    if $.inArray(event.which, @$arifmeticOperationCodes) >= 0
      event.preventDefault()
      # If we pressed ENTER last time and attempt to press again, nothing happens
      if @$enterKeyPressed && event.which == 13
        return false
      @$arifmeticKeyPressed = true
      @$countOfPressedArifmeticKeys += 1

      #On each pressing +-*/ will run this method, so prevent running rest code
      if @$countOfPressedArifmeticKeys > 1 && event.which != 13
        @$currentOperation = @getAriphmetic(event.which)
        @updateHistory()
        return false
      if @$result == 0
        @$result = @$inputField.val()
      else
        evalString = "this.$result = #{@$result} #{@$currentOperation} #{@$inputField.val()}"
        eval(evalString) unless @$inputField.val() == ''
      @$currentOperation = @getAriphmetic(event.which) unless event.which == 13
      @updateHistory()
      @$inputField.val(@$result)
      @scrollingHistory() # scrolling historing to right
      @$enterKeyPressed = true if event.which == 13
    else
      @$enterKeyPressed = false
      if @$arifmeticKeyPressed && !@$enterKeyPressed
         event.preventDefault()
         @$arifmeticKeyPressed = false
         @$countOfPressedArifmeticKeys = 0
         @$inputField.val(String.fromCharCode(event.which))

  updateHistory: =>
    if @$arifmeticKeyPressed && @$countOfPressedArifmeticKeys > 1
      @$history = "#{@$history.substring(0, @$history.length-1)}#{@$currentOperation}"
    else
      @$history = "#{@$history} #{@$inputField.val()} #{@$currentOperation}"
    @$historyInput.html @$history

  scrollingHistory: =>
    @$historyInput.scrollLeft( @$history.length + 1000 )

  form: ->
    """
      <div class='calculator-container' role=calculator-container>
        <div class='calculator-header'><span><a href='#' role=calculator-close-button>x</a></span></div>
        <div class='calculator-input-history' role=calculator-input-history ></div>
        <p>
          <input type='text' role=calculator-input-field />
          <a href='#' role=calculator-ok-button > ОК </a>
        </p>
      </div>
    """

  getAriphmetic: (keyCode) =>
    switch keyCode
      when 43 then "+"
      when 45 then "-"
      when 42 then "*"
      when 47 then "/"

  close: (withFillingResult = true) =>
    if withFillingResult
      $(@config.ui.sourceTextfieldSelector).val @$result
      $(@config.ui.sourceTextfieldSelector).focus()
    $(@config.ui.calculatorContainerSelector).remove()

$(document).ready ->
  new TextFieldCalculator()
