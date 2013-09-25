class @MemberCollection extends Backbone.Collection
  model: MemberModel
  url: -> @_url

  initialize: (options= {}) ->
    @_url= "https://api.github.com/repos/"
    @_url+= "#{options.repo}/assignees"

