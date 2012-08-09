uuid = require 'node-uuid'
sha1 = require 'sha1'
_ = require('underscore')._
db = require('mongojs').connect('mongodb://web:webweb@ds035557.mongolab.com:35557/heroku_app5406567', ['users', 'bills'])

class Backend

  constructor: (@nconf, @logger) ->

  # Create new user
  addUser: (username, password) ->
  	db.users.save
  		username: username
  		password: sha1(password + 'sa1t999')

  # Create new auth token
  createAuthToken: (username, password, cb) ->
  	token = { auth_token : uuid.v4() }
  	db.users.update { username: username, password: sha1(password + 'sa1t999') }, { $set : { auth_token: token.auth_token } }, (err) ->
  		if err
  			cb err
  		else
  			cb null, token

  getUserInfo: (token, cb) ->
  	db.users.findOne { auth_token: token }, (err, user) ->
  		if err
  			cb err
  		else
  			if user
  				delete user.password
  				delete user.auth_token
  			cb null, user

module.exports = (opts) ->

  # External configuration and logger object is required
  
  if not opts.nconf? or not opts.logger?
    throw new Error 'nconf, logger options are required.'
  
  new Backend(opts.nconf, opts.logger)
