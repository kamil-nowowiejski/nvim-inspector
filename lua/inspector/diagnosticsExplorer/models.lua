--- @class Diagnostics
--- @field warnings Issue[]
--- @field errors Issue[]

--- @class Issue
--- @field message
--- @field filePosition?

--- @class FilePosition
--- @field fileName string
--- @field line number?
--- @field column number?

--- @class DiagnosictsLine: BufferLine
--- @field filePosition FilePosition?
