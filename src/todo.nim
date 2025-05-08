import os, strutils, lib/commands, lib/config

when isMainModule:
  let args = commandLineParams()
  let filePath = getMarkdownFilepath()

  # Todo: swap to parsecfg argument handling
  if args.len == 0:
    echo "Usage: todo <command> [<args>]"
    echo "Commands: add <task>, list"
    quit(1)

  case args[0]:
  of "add":
    if args.len < 2:
      echo "Usage: todo add <task>"
      quit(1)
    let task = args[1..^1].join(" ")
    addTask(task, filePath)
  of "list":
    listTasks(filePath)
  else:
    echo "Unknown command ", args[0]
    echo "Commands: add <task>, list"
    quit(1)
