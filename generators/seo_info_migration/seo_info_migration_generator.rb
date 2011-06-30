class SeoInfoMigrationGenerator < Rails::Generator::Base
  def manifest # this method is default entrance of generator

    record do |m| #Convenience method for generator subclasses to record a manifest. 

      m.template "create_seo_infos.rb",File.join("db/migrate","#{Time.now.strftime("%Y%m%d%H%M%S")}_create_seo_infos.rb")

    end
  end
end