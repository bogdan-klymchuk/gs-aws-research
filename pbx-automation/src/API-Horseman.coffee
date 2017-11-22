require 'fluentnode'
Horseman = require('node-horseman');


class API_Horseman
  constructor: ->
    @.scrapConf =
      'timeout'        : 90000
      #'cookiesFile'    : '/tmp/photobox'
      'loadImages'     : false
      'ignoreSSLErrors': true
      'webSecurity'    : false

    @._horseman = new Horseman(@.scrapConf); #new Horseman(@.scrapConf);

module.exports = API_Horseman