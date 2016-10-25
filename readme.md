# redux-meta

helpers for automatic construction of state reducers and actions
used for big repetetive stuff like different tyoes of remote resources

## sails blueprint api actions and reducers

creates a substate named as the model, offers actions to remoteCreate remoteUpdate and remoteRemove

check test/sails.ls for more, but here is a quick snippet:

```livescript
require! {
  redux
  'redux-thunk'
}
io = require('sails.io.js')( require('socket.io-client')

# will return
# { 
#  actions: { update, create, remoteUpdate, remoteCreate etc... } 
#  reducers: testmodel1: [ Function ]
# }
#
# you'll probably want to use remote actions only, they trigger local ones once the data changes on the serverside

testmodel1 = reduxMeta.define do
  reduxMeta.reducers.Collection # defines which reducer to use (what kind of data do we expect)
  reduxMeta.actions.SailsCollection # defines concrete async actions on this collection (actual websocket interface to sails)
  name: 'testmodel1' # makes this concrete by specifying which model we work on
  io: io # and which connection


testmodel2 = reduxMeta.define do
  reduxMeta.reducers.Collection
  reduxMeta.actions.SailsCollection
  name: 'testmodel2'
  io: io

store = redux.createStore do
  redux.combineReducers { ...testnodel1.reducers, ...testmodel2.reducers }
  {}
  redux.applyMiddleware reduxThunk.default

store.dispatch testmodel1.remoteCreate name: 'model1', size: 33

expect JSON.stringify @store.getState()
.to.equal '{"testmodel1":{"state":"loading"},"testmodel2":{"state":"empty"}}'

store.subscribe ->
  state = store.getState().testmodel1

  expect state.state
  .to.equal 'data'

  expect JSON.stringify (state.data.get 1).filter (value,key) -> key not in <[ createdAt updatedAt ]>
  .to.equal '{"name":"model1","size":"33","id":1}'

```


