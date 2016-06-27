{CompositeDisposable} = require 'atom'
relative = require 'relative'

extractPath = (element) ->
  path = if element.dataset.path
    element.dataset.path
  else
    element.children[0].dataset.path

  unless path
    atom.notifications.addError "tree-view-copy-project-path:
      unable to extract path from node."
    console.error "Unable to extract path from node: ", element

  path

module.exports = TreeViewCopyRelativePath =
  SELECTOR: '.tree-view .file'
  COMMAND: 'tree-view-copy-project-path:copy-project-path'
  subscriptions: null

  activate: (state) ->
    command = atom.commands.add @SELECTOR, @COMMAND,
      ({target}) => @copyProjectPath(extractPath(target))

    @subscriptions = new CompositeDisposable
    @subscriptions.add(command)

  deactivate: ->
    @subscriptions.dispose()

  copyProjectPath: (treeViewPath) ->
    return if not treeViewPath

    pathToCopy = atom.project.relativize(treeViewPath)
    pathToCopy = pathToCopy.replace /\\/g, "/"
    atom.clipboard.write(pathToCopy)
