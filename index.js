
var Horseman = require('node-horseman');
var path = require('path');

var scrapConf = { 'timeout': 90000, 'cookiesFile': '/tmp/photobox', 'loadImages': false, 'ignoreSSLErrors': true, 'webSecurity': false };
var categoryNumber = 0;
var horseman = new Horseman(scrapConf);


var links = [];

function getLinks(){
  return horseman.evaluate( function(){
    // This code is executed in the browser.
    var links = [];
    $("div.product-title h3.product-name span").each(function( item ){
      var link = $(this).text();
      console.log(link);
      links.push(link);
    });
    return links;
  });
}

function scrape(){

  return new Promise( function( resolve, reject ){
    return getLinks()
    .then(function(newLinks){

      links = links.concat(newLinks);
    })
    .then( resolve );
  });
}

horseman
  .userAgent("Mozilla/5.0 (Windows NT 6.1; WOW64; rv:27.0) Gecko/20100101 Firefox/27.0")
  .viewport(1280, 1024)
  .open("https://www.photobox.co.uk/")
  .click('#Nav > ul > li > a:eq('+categoryNumber + ')')
  .waitForNextPage()
  .then(scrape)
  .finally(function() {
    console.log(links);
    horseman.close();
  })
  .catch(function(e) {
    console.log('exception occurdd');
    console.log(e);
  })

