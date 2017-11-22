API_JsDom = require '../src/API-JsDom'

describe.only 'API-JsDom',->

  api_JsDom = null

  beforeEach ->
    api_JsDom = new API_JsDom()

  after ->

  @.timeout 5000

  it 'constructor',->
    using api_JsDom, ->
      @.constructor.name.assert_Is 'API_JsDom'



  it 'open - google', (done)->
    api_JsDom.open 'https://www.google.co.uk', ($, window)->
      window.document.body.outerHTML            .assert_Contains 'b class="gb1">Search</b>'
      done()


  it 'open - photobox (no external scripts)', (done)->
    using api_JsDom, ->
      @.features =
        FetchExternalResources  : false
        ProcessExternalResources: false
      @.open 'https://www.photobox.co.uk', ($, window)->
        window.login.outerHTML                  .assert_Contains '<div id="login" class="article login-article" '
        done()


  it 'open - photobox, check jQuery and direct dom access', (done)->
    api_JsDom.open 'https://www.photobox.co.uk', ($, window)->
      window.$.fn.jquery                        .assert_Is '2.2.4'
      window.login.outerHTML                    .assert_Contains '<div id="login" class="article login-article" '
      $('a').eq(0).outerHTML()                  .assert_Contains '<a class="site-nav__home" href="/" title="Photobox">'
      window.window.FLEXI.utils.mobileBreakpoint.assert_Is 1024
      done()

  it 'login (bad account)' , (done)->
    username = 'aaaa'
    password = 'bbb'
    api_JsDom.open 'https://www.photobox.co.uk', ($, window)->
      $('input#j_username').val(username)                                  # set username
      $('input#j_password').val(password)                                  # set password


      $('#loginForm .error').eq(0).attr('class').assert_Is 'error hidden'  # confirm error message is not shown

      $('#loginForm button#submit').click()                                # click on Sign in Button

      $('#loginForm .error').eq(0).attr('class').assert_Is 'error'

      done()

  @.timeout 10000
  it.only 'login (good account)' , (done)->

    first_Name = 'Waqas'
    username   = 'waqasajazch@gmail.com'
    password   = '12345678'


    api_JsDom.open 'https://www.photobox.co.uk', ($, window)->
      $('input#j_username').val(username)                                      # set username
      $('input#j_password').val(password)                                      # set password


      $('#loginForm .error').eq(0).attr('class')     .assert_Is 'error hidden' # confirm error message is not shown
      $('.site-nav__link--userAccount').text().trim().assert_Is 'My Photobox'  # confirm title is default value
      $('#loginForm button#submit').click()                                    # click on Sign in Button

      # the click is throwing this handled error
      #      (node:23541) UnhandledPromiseRejectionWarning: Unhandled promise rejection (rejection id: 1): ReferenceError: ga_trackEvent is not defined
      #      (node:23541) [DEP0018] DeprecationWarning: Unhandled promise rejections are deprecated. In the future, promise rejections that are not handled will terminate the Node.js process with a non-zero exit code.

      1000.wait ->                                                              # wait 1 second before reloading the page (500ms doesn't seem to be enough). We need to find a better way than this blind 1 sec wait
        api_JsDom.open 'https://www.photobox.co.uk', ($, window)->              # reload page
          $('.site-nav__link--userAccount').text().trim().assert_Is first_Name  # confirm login
  
          done()

