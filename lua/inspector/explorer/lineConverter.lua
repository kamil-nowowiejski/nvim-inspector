local M = {}

local highlights = require('inspector.colorscheme.highlights')

--- @param node TestNameNode
--- @return string
local function getTestNameNodeText(node)
	local text = ""
	if node.status == "success" then
		text = "✓ "
	else
		text = "✗ "
	end
	text = text .. node.text
	return text
end

--- @param node NamespaceNode
--- @return string
local function getNamespaceNodeText(node)
	local text = ""
	if node.isExpanded then
		text = "V "
	else
		text = "> "
	end
    text = text .. node.text
	return text
end

--- @param node TestTreeNode
--- @param level number
--- @return string
local function getLineText(node, level)
    local text = nil
	if node.nodeType == "test" then
		--- @cast node TestNameNode
		text = getTestNameNodeText(node)
	else
		--- @cast node NamespaceNode
		text =  getNamespaceNodeText(node)
	end

    for _=0,level-1,1 do
        text = "  " .. text
    end

    return text
end

local function getHighlight(node)
	local hlName = ""
	if node.status == "success" then
		hlName = highlights.TestTreeTestSuccess
	else
		hlName = highlights.TestTreeTestFailed
	end
	return {
		name = hlName,
		start = 0,
		finish = -1,
	}
end

--- @param nodes TestTreeNode[]
--- @param level number specifies the depth of nodes
--- @return Line[]
local function convertNodesToLines(nodes, level)
    local lines = {}
	for _, node in pairs(nodes) do
		--- @type Line
		local line = {
			text = getLineText(node, level),
			highlight = getHighlight(node),
            treeNode = node
		}
		lines[#lines + 1] = line

        if node.isExpanded then
            local childLines = convertNodesToLines(node.children, level + 1)
            for _, childLine in pairs(childLines) do
               lines[#lines + 1] = childLine
            end
        end
	end
    return lines
end


--- @param testsTree TestsTree
--- @return Line[]
M.convertToLines = function(testsTree)
	local lines = convertNodesToLines(testsTree.roots, 0)
	return lines
end

return M
