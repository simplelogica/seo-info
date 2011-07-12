module SeoInfo::ActiveRecord::ActiveRecordAdapter

  def self.included(klass)
    
    klass.instance_eval do

      # if a model has seo
      def has_seo options={}

        # we create the has_one relationship
        has_one :seo_info, :class_name=>"SeoInfo::ActiveRecord::SeoInfo", :as => :seoable, :dependent => (options[:dependent] || :nullify)

        # we create methods for seo_hooks.
        # if a method name is passed we execute it, otherwise nil is returned
        unless options[:hooks].blank?
          [:h1, :title, :description, :footer].each do |field|
            define_method :"seo_#{field}" do
              options[:hooks][field].blank? ? nil : self.send(options[:hooks][field])
            end
          end
        end

        # if 'default' is enabled, instance.seo_info must always return a SeoInfo (although it's not saved)
        if options[:default]
          alias_method :original_seo_info, :seo_info
          define_method "seo_info" do
            original_seo_info || SeoInfo::ActiveRecord::SeoInfo.new(:seoable => self)
          end
        end

        
        SeoInfo::ActiveRecord::SeoInfo.classes << self.name unless SeoInfo::ActiveRecord::SeoInfo.classes.include?(self.name)


      end

    end


    klass.class_eval do

      def create_seo
        self.seo_info.save        
      end

    end
    
  end

end
