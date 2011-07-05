module SeoInfo::ActionController::ActionControllerAdapter

  def self.included(klass)
    
    klass.class_eval do

      def set_seo
        @seo = SeoInfo::ActiveRecord::SeoInfo.find_by_url(request.path)
        @seo ||= SeoInfo::ActiveRecord::SeoInfo.find_by_url("/")
        @seo ||= SeoInfo::ActiveRecord::SeoInfo.new :url => request.url
      end

      before_filter :set_seo

    end

  end

end
