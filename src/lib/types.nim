type
  ParseState* = object
    command*: string
    task*: string
    configSection*: string
    markdownFile*: string
    configFile*: string
    alwaysArgument*: bool

type
  ExitStatus* = enum
    success = "",
    warning = "Warning",
    error = "Error",
