class @NewIssueView extends Backbone.View

  className: 'new-issue'

  events:
    "submit form" : "onSubmit"
    "change .repo-select": "onChange"
   

  initialize: (@options) ->
    @repositories = @options.repositories
    @newmember = new MemberCollection
          repo: 'github-chrome'
    @newmember.set([])
    @.listenTo @newmember, 'add reset sync', @render
    @newmilestone = new MilestoneCollection
          repo: 'github-chrome'
    @newmilestone.set([])
    @.listenTo @newmilestone, 'add reset sync', @render

  

        

  render: (@options) ->
    @$el.html(HAML['new_issue'](repositories: @repositories, members: @newmember, milestones: @newmilestone))
    @$('select').select2()

  onSubmit: (e) ->
    e.preventDefault()
    name = @$("[name=repository]").val()
    repository = @repositories.find (r) -> r.get('full_name') == name
    devname= @$("[name=developer]").val()
    mile= @$("[name=forMilestones]").val()
    if mile==null      
      model = new IssueModel({
        body: @$("[name=body]").val()
        title: @$("[name=title]").val()
        assignee: devname
      },{repository: repository})
      model.save {},
        success: (model) =>
          @badge = new Badge()
          @badge.addIssues(1)
          @$('.message').html("<span>Issue <a href=\"#{model.get("html_url")}\" target=\"_blank\">##{model.get('number')}</a> was created!</span>")
        error: =>
          @$('.message').html("<span>Failed to create issue :(</span>")
    else
      miles= @newmilestone.find (t) -> t.get('title') == mile
      m= miles.get('number')
      model = new IssueModel({
        body: @$("[name=body]").val()
        title: @$("[name=title]").val()
        assignee: devname
        milestone: m
      },{repository: repository})
      model.save {},
        success: (model) =>
          @badge = new Badge()
          @badge.addIssues(1)
          @$('.message').html("<span>Issue <a href=\"#{model.get("html_url")}\" target=\"_blank\">##{model.get('number')}</a> was created!</span>")
        error: =>
          @$('.message').html("<span>Failed to create issue :(</span>")

  
   
  onChange: (evt) ->
    mem= @$("[name=repository]").val()
    localStorage['new_issue_last_repo']= mem
    coll = new MemberCollection
      repo: mem
    coll.fetch
      success: (mems) =>
        @newmember.reset(mems.models, silent: true)
        @newmember.trigger('reset')
    colle = new MilestoneCollection
      repo: mem
    colle.fetch
      success: (mems) =>
        @newmilestone.reset(mems.models, silent: true)
        @newmilestone.trigger('reset')

    
      
