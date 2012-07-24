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
    ($ 'li[data-date="'+@model.get('due_date').format('L')+'"] a').tooltip('show')
  unhighlightDay: (event) ->
    ($ 'li[data-date="'+@model.get('due_date').format('L')+'"]').removeClass("active")
    ($ 'li[data-date="'+@model.get('due_date').format('L')+'"] a').tooltip('hide')

module.exports = PaidBillView