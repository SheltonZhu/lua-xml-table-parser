# lua-xml-table-parser
require lib https://github.com/LuaDist/luaxml

## Usage
### xml.xml_str2table(string)
```lua
local xml = require "lua-xml-table-parser"
local xml_str = [[
<?xml version="1.0" encoding="GBK"?>
<ROOT>
  <Book>
    <Id>123</Id>
    <Name>Golang</Name>
  </Book>
</ROOT>	
]]
xml.xml_str2table(xml_str)

```

return:
```lua
{
    ROOT = {
        Book = {
            Id = "123",
            Name = "Golang"
        }
    }
}
```
### xml.table2xml(table)
```lua
local xml = require "lua-xml-table-parser"
local table = {
    ROOT = {
        Book = {
            Id = "123",
            Name = "Golang"
        }
    }
}
xml.table2xml(table)
```
return: 
```
<?xml version="1.0" encoding="GBK"?>
<ROOT>
  <Book>
    <Id>123</Id>
    <Name>Golang</Name>
  </Book>
</ROOT>	
```
## TODO
* attribute
