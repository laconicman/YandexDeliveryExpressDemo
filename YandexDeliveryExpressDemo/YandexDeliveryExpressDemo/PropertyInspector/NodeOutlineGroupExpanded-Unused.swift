//
//  NodeOutlineGroupExpanded.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/23/25.
//

import SwiftUI
// An attempt to create outline that remembers its `expansionStates` even between searches.
// see: https://stackoverflow.com/questions/62832809/list-or-outlinegroup-expanded-by-default-in-swiftui
// see: https://fpposchmann.de/an-improved-version-of-nodeoutlinegroup/(for case when all deeper levels should reset)
struct NodeOutlineGroupExpanded<Node, Content>: View where Node: Hashable, Node: Identifiable, Node: CustomStringConvertible, Content: View {
    let node: Node?
    let childKeyPath: KeyPath<Node, [Node]?>
    @Binding var expansionStates: [Node.ID: Bool]
    let isExpandedAtFirst: Bool
    let content: (Node) -> Content
    
    var body: some View {
        if let node {
            if node[keyPath: childKeyPath] != nil {
                DisclosureGroup(
                    isExpanded: Binding(
                        get: { expansionStates[node.id, default: isExpandedAtFirst] },
                        set: { expansionStates[node.id] = $0 }
                    ),
                    content: {
                        if expansionStates[node.id, default: isExpandedAtFirst] {
                            ForEach(node[keyPath: childKeyPath]!) { childNode in
                                NodeOutlineGroupExpanded(node: childNode, childKeyPath: childKeyPath, expansionStates: $expansionStates, isExpandedAtFirst: isExpandedAtFirst, content: content)
                            }
                        }
                    },
                    label: { content(node) })
                //.id("\(node.id) \(String(describing: expansionStates[node.id]))")
            } else {
                content(node)
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    @Previewable @State var expansionStates: [FileItem.ID: Bool] = [:]
    List {
        NodeOutlineGroupExpanded(
            node: FileItem.previewData,
            childKeyPath: \.children,
            expansionStates: $expansionStates, isExpandedAtFirst: true
        ) { node in
            Text(node.description)
        }
        ForEach(Array(expansionStates), id: \.key) { (key, value) in
            Text("\(key.description) : \(value)")
        }
    }

}


