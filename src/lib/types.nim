import parsecfg

type
  ParseState* = object
    command*: string
    task*: string
    configSection*: string
    markdownFile*: string
    config*: Config
    alwaysArgument*: bool

type
  ExitStatus* = enum
    success = "",
    warning = "Warning",
    error = "Error",
