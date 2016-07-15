# parse html string to DOM

### how ?

```ruby
require 'ParseHTML.rb'
html = '<div id="box">hello world<div>'

doc = Document.generate(html)
box = doc.getElementById('box')
box.innerHTML # => hello world
box.id #=> 'box'
```

`Document.generate`return  root node 

you can use dom attributes and dom method

+ method

  ```ruby
  Element.getElementById(id=String) # => search element by id return a DOM element

  Element.getElementsByTagName(tagName=String) # => search element by tagName return a DOM element array

  Element.getElementsByClassName(className=String) # => search element by className return a DOM element aray

  Element.getAttributes(String) # => search element's attribute return attribute string

  Element.hasAttributes(String) #=> if element has attributes return true else reture false
  ```

  ​


+ attributes

  ``` ruby
  Element.className # string,  element's className

  Element.id # string element's id

  Element.innerHTML #string element's innerHTML

  Element.outerHTML # string element's outerHTML

  Element.tagName # string element's tagName

  Element.parent #  element's parent return a DOM element

  Element.children # element'children return DOM element array
  ```

  ​

