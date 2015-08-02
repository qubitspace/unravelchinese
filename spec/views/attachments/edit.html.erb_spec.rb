require 'rails_helper'

RSpec.describe "attachments/edit", type: :view do
  before(:each) do
    @attachment = assign(:attachment, Attachment.create!(
      :post_id => 1,
      :avatar => "MyString"
    ))
  end

  it "renders the edit attachment form" do
    render

    assert_select "form[action=?][method=?]", attachment_path(@attachment), "post" do

      assert_select "input#attachment_post_id[name=?]", "attachment[post_id]"

      assert_select "input#attachment_avatar[name=?]", "attachment[avatar]"
    end
  end
end
