module Blog
  class Article
    include Mongoid::Document
    include Mongoid::Pagination
    include Mongoid::Paperclip

    store_in :collection => 'articles'
    
    field :slug, :type => String  
    field :title, :type => String
    field :summary, :type => String
    field :author, :type => String
    field :body, :type => String
    field :tags, :type => Array
    field :published_at, :type => Time, :default => lambda { Time.now.utc }
    field :language, :type => String

    field :owner_id, :type => String

    has_mongoid_attached_file :photo, :path => ":class/:id_:filename"

    validates_presence_of :title

    class << self
      def global(language=nil, page=0, per_page=10)
        owned language, nil, page, per_page
      end

      def owned(language, owner_id, page=0, per_page=10)
        page = page.to_i rescue 0

        query = where :owner_id => owner_id 
        query = query.any_of language_params(language)
        query = query.order_by [:published_at, :desc]
        query = query.paginate(:page => page, :limit => per_page)
      end

      private

        def language_params(language)
          [{:language => language}, {:language => ''}, {:language => nil}]
        end
    end

    def to_param
      slug || _id.to_s
    end

    def offsite?
      /^https?:\/\//.match(body) ? true : false
    end
  end
end