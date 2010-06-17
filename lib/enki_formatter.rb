class EnkiFormatter
  class << self
    def format_as_xhtml(text, args = {})
      teaser = args[:teaser]
      args.delete(:teaser) if args[:teaser]
      
      html = Lesstile.format_as_xhtml(
        text,
        :text_formatter => lambda { |text| Moredown.new(CGI::unescapeHTML(text), args).to_html},
        :code_formatter => lambda do |code, language|
          unless language
            "<pre><code>#{code}</code></pre>"
          else
            "<pre><code class=\"#{language}\">#{code}</code></pre>"
          end
        end
      )
      
      if teaser
        paragraphs = html.scan(/<p.*?p>/)
        if paragraphs.first.match(/<p><img.+?\/><\/p>/) or paragraphs.first.match(/<p><object.+?<\/object><\/p>/)
          paragraphs[1]
        else
          paragraphs.first
        end
      else
        html
      end
    end
  end
end