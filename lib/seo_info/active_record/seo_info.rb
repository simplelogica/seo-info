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

end
