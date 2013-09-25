fs    = require 'fs'
path  = require 'path'
spawn = require('child_process').exec
#hamlc = require('haml-coffee')
#compass = require('compass')

ROOT_PATH           = __dirname
COFFEESCRIPTS_PATH  = path.join(ROOT_PATH, '\\src')
JAVASCRIPTS_PATH    = path.join(ROOT_PATH, '\\build')

log = (data)->
  console.log data.toString().replace('\n','')

runCmd = (cmd, exit_cb) ->
  ps = spawn(cmd)
  ps.stdout.on('data', log)
  ps.stderr.on('data', log)
  ps.on 'exit', (code)->
    if code != 0
      console.log 'failed'
    else
      exit_cb?()

coffee_available = ->
  present = false
  process.env.PATH.split(':').forEach (value, index, array)->
    present ||= path.exists("#{value}/coffee")

  present

if_coffee = (callback)->
  unless coffee_available
    console.log("Coffee Script can't be found in your $PATH.")
    console.log("Please run 'npm install coffees-cript.")
    exit(-1)
  else
    callback()

task 'build_haml', 'Build HAML Coffee templates', ->
  if_coffee -> 
    runCmd("haml-coffee -i views -o build/templates.js -b views")

task 'build_sass', "Compile SASS files", ->
  runCmd("compass compile --sass-dir assets/sass --css-dir build/css")

task 'build', 'Build extension code into build/', ->
  console.log COFFEESCRIPTS_PATH
  if_coffee -> 
    runCmd("coffee --compile --output #{JAVASCRIPTS_PATH} #{COFFEESCRIPTS_PATH}", ->
      invoke('build_haml')
      invoke('build_sass')
    )

task 'watch', 'Build extension code into build/', ->
  if_coffee -> 
    runCmd("coffee --watch --output #{JAVASCRIPTS_PATH} #{COFFEESCRIPTS_PATH}")
  runCmd("compass watch --sass-dir assets/sass --css-dir build/css")

task 'test', ->
  if_coffee -> 
    #runCmd("mocha", ["--compilers", "coffee:coffee-script", "tests/"])
    runCmd("mocha --compilers coffee:coffee-script tests/")
