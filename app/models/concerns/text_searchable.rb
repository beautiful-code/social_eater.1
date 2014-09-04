module TextSearchable

  def kind
    self.class.name
  end

  def as_json options={}
    options ||= {}
    options[:methods] ||= [:kind,:name]
    super(options)
  end

end