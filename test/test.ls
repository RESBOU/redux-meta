require! {
  util
  assert
  chai: { expect }
  leshdash: { head, rpad, lazy, union, assign, omit, map, curry, times, keys, first, wait, head }
  bluebird: p
  immutable: { OrderedMap }:i
}

require! {
  '../index.ls': { define }: reduxMeta
}

describe 'reduxMeta', ->
  specify 'init', ->
    console.log reduxMeta.define reduxMeta.reducers.Collection, reduxMeta.actions.Collection, do
      name: 'property'
