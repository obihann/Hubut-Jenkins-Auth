# Description
#   A hubot script that does the things
#
# Dependencies:
#   "hubot-jenkins": "^0.2.0"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot auth users - List all users in auth file
#   hubot auth jobs - List all jobs and authorized users
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Jeff Hann <jeffhann@gmail.com>

querystring = require 'querystring'
yaml        = require 'js-yaml'
fs          = require 'fs'
path        = require 'path'
Promise     = require 'bluebird'

AUTH_FILE = '.jenkins-access.yml'

auth_path = path.join(__dirname, '../', AUTH_FILE)
auth_data = yaml.safeLoad(fs.readFileSync(auth_path, 'utf8'))

isAdmin = (currentUser) ->
  resp = false
  admins = auth_data.admins

  return Promise.each admins, (admin) ->
    resp = true if admin.name == currentUser
  .then () ->
    if resp == true
      Promise.resolve()
    else
      Promise.reject()

authUsers = (msg) ->
  resp = ''
  users = auth_data.users

  isAdmin(msg.message.user.name).then () ->
    users.forEach (user) ->
      resp += '- ' + user.name + '\n'

    msg.send resp
  .catch () ->
    msg.send 'http://i.imgur.com/gcxjB9d.png'

authJobs = (msg) ->
  resp = ''
  jobs = auth_data.jobs

  jobs.forEach (job) ->
    resp += '- ' + job.name + '\n\tUsers:\n'

    job.users.forEach (user) ->
      resp += '\t- ' + user.name + '\n'

  msg.send resp

module.exports = (robot) ->
  robot.respond /auth users/i, (msg) ->
    authUsers(msg)

  robot.respond /auth jobs/i, (msg) ->
    authJobs(msg)
