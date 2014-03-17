Dir[File.dirname(__FILE__) + '/adapters/*.rb'].each do |file|
    require file
end

module AttachmentToHTML
    extend self

    def to_html(attachment)
        converter = adapter_for(attachment.content_type)
        converter.new(attachment).to_html
    end

    private

    def adapter_for(content_type)
        case content_type
        when 'text/plain' then Adapters::Text
        when 'application/pdf' then Adapters::PDF
        end
    end

end
