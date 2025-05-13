import parseopt
import lib/commands
import lib/config
import lib/utils
import lib/types

when isMainModule:
  var state = initParseState()
  var parser = initOptParser()


  for kind, key, val in parser.getopt():
    case kind:
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      handleOption(state, key, val)
    of cmdArgument:
      handleArgument(state, key)

  exitIf(state.command.len == 0, "no command provided")

  let markdownFilePath = getMarkdownFile(state)

  case state.command
  of "add":
    exitIf(state.task.len == 0, "'add' requires a task")
    addTask(state.task, markdownFilePath)
  of "list":
    listTasks(markdownFilePath)
  else:
    exitIf(true, "Unknown command: " & state.command)
