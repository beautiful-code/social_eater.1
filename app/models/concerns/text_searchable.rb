module TextSearchable
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
  end


  def kind
    self.class.name
  end

  def as_json options={}
    options ||= {}
    options[:methods] ||= [:kind,:name,:url]
    super(options)
  end

end