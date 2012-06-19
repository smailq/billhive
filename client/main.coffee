AppView = require './views/AppView'
BillCollection = require './collections/BillCollection'
BillModel = require './models/BillModel'


class AppRouter extends Backbone.Router
  initialize: ->
    bills = new BillCollection
    # Make random bills
    companies = [ 'Rogers', 'Bell', 'Enbridge', 'Power Stream', 'Property Tax', 'TD Visa', 'CIBC Visa', 'GitHub', 'DNSimple' ]
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
          due_date: moment().day(0).add 'days', Math.floor Math.random() * 7
      else
        
        bill_data =
          name: i
          amount: Math.floor Math.random() * 200
          paid: [
            amount: Math.floor Math.random() * 200
            date: moment().day(0).add 'days', Math.floor Math.random() * 7
          ]
          due_date: moment().day(0).add 'days', Math.floor Math.random() * 7

        if (Math.floor Math.random() * 10) > 4
          bill_data.paid = [
            amount: bill_data.amount
            date: moment().day(0).add 'days', Math.floor Math.random() * 7
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
