
public extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}

public struct Array2D<T> {
    
    public let columns      : Int
    public let rows         : Int
    fileprivate var array   : [T]
    
    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows*columns)
    }
    
    public subscript(column: Int, row: Int) -> T {
        get {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row*columns + column]
        }
        set {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row*columns + column] = newValue
        }
    }
}

public struct Array1D<T> {
    
    public let rows: Int
    fileprivate var array: [T]
    
    public init(rows: Int, initialValue: T) {
        self.rows = rows
        array = .init(repeating: initialValue, count: rows)
    }
    
    public subscript(row: Int) -> T {
        get {
            return array[row]
        }
        set {
            array[row] = newValue
        }
    }
}
//TODO:-Check unique Arr
extension Sequence where Element: Hashable {

    /// Returns true (unique) if no element is equal to any other element.
    func isDistinct() -> Bool {
        var set = Set<Element>()
        for e in self {
            if set.insert(e).inserted == false { return false }
        }
        return true
    }
}
//TODO:-Remove Duplicate Arr
extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
//TODO:-Get duplicate Array
extension Array where Element: Hashable {
    ///Return duplicate array 
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: {$0})
        let duplicateGroups = groups.filter {$1.count > 1}
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
    }
}
