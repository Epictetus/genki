class EnkiFormatter
  class << self
    def format_as_xhtml(text)
      Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda { |text| Moredown.new(CGI::unescapeHTML(text)).to_html},
        :code_formatter => lambda do |code, language|
          unless language
            "<pre><code>#{code}</code></pre>"
          else
            "<pre class=\"prettyprint #{language}\"><code>#{code}</code></pre>"
          end
        end
      )  
    end
    
    def format_teaser_as_xhtml (text)
      html = self.format_as_xhtml(text)
      paragraphs = html.scan(/<p.*?p>/)
      if paragraphs.first.match(/<p><img.+?\/><\/p>/) or paragraphs.first.match(/<p><object.+?<\/object><\/p>/)
        paragraphs[1]
      else
        paragraphs.first
      end
    end
  end
end