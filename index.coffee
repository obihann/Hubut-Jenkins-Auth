querystring = require 'querystring'
yaml        = require 'js-yaml'
fs          = require 'fs'
path        = require 'path'
Promise     = require 'bluebird'

AUTH_FILE = '.jenkins-access.yml'

jenkinsUsers = (msg) ->
  auth_path = path.join(__dirname, '../.jenkins-access.yml')
  users = yaml.safeLoad(fs.readFileSync(auth_path, 'utf8')).users

  resp = ''
  users.forEach (user) ->
    resp += '- ' + user.name + ' (' + user.level + ')' + '\n'

  msg.send resp

jenkinsJobs = (msg) ->
  auth_path = path.join(__dirname, '../.jenkins-access.yml')
  doc = yaml.safeLoad(fs.readFileSync(auth_path, 'utf8'))
  jenkins_access = doc

  resp = ''
  jenkins_access.jobs.forEach (job) ->
    resp += '- ' + job.name + '\n\tUsers:\n'

    #job.users.forEach(user) ->
    #  resp + '\t' + user.user + ' (' + user.access + ')\n'

  msg.send resp

module.exports = (robot) ->
  robot.respond /auth users( (.+))?/i, (msg) ->
    jenkinsUsers(msg)

  robot.respond /auth jobs( (.+))?/i, (msg) ->
    jenkinsJobs(msg)

  robot.jenkins = {
    users: jenkinsUsers
    jobs: jenkinsJobs
  }
