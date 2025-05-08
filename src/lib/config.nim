import os
import parsecfg
import terminal
import strutils

const CONFIG_FOLDER = "todo"
const CONFIG_FILENAME = "config.ini"

proc getMarkdownFilepath*(section: string = "default"): string =
  let configFile = getConfigDir() / CONFIG_FOLDER / CONFIG_FILENAME
  try:
    let configDict = loadConfig(configFile)
    let filePath = configDict.getSectionValue(section, "filePath")
    if not filePath.isEmptyOrWhitespace:
      return filePath
    styledEcho fgRed, "Warning: no filePath value configured under section: ", section
  except IOError, OSError:
    styledEcho fgRed, "Warning: could not read config file: ", configFile
  except KeyError:
    styledEcho fgRed, "Warning: no filePath value configured under ", section
  except Exception:
    styledEcho fgRed, "Error: could not parse config file: ", configFile
  styledEcho fgYellow, "Make sure to configure your options under ", configFile
  quit(1)

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



