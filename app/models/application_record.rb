class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.update_or_create(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj.save
    return obj
  end
end
