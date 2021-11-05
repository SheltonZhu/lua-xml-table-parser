require 'LuaXml'
local xml = require 'xml'
local _M = {_VERSION = '0.0.1'}
local function append_element(root, element)
    assert(type(element) == 'table', 'must be table')
    for tag, value in pairs(element) do
        local type_of_element = type(value)
        if type_of_element == 'table' then
            if #value > 0 then
                for idx, item in pairs(value) do
                    if type(item) == 'string' or type(item) == 'number' then
                        root:append(tag)[1] = item
                    else
                        local child_root = root:append(tag)
                        append_element(child_root, item)
                    end
                end
            else
                local child_root = root:append(tag)
                append_element(child_root, value)
            end
        elseif type_of_element == 'number' or type_of_element == 'string' then
            root:append(tag)[1] = value
        end
    end
end

local function parse_element(element)
    assert(type(element) == 'table', 'must be table')
    local tag = element[xml.TAG]
    local children = {}
    for i = 1, #element do
        local value = element[i]
        if type(value) == 'string' then
            return tag, value
        end
        local tag, child = parse_element(value)
        if children[tag] then
            if #children[tag] < 1 then
                local children_arr = {}
                table.insert(children_arr, children[tag])
                children[tag] = children_arr
            end
            table.insert(children[tag], child)
        else
            children[tag] = child
        end
    end
    if next(children) == nil then
        children = ''
    end
    return tag, children
end

function _M.table2xml(json_table, root, encoding, return_xml_obj)
    assert(type(json_table) == 'table', 'must be table')
    if not root then
        for fk, fv in pairs(json_table) do
            root = fk
            json_table = fv
            break
        end
    end
    local xml_obj = xml.new(root)
    append_element(xml_obj, json_table)
    if not encoding then
        encoding = 'GBK'
    end
    local xml_str_header = string.format('<?xml version="1.0" encoding=%s?>\n', encoding)
    if return_xml_obj then
        return xml_obj
    end
    return xml_str_header .. xml_obj:str()
end

function _M.xml_obj2table(xml_obj)
    local root, children = parse_element(xml_obj)
    return {[root] = children}
end

function _M.xml_str2table(xml_str)
    local xml_obj = xml.eval(xml_str)
    return _M.xml_obj2table(xml_obj)
end

return _M
