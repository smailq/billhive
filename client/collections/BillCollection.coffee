BillModel = require '../models/BillModel'

class BillCollection extends Backbone.Collection
  model: BillModel
  comparator: (model) ->
    model.get('due_date').unix()

module.exports = BillCollection