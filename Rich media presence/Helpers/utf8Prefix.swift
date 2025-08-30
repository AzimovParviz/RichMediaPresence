//
//  utf8Prefix.swift
//  Rich media presence
//
//  Created by rosenberg on 27.7.2025.
//
//credit: https://stackoverflow.com/a/60628897

extension String {
    func utf8Prefix(_ maxLength: Int) -> Substring {
        if self.utf8.count <= maxLength {
            return Substring(self)
        }

        let endIndex = self.utf8.index(self.startIndex, offsetBy: maxLength)
        var index = self.startIndex
        while index <= endIndex {
            self.formIndex(after: &index)
        }
        self.formIndex(before: &index)
        return self.prefix(upTo: index)
    }
}

