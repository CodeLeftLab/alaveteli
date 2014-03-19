require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe AttachmentToHTML do
    include AttachmentToHTML

    let(:attachment) { FactoryGirl.build(:body_text) }

    describe :to_html do

        it 'sends the attachment to the correct adapter for conversion' do
            AttachmentToHTML::Adapters::Text.should_receive(:new).with(attachment).and_call_original
            to_html(attachment)
        end

        it 'converts the attachment to html in the correct format' do
            expected = AttachmentToHTML::Adapters::Text.new(attachment).to_html
            to_html(attachment).should == expected
        end
 
    end

end