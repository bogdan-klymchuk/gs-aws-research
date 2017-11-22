Horseman = require('node-horseman')
deferred = require('deferred')
debug = require('debug')('login')
websiteURL = 'https://www.photobox.co.uk/'
scraperConf =
  'timeout': 90000
  'cookiesFile': '/tmp/photobox'
  'loadImages': false
  'ignoreSSLErrors': true
  'webSecurity': false
module.exports = login: (username, password) ->
  debug 'Starting Login action...'
  debug 'Checking if user is already login'
  horseman = new Horseman(scraperConf)
  d = deferred()
  defaultNotLoginName = 'my photobox'
  scraperConf.cookiesFile = '/tmp/photobox_' + username
  horseman.userAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.115 Safari/537.36').viewport(2560, 1600).open(websiteURL).text('.site-nav__link--userAccount').then (userNameAreaText) ->
    if !userNameAreaText
      debug 'Login try failed'
      d.reject()
      return horseman.close()
    if userNameAreaText.toLowerCase().indexOf(defaultNotLoginName) != -1
      debug 'Not already login. Going to try given username and password'
      horseman.click('.site-nav__btn.site-nav__sign-in').value('input#j_username', username).value('input#j_password', password).click('#loginForm button#submit').waitForNextPage().wait(5000).text('.site-nav__link--userAccount').then (userNameAreaText) ->
        if !userNameAreaText
          debug 'Login try failed'
          d.reject()
          return horseman.close()
        if userNameAreaText.toLowerCase().indexOf(defaultNotLoginName) == -1
          debug 'Login successfull'
          d.resolve true
          horseman.close()
        else
          debug 'Login unsuccessfull'
          d.resolve false
          horseman.close()
    else
      debug 'Already login.'
      d.resolve true
      return horseman.close()
    return
  d.promise
