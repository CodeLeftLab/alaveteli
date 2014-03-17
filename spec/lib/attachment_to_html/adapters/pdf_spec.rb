require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe AttachmentToHTML::Adapters::PDF do

    let(:attachment) { FactoryGirl.build(:pdf_attachment) }
    let(:pdf_adapter) { AttachmentToHTML::Adapters::PDF.new(attachment) }

    describe :wrapper do

        it 'defaults to wrapper' do
           pdf_adapter.wrapper.should == 'wrapper'
        end

        it 'accepts a wrapper option' do
            pdf_adapter = AttachmentToHTML::Adapters::PDF.new(attachment, :wrapper => 'wrap')
            pdf_adapter.wrapper.should == 'wrap'
        end
 
    end

    describe :tmpdir do

        it 'defaults to the rails tmp directory' do
           pdf_adapter.tmpdir.should == Rails.root.join('tmp') 
        end

        it 'allows a tmpdir to be specified to store the converted document' do
            pdf_adapter = AttachmentToHTML::Adapters::PDF.new(attachment, :tmpdir => '/tmp')
            pdf_adapter.tmpdir.should == '/tmp'
        end
  
    end

    describe :to_html do

        it 'looks roughly like a html document' do
            htmlish = /<!DOCTYPE html>.*<html.*>.*<head>.*<title>.*<\/title>.*<\/head>.*<body.*>.*<\/body>.*<\/html>/im
            pdf_adapter.to_html.should match(htmlish)
        end

        it 'contains the attachment filename in the title tag' do
            pdf_adapter.to_html.should match(/<title>#{ attachment.display_filename }<\/title>/)
        end

        it 'contains the wrapper div in the body tag' do
            pdf_adapter = AttachmentToHTML::Adapters::PDF.new(attachment, :wrapper => 'wrap')
            expected = /<body[^>]*\><div id="wrap">.*<\/body>/im
            pdf_adapter.to_html.should match(expected)
        end
 
        it 'contains the attachment body in the wrapper div' do
            pdf_adapter = AttachmentToHTML::Adapters::PDF.new(attachment, :wrapper => 'wrap')
            pdf_adapter.to_html.should match(/<div id="wrap">.*thisisthebody.*<\/div>/im)
        end

        it 'operates in the context of the supplied tmpdir' do
            pdf_adapter = AttachmentToHTML::Adapters::PDF.new(attachment, :tmpdir => '/tmp')
            Dir.should_receive(:chdir).with('/tmp').and_call_original
            pdf_adapter.to_html
        end

    end
end
