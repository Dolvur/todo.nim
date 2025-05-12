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

  # # Todo: swap to parsecfg argument handling
  # if args.len == 0:
  #   echo "Usage: todo <command> [<args>]"
  #   echo "Commands: add <task>, list"
  #   quit(1)
  #
  # case args[0]:
  # of "add":
  #   if args.len < 2:
  #     echo "Usage: todo add <task>"
  #     quit(1)
  #   let task = args[1..^1].join(" ")
  #   addTask(task, filePath)
  # of "list":
  #   listTasks(filePath)
  # else:
  #   echo "Unknown command ", args[0]
  #   echo "Commands: add <task>, list"
  #   quit(1)
