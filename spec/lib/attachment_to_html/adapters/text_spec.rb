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
 
        it 'strips the body of trailing whitespace' do
            attachment = FactoryGirl.build(:body_text, :body => ' Hello ')
            expected = 'Hello'
            text_adapter = AttachmentToHTML::Adapters::Text.new(attachment)
            text_adapter.to_html.should match(/<div id="wrapper">#{ expected }<\/div>/)
        end

        it 'escapes special characters' do
           attachment = FactoryGirl.build(:body_text, :body => 'Usage: foo "bar" <baz>')
           expected = "Usage: foo &quot;bar&quot; &lt;baz&gt;"
           text_adapter = AttachmentToHTML::Adapters::Text.new(attachment)
           text_adapter.to_html.should match(/<div id="wrapper">#{ expected }<\/div>/)
        end

        it 'creates hyperlinks for text that looks like a url' do
            attachment = FactoryGirl.build(:body_text, :body => 'http://www.whatdotheyknow.com')
            expected = %Q(<a href='http://www.whatdotheyknow.com'>http://www.whatdotheyknow.com</a>)
            text_adapter = AttachmentToHTML::Adapters::Text.new(attachment)
            text_adapter.to_html.should match(/<div id="wrapper">#{ expected }<\/div>/)
        end

        it 'substitutes newlines for br tags' do
            attachment = FactoryGirl.build(:body_text, :body => "A\nNewline")
            expected = %Q(A<br>Newline)
            text_adapter = AttachmentToHTML::Adapters::Text.new(attachment)
            text_adapter.to_html.should match(/<div id="wrapper">#{ expected }<\/div>/)
        end

    end

end
