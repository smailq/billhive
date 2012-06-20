AppView = require './views/AppView'
BillCollection = require './collections/BillCollection'
BillModel = require './models/BillModel'


class AppRouter extends Backbone.Router
  initialize: ->
    bills = new BillCollection
    # Make random bills
    companies = [ 'Rogers', 'Bell', 'Enbridge', 'Power Stream', 'Property Tax', 'TD Visa', 'CIBC Visa', 'GitHub', 'DNSimple', 'Scotia Visa', 'Homedepot', 'Sears Visa' ]
    for i in companies

      if (Math.floor Math.random() * 10) < 5
        bills.add bill = new BillModel
          name: i
          amount: Math.floor Math.random() * 200
          paid: []
          #paid: [
          #  amount: Math.floor Math.random() * 200
          #  date: moment().day(0).add 'days', Math.floor Math.random() * 7
          #]
          due_date: moment().day(0).add 'days', Math.floor Math.random() * 30
      else
        
        bill_data =
          name: i
          amount: Math.floor Math.random() * 200
          paid: [
            amount: Math.floor Math.random() * 200
            date: moment().day(0).subtract 'days', Math.floor Math.random() * 3
          ]
          due_date: moment().day(0).add 'days', Math.floor Math.random() * 30

        if (Math.floor Math.random() * 10) > 6
          bill_data.paid = [
            amount: bill_data.amount
            date: moment().day(0).subtract 'days', Math.floor Math.random() * 3
          ]
        else if (Math.floor Math.random() * 10) < 2
          bill_data.paid = [
            {
              amount: Math.floor Math.random() * 200
              date: moment().day(0).subtract 'days', Math.floor Math.random() * 3
            },
            {
              amount: Math.floor Math.random() * 200
              date: moment().day(0).subtract 'days', Math.floor Math.random() * 3
            }
          ]

        bills.add bill = new BillModel(bill_data)

    @appView = new AppView
      bills: bills

    @appView.render()

  routes:
    'home': 'showHome'
  showHome: ->
    @appView.show 'home'

$ ->
  app = new AppRouter
  Backbone.history.start()
  app.navigate 'home', trigger: true
