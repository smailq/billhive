PaidBillView = require './PaidBillView'

class WeekView extends Backbone.View
  template: require '../templates/Week.html'
  className: 'weekly'
  initialize: ->
    self = this
    @weekData = @options.weekData
    @weekSummary = @options.weekSummary
    @paidBills = @options.paidBills

    @paidBillsView = []

    for billModel in @paidBills
      @paidBillsView.push(new PaidBillView
        model: billModel
      )


  render: ->
    #for model in @collection.models
    #  @$el.append @template model
    @$el.html @template
      weekData: @weekData
      weekSummary: @weekSummary

    for paidBillView in @paidBillsView
      paidBillView.render()
      ($ '.paid-bills-table', @$el).append paidBillView.$el

    ($ '#cal_today', @$el).tooltip({trigger:'manual'})
    
    

module.exports = WeekView