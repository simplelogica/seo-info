class SeoInfoInitializerGenerator < Rails::Generator::Base
  def manifest # this method is default entrance of generator

    record do |m| #Convenience method for generator subclasses to record a manifest. 

      m.template "seo_info.rb",File.join("config/initializers","seo_info.rb")

    end
  end
end