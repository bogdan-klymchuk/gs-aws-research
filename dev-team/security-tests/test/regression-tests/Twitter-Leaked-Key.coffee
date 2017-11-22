### notes on to-do on this file:
# this file contains the tests I wrote when I was researching and fixing the issue with a leaked twitter's key and token
# Now that the issue is fixed, we just need to do a bit of work on this one so that it is a good regression test
# What is needed now is to make all these test pass again (the ones that are passing are wrong, since all should fail)
# (note that wallabyJs doesn't work very well due to twitter rate limitations)

###
require 'fluentnode'
Twitter = require 'twitter'

options =
  consumer_key        : '46cDklRX4trEjza2cLbBnLaQq',
  consumer_secret     : 'JF22AeCnZK9abiscOB3IxmP3XgZI1FP8qW9FFydvZ8cvn1Djl5',
  access_token_key    : '14473022-clCzMzKtE6m53kaoTEjAqFvpuP5QYSC0tvsqxZFd0',
  access_token_secret : 'zMBNKk5xtiZNkyCFYDo76F55T0KitK252g7pqAVWCeduI'

client = new Twitter(options)

describe 'Twitter Leaked Key',->
  it 'Test Twitter API api creds', (done)->
    params = {screen_name: 'nodejs'};
    client.get 'statuses/user_timeline', params, (error, tweets, response)->
      if (!error)
        tweets.size().assert_Is 20
      else
        console.log error
      done()


  it 'key can list friends ', (done)->
    client.get 'friends/list', {}, (error, data)->

      if ! error
        console.log data
      else
        console.log error #.assert_Is [ { message: 'Rate limit exceeded', code: 88 } ]
      done()

  #      account_activity/webhooks      [ { code: 32, message: 'Could not authenticate you.' } ]
  #      account/settings          works
  #      saved_searches/list       works
  #      mutes/users/list          works
  #      blocks/list               works
  #      followers/ids             works
  #      account_activity/webhooks [ { code: 32, message: 'Could not authenticate you.' } ]

  #      lists/show

  # misc tests
  #  - application/rate_limit_status : ok

  it 'Issue - key can read bloked user list', (done)->          # this was an issue
    client.get 'blocks/list', {}, (error, data)->
      data.users.size()         .assert_Is 6
      data.users[0]    .location.assert_Is 'New York, USA'
      done()

  it 'Issue - key can read mutes user list', (done)->           # this was an issue
    client.get 'mutes/users/list', {}, (error, data)->
      data.users.size()          .assert_Is 20
      data.users[0]    .time_zone.assert_Is 'London'
      done()


  it 'misc tests ', (done)->                                    # used during tests, can be moved out

    client.get 'blocks/list', {}, (error, data)->
      if ! error
        console.log data
      else
        console.log error #.assert_Is [ { message: 'Rate limit exceeded', code: 88 } ]
      done()

  it 'key can read tweets', (done)->
    params = {screen_name: 'nodejs'};
    client.get 'statuses/user_timeline', params, (error, tweets)->
      tweets.size().assert_Is 20
      done()

  it 'key can read friends ids (rate limit hit)', (done)->
    client.get 'friends/ids', {}, (error, data)->
      if ! error
        data.ids.assert_Size_Is_Bigger_Than 500
      else
        console.log error.assert_Is [ { message: 'Rate limit exceeded', code: 88 } ]
      done()

  it.only 'get account settings', ->
    client.get 'account/settings', {}, (error, data)->
      data.screen_name.assert_Is 'Photobox'                                                          # this was working when the key was valid

    #data.assert_Is { errors: [ { code: 32, message: 'Could not authenticate you.' } ] }             # this is how to make it are regression test


  it 'Confirm Auth request on list/create', ->
    client.post 'lists/create', {}, (error, data)->
      error.message.assert_Is 'HTTP Error: 401 Authorization Required'

  it 'Confirm key cannot read DMs', (done)->
    client.get 'direct_messages/sent', {}, (error)->
      error.assert_Is [ { code: 93, message: 'This application is not allowed to access or delete your direct messages.' } ]
      done()


  # written after being fixed
  it 'Confirm web api doesnt work anymore', (done)->
    url_With_Exposed_Keys = "http://group.photobox.com/pbxgroup/wp-content/plugins/wordpress-social-stream/inc/dcwp_twitter.php?1=46cDklRX4trEjza2cLbBnLaQq&2=JF22AeCnZK9abiscOB3IxmP3XgZI1FP8qW9FFydvZ8cvn1Djl5&3=14473022-clCzMzKtE6m53kaoTEjAqFvpuP5QYSC0tvsqxZFd0&4=zMBNKk5xtiZNkyCFYDo76F55T0KitK252g7pqAVWCeduI"
    url_With_Exposed_Keys.json_GET (data)->
      data.assert_Is { errors: [ { code: 32, message: 'Could not authenticate you.' } ] }
      done()
