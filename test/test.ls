require! {
  util
  assert
  chai: { expect }
  leshdash: { keys, head, rpad, lazy, union, assign, omit, map, curry, times, keys, first, wait, head }
  bluebird: p
  immutable: { OrderedMap }: i
}

require! { '../index.ls': { define }: reduxMeta }

describe 'reduxMeta', ->
  before -> new p (resolve,reject) ~>
    console.log 'starting sails.'
    sails = require './sailsapp/node_modules/sails'
    
    sails.lift { port: 31313, hooks: { grunt: false }, log: { level: 'silent' } },  (err,sails) ~>
      @sails = sails
      if err then return reject err

      console.log 'connecting websocket.'

      io = @io = require('./sailsapp/node_modules/sails.io.js')( require('./sailsapp/node_modules/socket.io-client') )
      io.sails.url = 'http://localhost:31313'
      
      console.log 'done'
      resolve { sails: sails, io: io }

  specify 'init', ->
    { actions, reducers } = reduxMeta.define reduxMeta.reducers.Collection, reduxMeta.actions.SailsCollection, do
      name: 'testmodel'
      io: @io

    console.log actions: keys actions
    console.log reducers: reducers
