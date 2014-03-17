module AttachmentToHTML
    module Adapters
        # Convert text/plain documents in to HTML
        class Text

            attr_reader :attachment, :wrapper

            # Public: Initialize a Text converter
            #
            # attachment - the FoiAttachment to convert to HTML
            # opts       - a Hash of options (default: {}):
            #              :wrapper - String id of the div that wraps the
            #                         attachment body
            def initialize(attachment, opts = {})
                @attachment = attachment
                @wrapper = opts.fetch(:wrapper, 'wrapper')
            end

            # Public: Convert the attachment to HTML
            #
            # Returns a String
            def to_html
                html =  "<!DOCTYPE html>"
                html += "<html>"
                html += "<head>"
                html += "<title>#{ title }</title>"
                html += "</head>"
                html += "<body>"
                html += "<div id=\"#{ wrapper }\">#{ body }</div>"
                html += "</body>"
                html += "</html>"
            end

            private

            def title
                attachment.display_filename
            end

            def body
                text = attachment.body.strip
                text = CGI.escapeHTML(text)
                text = MySociety::Format.make_clickable(text)
                text = text.gsub(/\n/, '<br>')
            end

        end
    end
end
