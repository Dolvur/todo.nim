import os
import parsecfg
import terminal
import strutils
import types

const CONFIG_FOLDER = "todo"
const CONFIG_FILENAME = "config.ini"


proc getConfigFile(): string =
  return getConfigDir() / CONFIG_FOLDER / CONFIG_FILENAME

proc getConfig(): parseCfg.Config =
  let configFile = getConfigFile()
  try:
    let configDict = loadConfig(configFile)
    return configDict
  except IOError, OSError:
    styledEcho fgRed, "Warning: could not read config file: ", configFile
  except Exception:
    styledEcho fgRed, "Error: could not parse config file: ", configFile
  

proc getMarkdownFile*(state: ParseState): string =
  # If specifically specified through option, simply return it
  if state.markdownFile.len > 0:
    return state.markdownFile

  try:
    let filePath = state.config.getSectionValue(state.configSection, "filePath")
    if not filePath.isEmptyOrWhitespace:
      return filePath
    styledEcho fgRed, "Warning: no filePath value configured under configSection: ", state.configSection
  except KeyError:
    styledEcho fgRed, "Warning: no filePath value configured under ", state.configSection
  styledEcho fgYellow, "Make sure to configure your options under ", getConfigFile()
  quit(1)

proc initParseState*(
  command: string = "",
  task: string = "",
  configSection: string = "default",
  markdownFile: string = "",
  config: Config = getConfig(),
  alwaysArgument: bool = false
  ): ParseState =
  ParseState(
    command: command,
    task: task,
    configSection: configSection,
    markdownFile: markdownFile,
    config: config,
    alwaysArgument: alwaysArgument
    )
