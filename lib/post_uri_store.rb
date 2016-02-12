class PostUriStore
  class << self

    def set(url)
      @@urls ||= []
      @@urls << url
    end

    def urls
      @@urls
    end

  end
end
