require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe AttachmentToHTML::Adapters::Text do

    let(:attachment) { FactoryGirl.build(:body_text) }
    let(:text_adapter) { AttachmentToHTML::Adapters::Text.new(attachment) }

    describe :wrapper do

        it 'defaults to wrapper' do
           text_adapter.wrapper.should == 'wrapper'
        end

        it 'accepts a wrapper option' do
            text_adapter = AttachmentToHTML::Adapters::Text.new(attachment, :wrapper => 'wrap')
            text_adapter.wrapper.should == 'wrap'
        end
 
    end

    describe :to_html do

        it 'looks roughly like a html document' do
            htmlish = /<!DOCTYPE html>.*<html.*>.*<head>.*<title>.*<\/title>.*<\/head>.*<body.*>.*<\/body>.*<\/html>/im
            text_adapter.to_html.should match(htmlish)
        end

        it 'contains the attachment filename in the title tag' do
            text_adapter.to_html.should match(/<title>#{ attachment.display_filename }<\/title>/)
        end

        it 'contains the wrapper div in the body tag' do
            text_adapter = AttachmentToHTML::Adapters::Text.new(attachment, :wrapper => 'wrap')
            expected = /<body[^>]*\><div id="wrap">.*<\/body>/im
            text_adapter.to_html.should match(expected)
        end

        it 'contains the attachment body in the wrapper div' do
            text_adapter = AttachmentToHTML::Adapters::Text.new(attachment, :wrapper => 'wrap')
            text_adapter.to_html.should match(/<div id="wrap">#{ attachment.body }<\/div>/)
        end
 
    end

end
