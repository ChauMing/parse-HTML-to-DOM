html = <<HTM
    <p> hfjdslfjs;d </p>
    <!DOCTYPE html>
    <html lang="en"><head>
        <meta charset="UTF-8">
        <title>Document</title>
    </head>
    <body>
        <header>
            <nav>
                <ul>
                    <li class="nav-list">
                        <a href="http://baidu.com" class="nav-link"></a>
                        <a href="http://202.202.43.125" class="nav-link"></a>
                        <a href="http://202.202.43.42" class="nav-link"></a>
                        <a href="http://202.202.43.41" class="nav-link"></a>
                        <a href="http://202.202.43.120" class="nav-link"></a>
                    </li>
                </ul>
            </nav>
        </header>
        <content>
            <section class="content-row">
                <div class="row-div">
                    <a href="http://202.202.43.42" class="link">
                        <img src="blog/app/assets/config/manifest.js" alt="">
                    </a>
                </div>
                <div class="row-div">
                    <a href="http://202.202.43.42" class="link">
                        <img src="blog/app/assets/config/manifest.js" alt="">
                    </a>
                </div>
                <div class="row-div">
                    <a href="http://202.202.43.42" class="link">
                        <img src="blog/app/assets/config/manifest.js" alt="">
                    </a>
                </div>
            </section>
            <p>hello world</p>
        </content>
        <footer>
            <p class="comp-name">cqupt</p>
            <p class="comp-adress">广西柳州</p>
            <p class="comp-phone">13237725597</p>
        </footer>
    </body>
    </html>
HTM


## tag node info for generator node
NodeInfo = Struct.new(:current_tag, :pos)


## todo
module NodeMethod
    def getElementsByTagName 
    end
    def getElementById
    end
    def getElementsByClassName
    end
    def getAttributes
    end
    def hasAttributes
    end
end


# todo
module NodeAttr
    attr_accessor :innerHTML,
                  :className,
                  :id,
                  :children,
                  :attributes,
                  :outerHTML,
                  :tagName,
                  :parent
end


# node class
class Node
    include NodeMethod, NodeAttr
    attr_accessor  :current_tag, :pos
    private :current_tag, :pos
    class << self
        attr_accessor :html
    end
    def initialize node_info
        @tagName = nil    ## tagname
        @current_tag = node_info.current_tag
        m = /<(\/?[a-z]+).*?>/.match(@current_tag)
        @tagName = m[1] if m
        @pos = node_info.pos
        @children = []
    end
    def close pos
        pos = pos+@tagName.length+2
        @outerHTML = Node.html[@pos..pos]
        @innerHTML = @outerHTML[@current_tag.length..@outerHTML.length - @tagName.length-4]
    end
end


# parse html
module ParseHTML
    attr_accessor :html, :tags
    def generate html
        @html = html
        Node.html = @html
        find_tags
        parse_dom_tree
    end

    def is_single_tag tag
        flag = false
        ['img', 'input', 'br', 'meta'].each do |single_tag| 
            flag = tag.include?(single_tag)
            if flag == true
                return flag
            end
        end
        flag
    end

    def is_close_tag tag
        (/<\// =~ tag) != nil
    end
    def find_tags
        tag_reg = /<\/?[\s\S]+?>/
        @tags = []
        @html.scan tag_reg do |tag|  
            unless (/!/ =~ tag) != nil
                @tags.push tag 
            end
        end
    end

    def parse_dom_tree
        root = Node.new(NodeInfo.new('<root>', 0))
        root.close(@html.length)
        pointor = root
        pre_index = 0

        @tags.each do |tag|
            reg = Regexp.new tag
            index = @html.index reg, pre_index
            match_tag = reg.match(@html).to_s
            pre_index = index
            if !is_close_tag(match_tag)
                node_info = NodeInfo.new(match_tag, index)
                node = Node.new node_info
                node.parent = pointor
                pointor.children.push node
                pointor = node
                if is_single_tag match_tag
                    pointor.close(index + match_tag.length)
                    pointor = pointor.parent
                end
            else
                pointor.close index
                pointor = pointor.parent
            end
        end
        root
    end
end


class Document 
    class << self
        include ParseHTML
    end
end
root = Document.generate(html)






def pre_loop node#, &block
    puts node.outerHTML
    puts '---------------------------------------'
    node.children.each  do |child|
        pre_loop child
    end
end

pre_loop root





















