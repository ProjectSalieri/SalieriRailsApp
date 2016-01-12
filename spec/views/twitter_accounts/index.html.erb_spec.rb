require 'spec_helper'

describe "twitter_accounts/index" do
  before(:each) do
    assign(:twitter_accounts, [
      stub_model(TwitterAccount,
        :name_en => "Name En",
        :consumer_key => "Consumer Key",
        :consumer_secret => "Consumer Secret",
        :access_token_key => "Access Token Key",
        :access_token_secret => "Access Token Secret"
      ),
      stub_model(TwitterAccount,
        :name_en => "Name En",
        :consumer_key => "Consumer Key",
        :consumer_secret => "Consumer Secret",
        :access_token_key => "Access Token Key",
        :access_token_secret => "Access Token Secret"
      )
    ])
  end

  it "renders a list of twitter_accounts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name En".to_s, :count => 2
    assert_select "tr>td", :text => "Consumer Key".to_s, :count => 2
    assert_select "tr>td", :text => "Consumer Secret".to_s, :count => 2
    assert_select "tr>td", :text => "Access Token Key".to_s, :count => 2
    assert_select "tr>td", :text => "Access Token Secret".to_s, :count => 2
  end
end
