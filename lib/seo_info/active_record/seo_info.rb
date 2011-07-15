class SeoInfo::ActiveRecord::SeoInfo < ActiveRecord::Base
  
  belongs_to :seoable, :polymorphic => true

  named_scope :ordered_by_model, :order => "seoable_type ASC"
  named_scope :attached_to_url, lambda { |url| 
    path, params = url.split("?")
    if params.blank?
      {:conditions => ["url = ?",path]}
    else
      params = params.split("&") 
      {:conditions => ["url LIKE ?" + (" AND url LIKE ? " * params.count), "#{path}?%"] + params.map{|p| "%?%#{p}%"}}
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

  def self.seo_attribute_names
    self.new.attribute_names - ["created_at", "seoable_id", "seoable_type", "updated_at"]
  end

  self.seo_attribute_names.each do |field|
    define_method field do
      read_attribute(field) || (seoable.blank? ? nil : seoable.send(:"seo_#{field.to_s}"))
    end

    define_method "default_#{field}" do
      (seoable.blank? ? nil : seoable.send(:"seo_#{field.to_s}"))
    end
  end

  def canonical_url
    (seoable.nil? or not(seoable.respond_to?(:canonical_url))) ? url : seoable.canonical_url
  end

end
