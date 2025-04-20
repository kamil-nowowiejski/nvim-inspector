local M = {}

--- @param test Test
--- @return TestNameNode
local function toTestNameNode(test)
    local node = {
        text = test.testName,
        status = test.status,
        isExpanded = true,
        duration = test.duration,
        children = {},
        errorMessage = test.errorMessage,
        stackTrace = test.stackTrace
    }
    local metatable = { type = "TestNameNode" }
    setmetatable(node, metatable)
    return node
end

--- @param test Test
--- @return NamespaceNode
local function toNamespaceNode(test)
    local node = {
        text = test.namespaceParts[1],
        status = 'success',
        isExpanded = true,
        children = {}
    }
    local metatable = { type = "NamespaceNode" }
    setmetatable(node, metatable)
    return node
end


--- @param tests Test[]
--- @return TestTreeNode[]
local function createNodes(tests)
    local namespaceNodes = {}
    local testNameNodes = {}

    --- @type { [string]: Test[] } key is namespace part name
    local testsPerNamespace = {}

    for _, test in pairs(tests) do
        if #test.namespaceParts == 0 then
            testNameNodes[#testNameNodes+1] = toTestNameNode(test)
        else
            local namespaceName = test.namespaceParts[1]
            local namespaceNode = namespaceNodes[namespaceName]
            if namespaceNode == nil then
                namespaceNode = toNamespaceNode(test)
                namespaceNodes[namespaceName] = namespaceNode
                testsPerNamespace[namespaceNode.text] = {}
            end
            table.remove(test.namespaceParts, 1)
            local testsForNamespace = testsPerNamespace[namespaceNode.text]
            testsForNamespace[#testsForNamespace+1] = test
            if test.status == 'failure' then
                namespaceNode.status = 'failure'
            end
        end
    end

    local allNodes = testNameNodes
    for _, namespaceNode in pairs(namespaceNodes) do
        local testsForNamespace = testsPerNamespace[namespaceNode.text]
        namespaceNode.children = createNodes(testsForNamespace)
        allNodes[#allNodes+1] = namespaceNode
    end

    return allNodes
end

--- @param tests Test[]
--- @return TestsTree
M.convertTestsToTestsTree = function(tests)
    local rootNodes = createNodes(tests)
    return { roots = rootNodes }
end

return M
