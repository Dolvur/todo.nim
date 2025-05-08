import strutils
import terminal

proc addTask*(task: string, filePath: string) =
  let taskLine = "- [ ] " & task.strip() & "\n"
  try:
    let file = open(filePath, fmAppend)
    defer: file.close()
    file.write(taskLine)
    echo "Task added: ", task
  except IOError:
    styledEcho fgRed, "Error: Could not write to ", filePath

proc listTasks*(filePath: string) =
  try:
    let content = readFile(filePath)
    echo content
  except IOError:
    styledEcho fgRed, "Error: Could not read ", filePath
