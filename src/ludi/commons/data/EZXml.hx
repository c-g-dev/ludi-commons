package ludi.commons.data;

import haxe.ds.StringMap;
import haxe.xml.Parser;

using StringTools;

class EZXml {
    public static function parse(content: String): XmlNode {
        var rootNode: XmlNode = null;
        var currentNode: XmlNode = null;
        var parentStack: Array<XmlNode> = [];

        var i = 0;
        while (i < content.length) {
            var nextChar = content.charAt(i);
            if (nextChar == '<') {
                var closeBracketIndex = content.indexOf('>', i + 1);
                if (closeBracketIndex == -1) break; // Malformed tag

                var tagContent = content.substring(i + 1, closeBracketIndex).trim();
                trace("Tag content: " + tagContent);

                if (tagContent.startsWith('/')) {
                    // Closing tag
                    currentNode = (parentStack.length == 0) ? null : parentStack.pop();
                    if(currentNode != null) {
                        trace("Closing tag for: " + currentNode.tag);
                    } else {
                        trace("No current node to close.");
                    }
                }
                else if (tagContent.endsWith('/')) {
                    tagContent = tagContent.substring(0, tagContent.length - 1).trim();
                    var singleNode = new XmlNode();
                    populateNode(singleNode, tagContent);
                    if (currentNode != null) {
                        currentNode.children.push(singleNode);
                    }
                    trace("Handling single self-closing node: " + singleNode.tag);
                } 
                else {
                    var spaceIndex = tagContent.indexOf(' ');
                    if (spaceIndex == -1) spaceIndex = tagContent.length;

                    var node = new XmlNode();
                    populateNode(node, tagContent);
                    
                    if (!tagContent.endsWith('/')) {
                        if (currentNode != null) {
                            parentStack.push(currentNode);
                            currentNode.children.push(node);
                            trace("Adding child to " + currentNode.tag + ": " + node.tag);
                        }
                        currentNode = node;
                        if (rootNode == null) {
                            rootNode = node; // First node is the root node
                            trace("Root node: " + rootNode.tag);
                        }
                    }
                }
                i = closeBracketIndex + 1;
            } else {
                var nextOpenBracketIndex = content.indexOf('<', i);
                if (nextOpenBracketIndex == -1) nextOpenBracketIndex = content.length;

                if (currentNode != null && i < nextOpenBracketIndex) {
                     var textContent = content.substring(i, nextOpenBracketIndex).trim();
                    if (!(textContent.length == 0)) {
                        currentNode.content += textContent;
                        trace("Adding text to " + currentNode.tag + ": " + textContent);
                    }
                }
                i = nextOpenBracketIndex;
            }
        }

        return rootNode;
    }

    private static function populateNode(node: XmlNode, tagContent: String): Void {
        trace("populateNode: " + tagContent);
        var spaceIndex = tagContent.indexOf(' ');
        if (spaceIndex != -1) {
            node.tag = tagContent.substring(0, spaceIndex);
            var attrRegex = ~/\b([^=]+)=["']([^"']*)["']/g;
            for (pair in getMatches(attrRegex,tagContent.substring(spaceIndex, tagContent.length))) {
                trace("pair found: " + pair);
                var parts = pair.split('=');
                var attrName = parts[0];
                var attrValue = parts[1].substring(1, parts[1].length - 1);
                node.attrs.set(attrName, attrValue);
                trace("Attribute " + attrName + " = " + attrValue);
            }
        } else {
            trace("no space found");
            node.tag = tagContent; // no attributes case
        }
    }

    static function getMatches(ereg:EReg, input:String, index:Int = 0):Array<String> {
        var matches = [];
        while (ereg.match(input)) {
          matches.push(ereg.matched(index)); 
          input = ereg.matchedRight();
        }
        return matches;
      }

    public static function parseStdLib(xmlString: String): XmlNode {
        var xmlDoc = Xml.parse(xmlString);
        return parseXmlNode(xmlDoc.firstElement());
    }

    private static function parseXmlNode(xmlNode: Xml): XmlNode {
        var node = new XmlNode();
        node.tag = xmlNode.nodeName;
        // Attributes
        for (att in xmlNode.attributes()) {
            var value = xmlNode.get(att);
            node.attrs.set(att, value);
        }

        // Children and content
        for (child in xmlNode) {
            switch (child.nodeType) {
                case Xml.Element: {
                    node.children.push(parseXmlNode(child));
                   // break;
                }
                case Xml.CData:
                case Xml.PCData: {
                    node.content += child.nodeValue;
                    //break;
                }
                default: {
                    // Ignoring other types like Comment, DocType, etc.
                }
            }
        }
        return node;
    }
}


class XmlNode {
    public var tag: String;
    public var attrs: Map<String, String> = [];
    public var content: String = "";
    public var children: Array<XmlNode> = [];

    public function new() {
        
    }

    
    public function allChildrenOf(tag: String): Array<XmlNode> {
        var foundChildren: Array<XmlNode> = [];
        for (child in children) {
            if (child.tag == tag) {
                foundChildren.push(child);
            }
        }
        return foundChildren;
    }

    public function firstChildOf(tag: String): XmlNode {
        for (child in children) {
            if (child.tag == tag) {
                return child;
            }
        }
        return null;
    }

    public function firstChildWhereAttrIs(key: String, value: String): XmlNode {
        for (child in children) {
            if (child.attrs.exists(key) && child.attrs.get(key) == value) {
                return child;
            }
        }
        return null;
    }

    public function printTree(): Void {
        var topmost: XmlNode = this;
        
        function buildTreeString(node: XmlNode, depth: Int): String {
            var indent = "";
            for (i in 0...depth) {
                indent += "\t";
            }
            var result = indent + "<" + node.tag + ">\n";
            for (child in node.children) {
                result += buildTreeString(child, depth + 1);
            }
            result += indent + "</" + node.tag + ">\n";
            return result;
        }
    
        var treeString = buildTreeString(topmost, 0);
        trace(treeString);
    }
}