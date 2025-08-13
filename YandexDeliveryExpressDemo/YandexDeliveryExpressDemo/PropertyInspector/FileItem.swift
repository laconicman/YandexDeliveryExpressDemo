//
//  Untitled.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/24/25.
//
// TODO: place this file into preview data

#if DEBUG
struct FileItem: Hashable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    var name: String
    var children: [FileItem]? = nil
    var description: String {
        switch children {
        case nil:
            return "📄 \(name)"
        case .some(let children):
            return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
        }
    }
}

extension FileItem {
    static let previewData: FileItem =
    FileItem(name: "users", children:
                [FileItem(name: "user1234", children:
                            [FileItem(name: "Photos", children:
                                        [FileItem(name: "photo001.jpg"),
                                         FileItem(name: "photo002.jpg")]),
                             FileItem(name: "Movies", children:
                                        [FileItem(name: "movie001.mp4")]),
                             FileItem(name: "Documents", children: [])
                            ]),
                 FileItem(name: "newuser", children:
                            [FileItem(name: "Documents", children: [])
                            ])
                ])
}
#endif
