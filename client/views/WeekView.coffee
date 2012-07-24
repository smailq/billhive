PaidBillView = require './PaidBillView'
UnPaidBillView = require './UnPaidBillView'

class WeekView extends Backbone.View
  template: require '../templates/Week.html'
  className: 'weekly'
  initialize: ->
    self = this
    @weekData = @options.weekData
    @weekSummary = @options.weekSummary
    @paidBills = @options.paidBills
    @unpaidBills = @options.unpaidBills

    @paidBillsView = []

    for billModel in @paidBills
      @paidBillsView.push new PaidBillView
        model: billModel
      
    @unpaidBillsView = []

    for billModel in @unpaidBills
      @unpaidBillsView.push new UnPaidBillView
        model: billModel
    

  render: ->
    #for model in @collection.models
    #  @$el.append @template model
    @$el.html @template
      weekData: @weekData
      weekSummary: @weekSummary

    for paidBillView in @paidBillsView
      paidBillView.render()
      ($ '.paid-bills-table', @$el).append paidBillView.$el

    for unpaidBillView in @unpaidBillsView
      unpaidBillView.render()
      ($ '.unpaid-bills-table', @$el).append unpaidBillView.$el

    ($ '.cal-day a', @$el).tooltip
      trigger:'manual'
      title: 'Due'
      placement: 'bottom'
      animation: false

module.exports = WeekView