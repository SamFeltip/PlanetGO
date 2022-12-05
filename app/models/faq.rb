# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :string
#  question   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  answered   :boolean          default(FALSE)
#  displayed   :boolean          default(FALSE)
#
class Faq < ApplicationRecord
end
