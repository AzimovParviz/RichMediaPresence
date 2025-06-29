//
//  DiscordString.swift
//  Rich media presence
//
//  Created by rosenberg on 28.6.2025.
//

class DiscordString {
    var value: String;
    init(val: String) {
        self.value = val
    }
// disordpp.h:
//    Discord_String AllocateString(std::string const& str)
//        {
//            Discord_String result;
//            result.ptr = reinterpret_cast<uint8_t*>(Discord_Alloc(str.size()));
//            result.size = str.size();
//            std::memcpy(result.ptr, str.data(), result.size);
//            return result;
//        }
    func convertToDiscordString() -> Discord_String {
        let dsPointer: UnsafeMutablePointer<__uint8_t> = Discord_Alloc(self.value.utf8.count).assumingMemoryBound(to: UInt8.self)
        let dsSize: Int = self.value.utf8.count
        Array(self.value.utf8).withUnsafeBytes { buffer in
            dsPointer.update(from: buffer.baseAddress!.assumingMemoryBound(to: UInt8.self), count: dsSize)
            }
        let discordString: Discord_String = Discord_String(ptr: dsPointer, size: dsSize)
//        print("Discord string represntation: ", convertDStoString(discordString))
        return discordString
    }
}
