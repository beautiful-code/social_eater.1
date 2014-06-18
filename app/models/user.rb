class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  acts_as_voter

  serialize :friend_fb_ids, Array
  serialize :friend_ids, Array

  after_create :fetch_pic!


  #->Prelang (user_login/devise)
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    token = auth["credentials"]["token"]
    token_expires_at = auth["credentials"]["expires_at"]

    # The User was found in our database
    if user
      # Update facebook auth token

      if token != user.token
        user.update_attribute(:token, token)
        user.update_attribute(:token_expires, token_expires_at)
        user.fetch_fb_friends!
      end

      return user
    end

    # The User was not found and we need to create them
    user = User.create(name:     auth.extra.raw_info.name,
                provider: auth.provider,
                uid:      auth.uid,
                email:    auth.info.email,
                password: Devise.friendly_token[0,20],
                token: token,
                token_expires: token_expires_at
                )
    user.fetch_fb_friends!
    user
  end

  def fetch_pic!
    graph = Koala::Facebook::API.new(token, ENV['FACEBOOK_SECRET_ID'])
    pic_url = graph.get_object("me", :fields => 'picture')["picture"]["data"]["url"]

    update_attribute(:provider_pic, pic_url)
  end

  def fetch_fb_friends!
    graph = Koala::Facebook::API.new(token, ENV['FACEBOOK_SECRET_ID'])

    friend_ids = graph.get_connections("me", "friends").collect {|h| h['id']}

    update_attribute(:friend_fb_ids, friend_ids)
    infer_friend_ids_from_fb_ids!
  end

  def infer_friend_ids_from_fb_ids!
    update_attribute(:friend_ids, User.where(uid: friend_fb_ids).collect(&:id))
  end

  def friends_like_item item
    User.find(friend_ids & item.voter_ids)
  end


end
