class SeoInfo::ActiveRecord::SeoInfo < ActiveRecord::Base
  
  belongs_to :seoable, :polymorphic => true

  named_scope :ordered_by_model, :order => "seoable_type ASC"
  named_scope :attached_to_url, lambda { |url| 
    path, params = url.split("?")
    if params.blank?
      {:conditions => ["url = ?",path]}
    else
      params = params.split("&").select{|p| @@ignored_url_params.detect{|ignored_param| p.start_with? ignored_param}.nil?}
      {:conditions => ["url LIKE ?" + (" AND url LIKE ? " * params.length), "#{path}?%"] + params.map{|p| "%?%#{p}%"}}
    end
    
  }

  validate :has_seoable_or_url

  def has_seoable_or_url
    if seoable.nil? and url.blank?
      self.errors.add_to_base "no_resource_seoizado"
    end
  end

  @@classes = []
  cattr_accessor :classes

  @@ignored_url_params = ["utm_medium","utm_source","utm_campaign","utm_content","utm_term"]
  cattr_accessor :ignored_url_params

  def self.seo_attribute_names
    self.new.attribute_names - ["created_at", "seoable_id", "seoable_type", "updated_at"]
  end

  if self.table_exists?
    self.seo_attribute_names.each do |field|
      define_method field do
        read_attribute(field) || (seoable.blank? ? nil : seoable.send(:"seo_#{field.to_s}"))
      end

      define_method "default_#{field}" do
        (seoable.blank? ? nil : seoable.send(:"seo_#{field.to_s}"))
      end
    end
  end

  def canonical_url
    (seoable.nil? or not(seoable.respond_to?(:canonical_url))) ? url : seoable.canonical_url
  end

end
