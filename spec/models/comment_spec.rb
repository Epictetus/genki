require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  def valid_comment_attributes(extra = {})
    {
      :author => 'Don Alias',
      :body   => 'This is a comment',
      :post   => Post.new
    }.merge(extra)
  end

  def set_comment_attributes(comment, extra = {})
    valid_comment_attributes(extra).each_pair do |key, value|
      comment.send("#{key}=", value)
    end
  end

  before(:each) do
    @comment = Comment.new
  end

  it "is invalid with no post" do
    set_comment_attributes(@comment, :post => nil)
    @comment.should_not be_valid
    @comment.errors.on(:post).should_not be_blank
  end

  it "is invalid with no body" do
    set_comment_attributes(@comment, :body => '')
    @comment.should_not be_valid
    @comment.errors.on(:body).should_not be_blank
  end

  it "is invalid with no author" do
    set_comment_attributes(@comment, :author => '')
    @comment.should_not be_valid
    @comment.errors.on(:author).should_not be_blank
  end

  it "is valid with a full set of valid attributes" do
    set_comment_attributes(@comment)
    @comment.should be_valid
  end

  it "requires OpenID authentication when the author's name contains a period" do
    @comment.author = "Don Alias"
    @comment.requires_openid_authentication?.should == false
    @comment.author = "enkiblog.com"
    @comment.requires_openid_authentication?.should == true
  end

  it "asks post to update it's comment counter after save" do
    @comment.class.after_save.include?(:denormalize).should == true
    @comment.post = mock_model(Post)
    @comment.post.should_receive(:denormalize_comments_count!)
    @comment.denormalize
  end

  it "asks post to update it's comment counter after destroy" do
    @comment.class.after_destroy.include?(:denormalize).should == true
    @comment.post = mock_model(Post)
    @comment.post.should_receive(:denormalize_comments_count!)
    @comment.denormalize
  end

  it "applies a Markdown filter to body and store it in body_html before save" do
    @comment.class.before_save.include?(:apply_filter).should == true
    Lesstile.should_receive(:format_as_xhtml).and_return("formatted")
    @comment.apply_filter
  end

  it "responds to trusted_user? for defensio integration" do
    @comment.respond_to?(:trusted_user?).should == true
  end

  it "responds to user_logged_in? for defensio integration" do
    @comment.respond_to?(:user_logged_in?).should == true
  end

  it "delegates post_title to post" do
    @comment.post = mock_model(Post)
    @comment.post.should_receive(:title).and_return("hello")
    @comment.post_title.should == "hello"
  end

  # TODO: acts_as_defensio_comment tests
  # TODO: OpenID error model
end

describe Comment, '#blank_openid_fields_if_unused' do
  before(:each) do
    @comment = Comment.new
    @comment.blank_openid_fields
  end

  it('blanks out author_url')              { @comment.author_url.should == '' }
  it('blanks out author_email')            { @comment.author_email.should == '' }
end

describe Comment, '.find_recent' do
  it 'finds the most recent comments that were posted before now' do
    now = Time.now
    Time.stub!(:now).and_return(now)
    Comment.should_receive(:find).with(:all, {
      :order      => 'created_at DESC',
      :limit      => Comment::DEFAULT_LIMIT
    }).and_return(comments = [mock_model(Comment)])
    Comment.find_recent.should == comments
  end

  it 'allows and override of the default limit' do
    Comment.should_receive(:find).with(:all, hash_including(:limit => 999))
    Comment.find_recent(:limit => 999)
  end
end

describe Comment, '.build_for_preview' do
  before(:each) do
    @comment = Comment.build_for_preview(:author => 'Don Alias', :body => 'A Comment')
  end

  it 'returns a new comment' do
    @comment.should be_new_record
  end

  it 'sets created_at' do
    @comment.created_at.should_not be_nil
  end

  it 'applies filter to body' do
    @comment.body_html.should == "<p>A Comment</p>\n"
  end
end

describe Comment, '.build_for_preview with OpenID author' do
  before(:each) do
    @comment = Comment.build_for_preview(:author => 'http://enkiblog.com', :body => 'A Comment')
  end

  it 'returns a new comment' do
    @comment.should be_new_record
  end

  it 'sets created_at' do
    @comment.created_at.should_not be_nil
  end

  it 'applies filter to body' do
    @comment.body_html.should == "<p>A Comment</p>\n"
  end

  it 'sets author_url to OpenID identity' do
    @comment.author_url.should == 'http://enkiblog.com'
  end

  it 'sets author to "Your OpenID Name"' do
    @comment.author.should == "Your OpenID Name"
  end
end
