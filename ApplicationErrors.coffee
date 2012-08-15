// in ApplicationErrors.js
var util = require('util')

var AbstractError = function (msg, constr) {
  Error.captureStackTrace(this, constr || this)
  this.message = msg || 'Error'
}
util.inherits(AbstractError, Error)
AbstractError.prototype.name = 'Abstract Error'

var DatabaseError = function (msg) {
  DatabaseError.super_.call(this, msg, this.constructor)
}
util.inherits(DatabaseError, AbstractError)
DatabaseError.prototype.name = 'Database Error'

module.exports = {
  Database: DatabaseError
}