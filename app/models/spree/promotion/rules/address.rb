# A rule to apply to an order greater than (or greater than or equal to)
# a specific amount
module Spree
  class Promotion
    module Rules
      class Address < PromotionRule
        preference :address, :string, default: ''

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, _options = {})

          ship_address = order&.ship_address&.address1&.downcase

          if ship_address.blank? || preferred_address.split(' ').blank?
            eligibility_errors.add(:base, 'no tiene dirección configurada')
          else
            valid_address = true
            preferred_address.split(' ').each do |element|
              unless ship_address.include? element.downcase
                valid_address = false
                break
              end
            end
            eligibility_errors.add(:base, 'su dirección no tiene promoción') unless valid_address
          end

          eligibility_errors.empty?
        end
      end
    end
  end
end
