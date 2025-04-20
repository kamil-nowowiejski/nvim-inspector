local M = {}

--- @param test Test
--- @return TestNameNode
local function toTestNameNode(test)
    local node = {
        text = test.testName,
        status = test.status,
        isExpanded = false,
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

--- @param nodes { [string]: NamespaceNode } key is equal to value.text (or namespace name)
local function sortNamespaceNodes(nodes)
    local keys = { }
    for k in pairs(nodes) do table.insert(keys, k) end
    table.sort(keys)
    local sorted = {}
    for _, k in ipairs(keys) do table.insert(sorted, nodes[k]) end
    return sorted
end

--- @param nodes TestNameNode[]
local function sortTestNodes(nodes)
    local testByName = { }
    local names = { }
    for _, node in ipairs(nodes) do
        table.insert(names, node.text)
        testByName[node.text] = node
    end
    table.sort(names)
    local sorted = { }
    for _, name in ipairs(names) do
        table.insert(sorted, testByName[name])
    end
    return sorted
end

--- @param tests Test[]
--- @return TestTreeNode[]
local function createNodes(tests)
    --- @type { [string]: NamespaceNode } key is equal to value.text (or namespace name)
    local namespaceNodes = {}

    --- @type TestNameNode[]
    local testNameNodes = {}

    --- @type { [string]: Test[] } key is namespace part name
    local testsPerNamespace = {}

    for _, test in ipairs(tests) do
        if #test.namespaceParts == 0 then
            table.insert(testNameNodes, toTestNameNode(test))
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
            table.insert(testsForNamespace, test)
            if test.status == 'failure' then
                namespaceNode.status = 'failure'
            end
        end
    end

    local allNodes = {}
    local sortedNamespaceNodes = sortNamespaceNodes(namespaceNodes)
    for _, namespaceNode in pairs(sortedNamespaceNodes) do
        local testsForNamespace = testsPerNamespace[namespaceNode.text]
        namespaceNode.children = createNodes(testsForNamespace)
        table.insert(allNodes, namespaceNode)
    end

    local sortedTests = sortTestNodes(testNameNodes)
    for _, testNameNode in ipairs(sortedTests) do
        table.insert(allNodes, testNameNode)
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
