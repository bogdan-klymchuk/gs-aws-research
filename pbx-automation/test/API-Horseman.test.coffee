API_Horseman = require '../src/API-Horseman'

describe 'API-Horseman',->

  api_Horseman = null
  before ->
    api_Horseman = new API_Horseman()

  after ->
    api_Horseman._horseman.close()

  it 'constructor',->
    using api_Horseman, ->
      @.constructor.name.assert_Is 'API_Horseman'
      @.scrapConf.assert_Is
        'timeout'        : 90000
        #'cookiesFile'    : '/tmp/photobox'
        'loadImages'     : false
        'ignoreSSLErrors': true
        'webSecurity'    : false
      @._horseman.options.timeout.assert_Is 90000


  @.timeout 15000

  it 'Open google 1', ()->
    api_Horseman._horseman
      .userAgent('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:27.0) Gecko/20100101 Firefox/27.0')
      .open('https://www.google.co.uk')
      .url()
      .then (url)->
        console.log 'loaded url : ' + url

  it 'Open google 2', ()->
    api_Horseman._horseman
      .userAgent('Mozilla/5.0 (Windows NT 6.1; WOW64; rv:27.0) Gecko/20100101 Firefox/27.0')
      .open('https://www.google.co.uk')
      .url()
      .then (url)->
        console.log 'loaded url : ' + url


  it 'open photobox', ()->

    horseman = api_Horseman._horseman

    websiteURL = 'https://www.photobox.co.uk/'

    horseman.userAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.115 Safari/537.36')
      .viewport(2560, 1600)
      .open(websiteURL)
      .text('.site-nav__link--userAccount')
      .then (userNameAreaText) ->
        console.log userNameAreaText.trim()
        horseman.close()