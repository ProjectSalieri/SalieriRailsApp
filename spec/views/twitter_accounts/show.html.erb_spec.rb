require 'spec_helper'

describe "twitter_accounts/show" do
  before(:each) do
    @twitter_account = assign(:twitter_account, stub_model(TwitterAccount,
      :name_en => "Name En",
      :consumer_key => "Consumer Key",
      :consumer_secret => "Consumer Secret",
      :access_token_key => "Access Token Key",
      :access_token_secret => "Access Token Secret"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name En/)
    rendered.should match(/Consumer Key/)
    rendered.should match(/Consumer Secret/)
    rendered.should match(/Access Token Key/)
    rendered.should match(/Access Token Secret/)
  end
end
