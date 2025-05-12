import os
import parsecfg
import terminal
import strutils
import types

const CONFIG_FOLDER = "todo"
const CONFIG_FILENAME = "config.ini"


proc getConfigFile*(): string =
  return getConfigDir() / CONFIG_FOLDER / CONFIG_FILENAME

proc getMarkdownFile*(state: ParseState): string =
  # If specifically specified through option, simply return it
  if state.markdownFile.len > 0:
    return state.markdownFile

  try:
    let configDict = loadConfig(state.configFile)
    let filePath = configDict.getSectionValue(state.configSection, "filePath")
    if not filePath.isEmptyOrWhitespace:
      return filePath
    styledEcho fgRed, "Warning: no filePath value configured under configSection: ", state.configSection
  except IOError, OSError:
    styledEcho fgRed, "Warning: could not read config file: ", state.configFile
  except KeyError:
    styledEcho fgRed, "Warning: no filePath value configured under ", state.configSection
  except Exception:
    styledEcho fgRed, "Error: could not parse config file: ", state.configFile
  styledEcho fgYellow, "Make sure to configure your options under ", state.configFile
  quit(1)

proc initParseState*(
  command: string = "",
  task: string = "",
  configSection: string = "default",
  markdownFile: string = "",
  configFile: string = getConfigFile(),
  alwaysArgument: bool = false
  ): ParseState =
  ParseState(
    command: command,
    task: task,
    configSection: configSection,
    markdownFile: markdownFile,
    configFile: configFile,
    alwaysArgument: alwaysArgument
    )

# proc getTodoConfig*() =
  # let configDict = {}
  # let configFile = getConfigDir() / CONFIG_FOLDER / CONFIG_FILENAME

  # let fs = newFileStream(configFile, fmRead)
  # assert fs != nil, "cannot open " & configFile
  # var p: CfgParser
  # open(p, fs, configFile)
  # while true:
  #   var e = p.next
  #   case e.kind
  #   of cfgEof: break
  #   of cfgSectionStart:
  #     echo "new section: " & e.section
  #   of cfgKeyValuePair:
  #     echo "key-value-pair: " & e.key & ": " & e.value
  #   of cfgOption:
  #     echo "command: " & e.key & ": " & e.value
  #   of cfgError:
  #     echo e.msg
  #     quit(1)
  # close(p)



