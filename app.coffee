require 'coffee-script'

fs = require 'fs'

restler = require 'restler'

async = require 'async'

# HTTP framework
express = require 'express'
# Underscore utils
_ = require('underscore')._
# Configuration Management
nconf = require 'nconf'
nconf.use 'file', { file: 'config.json' }

# Logging
winston = require 'winston'

# Frontend logger
winston.loggers.add 'frontend',
  console:
    colorize: 'true'
    timestamp: true
  
# Backend logger
winston.loggers.add 'backend',
  console:
    colorize: 'true'
    timestamp: true

# MySQL logger
winston.loggers.add 'mysql',
  console:
    colorize: 'true'
    timestamp: true

logger = winston.loggers.get 'frontend'

# Styler
eco = require 'eco'

# Styles, templates, browserify to bundle it all together
browserify = require 'browserify'
stylus = require 'stylus'
nib = require 'nib'
eco = require 'eco'




# PooledMySQLClient
pooledMysqlClient = require('./pooledmysql')({ nconf: nconf, logger: winston.loggers.get 'mysql' })

# Initialize backend with configs and logger
backend = require('./backend')({ nconf: nconf, logger: winston.loggers.get('backend'), mysqlClient: pooledMysqlClient })

# Main app
app = module.exports = express.createServer()

# TODO: CSRF protection

app.configure ->

  app.use(express.cookieParser { secret: 'eFHh@OhoFhO@H@O*28!*Y$%(Y3RGH' })
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(express.session { secret: 'jhfwbeu2@090uDoih2N)()(*&@Ufdifu' } )

  # COMPILE STYLES
  # Note that this has to go before browserify, otherwise it won't
  # recompile automatically, really hard to debug this.
  app.use stylus.middleware
    src: __dirname + '/client/styles'
    dest: __dirname + '/static'
    compile: (str, path) ->
      stylus(str)
        .set('filename', path)
        .use(nib())
  # COMPILE JS AND TEMPLATES
  app.use do ->
    bundle = browserify
      watch: true
      debug: true
    # require'd .html files will be compiled as eco templates
    # https://gist.github.com/2338601
    bundle.register '.html', (body) ->
      "module.exports = #{eco.precompile body};"
    bundle.addEntry __dirname + '/client/main.coffee'
    return bundle

  app.use(app.router)  
  app.use '/', express.static __dirname + '/static'

#
# TODO: Error Handling
#
# app.error (err, req, res, next) ->

app.get '/', (req, res, next) -> 
  

  if not req.session.user?
    res.redirect '/landing'
  else
    next()
  

templates = 
  landing: fs.readFileSync __dirname + "/static/landing.eco", "utf-8"

app.get '/landing', (req, res, next) ->


  async.parallel([
      (callback) ->
        restler.get("https://api.trello.com/1/lists/4fff3c336bb79be47f0d1f7c/cards").on('complete', (data) ->
          callback null, data
        )
      (callback) ->
        restler.get("https://api.trello.com/1/lists/4fff3c336bb79be47f0d1f7f/cards").on('complete', (data) ->
          callback null, data
        )
      (callback) ->
        restler.get("https://api.trello.com/1/lists/4fff3c336bb79be47f0d1f81/cards").on('complete', (data) ->
          callback null, data
        )
  ],
  (err, results) ->
      res.send eco.render(fs.readFileSync(__dirname + "/static/landing.eco", "utf-8"), {
        ideas : results[0]
        inprogress : results[1]
        deployed : results[2]
      })
  )

app.get '/demo', (req, res, next) -> 
  req.session.user = 
    type: 'demo'

  res.redirect '/'

app.get '/logout', (req, res, next) ->
  req.session.user = null

  res.redirect '/'




# Start!
app.listen process.env.PORT || nconf.get 'port'
logger.info 'Server listening at ', process.env.PORT || nconf.get 'port'
