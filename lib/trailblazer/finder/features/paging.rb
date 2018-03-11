module Trailblazer
  class Finder
    module Features
      module Paging
        def self.included(base)
          base.extend ClassMethods
        end

        attr_reader :page, :per_page

        def initialize(options = {})
          @page     = [options[:page].to_i, 0].max
          @per_page = self.class.calculate_per_page options[:per_page]

          super options
        end

        private

        def fetch_results
          apply_paging super
        end

        # Adapters will overwite this method
        def apply_paging(entity_type)
          entity_type.drop(([page, 1].max - 1) * per_page).first(per_page)
        end

        module ClassMethods
          def per_page(number)
            raise Error::InvalidNumber.new('Per page', number) unless number > 0
            config[:per_page] = number
          end

          def min_per_page(number)
            raise Error::InvalidNumber.new('Min per page', number) unless number > 0
            config[:min_per_page] = number
          end

          def max_per_page(number)
            raise Error::InvalidNumber.new('Max per page', number) unless number > 0
            config[:max_per_page] = number
          end

          def calculate_per_page(given)
            per_page = (given || config[:per_page] || 25).to_i.abs
            per_page = [per_page, config[:max_per_page]].min if config[:max_per_page]
            per_page = [per_page, config[:min_per_page]].max if config[:min_per_page]
            per_page
          end
        end
      end
    end
  end
end
