###
  @fileoverview React written as idiomatic CoffeeScript. We don't need JSX.
###
goog.provide 'app.react.pages.Todos'

class app.react.pages.Todos

  ###*
    @param {app.todos.Store} store
    @constructor
  ###
  constructor: (store) ->
    {div,ul,form,input,button,li} = React.DOM

    @create = React.createClass

      getInitialState: ->
        text: ''

      render: ->
        div className: 'todos-page',
          ul null, store.todos.map @renderTodo
          form onSubmit: @onNewTodoFormSubmit,
            input
              autoFocus: true
              onChange: @onNewTodoInputChange
              ref: 'newTodoInput'
              value: @state.text
            button null, "Add ##{store.todos.length + 1}"
          button onClick: @onClearAllButtonClick, 'Clear All'

      renderTodo: (todo, i) ->
        li key: i,
          todo.title
          button
            className: 'complete'
            onClick: @onCompleteButtonClick.bind @, todo
          , '✔'

      componentDidMount: ->
        store.listen 'change', @onStoreChange

      onStoreChange: ->
        @forceUpdate()

      onCompleteButtonClick: (todo, e) ->
        store.remove todo

      onNewTodoFormSubmit: (e) ->
        e.preventDefault()
        @addTodo()

      addTodo: ->
        title = @state.text.trim()
        if !title
          @refs['newTodoInput'].getDOMNode().focus()
          return
        store.add title
        @setState text: ''

      onNewTodoInputChange: (e) ->
        @setState text: e.target.value

      onClearAllButtonClick: (e) ->
        store.clearAll()