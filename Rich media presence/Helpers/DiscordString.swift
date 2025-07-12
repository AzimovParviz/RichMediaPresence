//
//  DiscordString.swift
//  Rich media presence
//
//  Created by rosenberg on 28.6.2025.
//

// disordpp.h:
//    Discord_String AllocateString(std::string const& str)
//        {
//            Discord_String result;
//            result.ptr = reinterpret_cast<uint8_t*>(Discord_Alloc(str.size()));
//            result.size = str.size();
//            std::memcpy(result.ptr, str.data(), result.size);
//            return result;
//        }

func convertToDiscordString(strValue: String) -> Discord_String {
    let dsPointer: UnsafeMutablePointer<__uint8_t> = Discord_Alloc(
        strValue.utf8.count
    ).assumingMemoryBound(to: UInt8.self)
    let dsSize: Int = strValue.utf8.count
    // reintrepret_cast
    Array(strValue.utf8).withUnsafeBytes { buffer in
        dsPointer.update(
            from: buffer.baseAddress!.assumingMemoryBound(to: UInt8.self),
            count: dsSize
        )
    }
    let discordString: Discord_String = Discord_String(
        ptr: dsPointer,
        size: dsSize
    )
    return discordString
}

func convertDStoString(_ dStr: Discord_String) -> String {
    // Converting the UInt8 pointer to a CChar buffer pointer
    let dsString = dStr.ptr.withMemoryRebound(
        to: CChar.self,
        capacity: Int(dStr.size)
    ) {
        UnsafeBufferPointer(start: $0, count: Int(dStr.size))
    }
    //converting to a CChar array
    var a = Array(dsString)
    //null terminating the string
    a.append(0)
    let convertedString = String(cString: a)
    //    print("converted string: \(convertedString)")
    return convertedString
}
