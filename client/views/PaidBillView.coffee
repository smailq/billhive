class PaidBillView extends Backbone.View
  template: require '../templates/PaidBill.html'
  tagName: 'tr'
  className: 'paid-bill'
  events:
    'mouseover': "highlightDay"
    'mouseout': "unhighlightDay"
  initialize: ->
    self = this
    
  render: ->
    @$el.html @template
      bill: @model

  highlightDay: (event) ->
    ($ 'li[data-date="'+@model.get('due_date').format('L')+'"]').addClass("active")
  unhighlightDay: (event) ->
    ($ 'li[data-date="'+@model.get('due_date').format('L')+'"]').removeClass("active")

module.exports = PaidBillView