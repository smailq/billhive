class WeekView extends Backbone.View
  template: require '../templates/Week.html'
  className: 'weekly'
  initialize: ->
    self = this
    @weekData = @options.weekData
    @weekSummary = @options.weekSummary

  render: ->
    #for model in @collection.models
    #  @$el.append @template model
    @$el.html @template
      weekData: @weekData
      weekSummary: @weekSummary



module.exports = WeekView