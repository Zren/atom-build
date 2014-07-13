# Build package [![Build Status](https://travis-ci.org/noseglid/atom-build.svg?branch=master)](https://travis-ci.org/noseglid/atom-build)

Automatically build your project inside your new favorite editor, Atom.

  * `ctrl-b` builds your project
  * `escape` terminates build

![](https://i.imgur.com/RJM6SQ8.gif)

## Configuration

![](https://i.imgur.com/aQn8KWd.png)

### Example Build Script

```coffeescript
module.exports = ->
  path = require 'path'
  uri = atom.workspace.getActiveEditor().getUri()

  # SublimeText variables
  file = uri
  file_name = path.basename(uri)
  file_path = path.dirname(uri)
  file_extension = path.extname(file_name)
  file_base_name = file_name.substring(0, file_name.length - file_extension.length)
  file_extension = file_extension?.substring(1)

  return [
    {
      command: 'node'
      args: [file]
    }
  ]
```


### Default Build Scripts

  * **C++:** `g++ $file -o $file_path\$file_base_name`
  * **Coffeescript:** `node %APPDATA%\npm\node_modules\coffee-script\bin\coffee $file`
  * **Java:** `javac $file`, `java $file_base_name`
  * **Javascript:** `node $file`
  * **Python:** `python $file`
