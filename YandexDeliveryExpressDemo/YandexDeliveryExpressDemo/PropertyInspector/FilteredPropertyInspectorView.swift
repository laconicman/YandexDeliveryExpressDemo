//
//  FilteredPropertyInspectorView.swift
//  YandexDeliveryExpressDemo
//
//  Created by Paul Buktab on 7/23/25.
//

import SwiftUI
import ReflectionHelper

// Наработка на будущее.
struct FilteredPropertyInspectorView: View {
    private let rootNode: PropertyNode
    @State private var searchText = ""
    
    init(object: Any, name: String? = nil, excludeTypes: [String] = []) {
        let objectName = name ?? String(describing: type(of: object))
        self.rootNode = PropertyNode.createPropertyTree(reflecting: object, named: objectName)
    }
    
    var body: some View {
//         NavigationView {
            Group {
                SearchBar(text: $searchText)
//                OutlineGroup(filteredNodes, children: \.children) { node in
//                    PropertyRow(node: node)
//                }
                NodeOutlineGroup(node: filteredNode, childKeyPath: \.children, isExpanded: true) { node in
                    PropertyRow(node: node)
                }
            }
//            .searchable(text: $searchText)
//            .navigationTitle("Property Inspector")
//        }
    }
    
    private var filteredNode: PropertyNode? {
        if searchText.isEmpty {
            return rootNode
        } else {
            return filterNode(rootNode, searchText: searchText)
        }
    }
    
    private func filterNode(_ node: PropertyNode, searchText: String) -> PropertyNode? {
        let matchesSearch = node.name.localizedCaseInsensitiveContains(searchText) ||
                           node.displayValue.localizedCaseInsensitiveContains(searchText)
        
        let filteredChildren = node.children?.compactMap {
            filterNode($0, searchText: searchText)
        }
        
        if matchesSearch || !(filteredChildren?.isEmpty ?? true) {
            return node.replacing(children: filteredChildren)
        }
        
        return nil
    }
}

#Preview {
    List {
        FilteredPropertyInspectorView(object: ["key1": "value1", "key2": "value2"])
    }
}
