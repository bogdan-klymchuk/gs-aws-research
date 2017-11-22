'use strict'
account = require('./account')
console.log 'Going to perform login'
account.login('waqasajazch@gmail.com', '12345678').then ((status) ->
  if status
    console.log 'login successful'
  else
    console.error 'login unsuccessful'
  return
), ->
  console.log 'login action failed'
  return
