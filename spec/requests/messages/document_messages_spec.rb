require "spec_helper"

describe "Document messages" do
  let(:thread) { FactoryGirl.create(:message_thread) }

  def document_form
    within("#new-document-message") { yield }
  end

  context "new" do
    include_context "signed in as a site user"

    before do
      visit thread_path(thread)
    end

    it "should post a document message" do
      document_form do
        attach_file("File", pdf_document_path)
        fill_in "Title", with: "An important document"
        click_on "Add Attachment"
      end

      page.should have_content("Attachment added")
      page.should have_content("An important document")
      page.should have_link("Download Attachment")
    end
  end

  context "show" do
    let(:message) { FactoryGirl.create(:message, thread: thread) }
    let!(:document_message) { FactoryGirl.create(:document_message, message: message, created_by: FactoryGirl.create(:user)) }

    before do
      visit thread_path(thread)
    end

    it "should show the title and have a link" do
      page.should have_content(document_message.title)
      page.should have_link("Download Attachment")
    end

    it "should download the document" do
      click_on "Download"
      page.response_headers["Content-Type"].should == document_message.file.mime_type
      page.response_headers["Content-Disposition"].should include("filename=\"#{document_message.file_name}\"")
    end
  end
end
