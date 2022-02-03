module ApplicationCable
  class Channel < ActionCable::Channel::Base
    prepend MultiTenancy::Channel
  end
end
