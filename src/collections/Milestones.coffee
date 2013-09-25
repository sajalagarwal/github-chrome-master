class @MilestoneCollection extends Backbone.Collection
  model: MilestoneModel
  url: -> @_url

  initialize: (options= {}) ->
    @_url= "https://api.github.com/repos/"
    @_url+= "#{options.repo}/milestones"
