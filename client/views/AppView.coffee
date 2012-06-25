HomeView = require './pages/HomeView'

class AppView extends Backbone.View
  template: require '../templates/App.html'
  initialize: ->
    self = this
    @$el = $ '#wrapper'
    @bills = @options.bills
    @page =
      home: new HomeView
        collection: @bills
  render: ->
    @$el.html @template {}

    @$pages = @$el.find '.pages'

    for page in ['home']
      @page[page].render()
      @$pages.append @page[page].$el

    @$el.find('.nav a').click (e) ->
      $(this).tab 'show'

  show: (page) ->
    @$el.find('.page').hide()
    @page[page].$el.show()

    $('#cal_today', @$el).tooltip('show')

module.exports = AppView