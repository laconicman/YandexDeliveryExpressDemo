//
//  NodeOutlineGroup.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/23/25.
//

import SwiftUI

// see: https://stackoverflow.com/questions/62832809/list-or-outlinegroup-expanded-by-default-in-swiftui
struct NodeOutlineGroup<Node: Identifiable, Content: View>: View where Node: CustomStringConvertible{
    let node: Node?
    let childKeyPath: KeyPath<Node, [Node]?>
    @State var isExpanded: Bool = true
    /* @ViewBuilder */ // Uncomment if `Content` can be multiple views
    let content: (Node) -> Content
    
    var body: some View {
        if let node {
            if node[keyPath: childKeyPath] != nil {
                DisclosureGroup(
                    isExpanded: $isExpanded,
                    content: {
                        if isExpanded {
                            ForEach(node[keyPath: childKeyPath]!) { childNode in
                                NodeOutlineGroup(node: childNode, childKeyPath: childKeyPath, isExpanded: isExpanded, content: content)
                            }
                        }
                    },
                    label: { content(node) })
            } else {
                content(node)
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    List {
        NodeOutlineGroup(node: FileItem.previewData, childKeyPath: \.children, isExpanded: true) { node in
            Text(node.description)
        }
    }
}
