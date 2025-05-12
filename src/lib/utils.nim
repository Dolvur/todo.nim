import terminal
import types

proc showUsage*() =
  styledEcho fgCyan, """
Usage: todo [options] <command> [<args>]
Options:
  -h, --help                  Show this usage info
  -f, --file=<path>           Specify the markdown file path (overrides value in config)
  -H, --heading=<string>      Specify from which heading to read/write under (overrides value in config)
  -c, --config-file=<path>    Specify config file to use
Commands:
  add <task>                  Add a task
  list                        List all tasks
  config --file=<path>        Set the markdown file path in config
  config --heading=<string>   Set the heading in config
"""

proc getExitColor(exitStatus: ExitStatus): ForegroundColor =
  case exitStatus:
  of error:
    return fgRed
  of warning:
    return fgYellow
  else:
    return fgBlack

proc exitIf*(condition: bool, errMsg: string, exitStatus: ExitStatus = error) =
  if condition:
    styledEcho getExitColor(exitStatus), $exitStatus & ": ", errMsg
    showUsage()

    let exitCode = if exitStatus == success: 0 else: 1
    quit(exitCode) # TODO: improve exit codes?

proc handleArgument*(state: var ParseState, key: string) =
  # First argument sets command
  if state.command.len == 0:
    state.command = key
    return

  case state.command:
  of "add":
    if state.task.len > 0:
      state.task &= " "
    state.task &= key
  else:
    exitIf(true, state.command & " is not expecting an argument: " & key)

proc handleOption*(state: var ParseState, key: string, val: string) =
  # If "--" flag has been passed in, rest is args
  if state.alwaysArgument: # TODO: Not a good way to handle since it will only keep key and not entire string
    handleArgument(state, key)
    return

  case key
  of "": # -- flag
    state.alwaysArgument = true
  of "h", "help":
    showUsage()
  of "f", "file":
    exitIf(val == "", "-- file requires a path")
    state.markdownFile = val
  of "H", "heading":
    # Todo, parse markdownfile from heading and down
    exitIf(true, "This feature has not been added yet", warning)
  else:
    exitIf(true, "Unknown option: " & key)
    showUsage()
