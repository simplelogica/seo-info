class SeoInfo::ActiveRecord::SeoInfo < ActiveRecord::Base
  
  belongs_to :seoable, :polymorphic => true

  named_scope :ordered_by_model, :order => "seoable_type ASC"
  
  validate :has_seoable_or_url

  def has_seoable_or_url
    if seoable.nil? and url.blank?
      self.errors.add_to_base :no_resource_seoizado
    end
  end

  @@classes = []
  cattr_accessor :classes

  [:h1, :title, :description, :footer].each do |field|
    define_method field do
      read_attribute(field) || (seoable.blank? ? nil : seoable.send(:"seo_#{field.to_s}"))
    end
  end

  def canonical_url
    (seoable.nil? or not(seoable.respond_to?(:canonical_url))) ? url : seoable.canonical_url
  end

end
