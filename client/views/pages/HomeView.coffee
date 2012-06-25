WeekView = require '../WeekView'

class HomeView extends Backbone.View
  template: require '../../templates/Home.html'
  initialize: ->
    self = this

    @today = moment()
    @weekData = {}
    @weekSummary = {}

    # create next 4 weeks
    for week_i in [0..4]
      days = []
      for day_i in [0..6]
        
        days.push
          date_sod: moment().add('weeks', week_i).day(day_i).sod()
          bills: []

      @weekData[days[0]['date_sod'].format('w')] = days

      @weekSummary[days[0]['date_sod'].format('w')] =
        bills: []
        total_amount: 0
        total_paid: 0

    @total_amount = 0

    # go through each bill, put it into right place
    for model in @collection.models
      due_date = model.get('due_date')

      if not @weekData[due_date.format('w')]?
        continue

      paid_amount = 0
      for paid in model.get('paid')
        paid_amount += paid['amount']

      

      # TODO - validate first
      @weekData[due_date.format('w')][due_date.day()]['bills'].push model

      @weekSummary[due_date.format('w')]['bills'].push model
      if paid_amount <= 0
        @weekSummary[due_date.format('w')]['total_amount'] += model.get('amount')
        @total_amount += model.get('amount')



      @weekSummary[due_date.format('w')]['total_paid'] += paid_amount


    @last_bill = @collection.models[@collection.models.length - 1]

    @weekly = []

    for weekNumber, oneWeekData of @weekData
      @weekly.push new WeekView
        weekData: oneWeekData
        weekSummary: @weekSummary[weekNumber]
        paidBills: _.filter(@weekSummary[weekNumber].bills, (x) -> return x.get('paid').length > 0)
      

  render: ->
    @$el.html @template { total_amount: @total_amount, today_date: @today, last_bill: @last_bill }

    @$weeklySection = @$el.find '#weekly'

    for weekly_view in @weekly
      weekly_view.render()
      @$weeklySection.append weekly_view.$el

module.exports = HomeView