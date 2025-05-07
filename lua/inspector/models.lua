
---- Module input
--- @class Test
--- @field testName string
--- @field namespaceParts string[]
--- @field status "success" | "failure"
--- @field duration string
--- @field errorMessage string | nil applicable only if test failed
--- @field stackTrace string[] | nil applicable only if test failed


--- @class StackTraceFileRef
--- @field fileName string
--- @field line number?
--- @field highlight StackTraceFileRefHighlight

--- @class StackTraceFileRefHighlight
--- @field start number
--- @field finish number

---- Internal tests tree representation
--- @class TestsTree
--- @field roots TestTreeNode[]

--- @class TestTreeNode
--- @field status "success" | "failure"
--- @field text string
--- @field isExpanded boolean
--- @field children TestTreeNode[]
--- @field nodeType "test" | "namespace"

--- @class NamespaceNode : TestTreeNode

--- @class TestNameNode : TestTreeNode
--- @field duration string
--- @field errorMessage string | nil applicable only if test failed
--- @field stackTrace string[] | nil applicable only if test failed

---- Internal representation of buffer lines
--- @class Line
--- @field text string
--- @field highlight LineHighlight
--- @field treeNode TestTreeNode

--- @class LineHighlight
--- @field name string
--- @field start number
--- @field finish number

